//
//  CMModel.m
//  CoffeeMe
//
//  Created by min on 5/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMModel.h"

static FMDatabase *database_ = nil;

@implementation CMModel

@synthesize pk = pk_;

#define DEG2RAD(degrees) (degrees * 0.01745327) // degrees * pi over 180

static void distanceFunc(sqlite3_context *context, int argc, sqlite3_value **argv) {
    // check that we have four arguments (lat1, lon1, lat2, lon2)
    assert(argc == 4);
    // check that all four arguments are non-null
    if (sqlite3_value_type(argv[0]) == SQLITE_NULL || sqlite3_value_type(argv[1]) == SQLITE_NULL || sqlite3_value_type(argv[2]) == SQLITE_NULL || sqlite3_value_type(argv[3]) == SQLITE_NULL) {
        sqlite3_result_null(context);
        return;
    }
    // get the four argument values
    double lat1 = sqlite3_value_double(argv[0]);
    double lon1 = sqlite3_value_double(argv[1]);
    double lat2 = sqlite3_value_double(argv[2]);
    double lon2 = sqlite3_value_double(argv[3]);
    // convert lat1 and lat2 into radians now, to avoid doing it twice below
    double lat1rad = DEG2RAD(lat1);
    double lat2rad = DEG2RAD(lat2);
    // apply the spherical law of cosines to our latitudes and longitudes, and set the result appropriately
    // 6378.1 is the approximate radius of the earth in kilometres
    sqlite3_result_double(context, acos(sin(lat1rad) * sin(lat2rad) + cos(lat1rad) * cos(lat2rad) * cos(DEG2RAD(lon2) - DEG2RAD(lon1))) * 6378.1);
}

+ (void)establishConnection {
    if (database_ == nil) {
        NSString *databaseName = @"coffeeme.sqlite3";

    	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    	NSString *documentsDir = [documentPaths objectAtIndex:0];
    	NSString *databasePath = [documentsDir stringByAppendingPathComponent:databaseName];

    	NSFileManager *fileManager = [NSFileManager defaultManager];

        if (![fileManager fileExistsAtPath:databasePath]) {
            NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
            [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
        	[fileManager release];
        }

        database_ = [[FMDatabase alloc] initWithPath:[[documentPaths objectAtIndex:0] stringByAppendingPathComponent:databaseName]];
        [database_ open];
     	[database_ setCrashOnErrors:NO];
    }
    
    sqlite3_create_function([database_ sqliteHandle], "distance", 4, SQLITE_UTF8, NULL, &distanceFunc, NULL, NULL);
}

+ (id)query:(NSString *)sql {
    return [self fromDB:[[CMModel connection] executeQuery:sql]];
}

- (id)query:(NSString *)sql {
    return [[self class] query:sql];
}

+ (FMDatabase *)connection {
    return database_;
}

+ (id)fromJSON:(id)json {
	if ([json isKindOfClass:[NSArray class]]) {
        NSMutableArray *results = [NSMutableArray arrayWithCapacity:0];
        for (id object in json) {
            [results addObject:[[self class] fromJSON:object]];
        }
        return results;
	}
	return [[[[self class] alloc] initWithDictionary:json] autorelease];
}

+ (id)fromDB:(FMResultSet *)result {
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:0];
    
    while ([result next]) [results addObject:[[[[self class] alloc] initWithFMResultSet:result] autorelease]];
    
    [result close];
    
    if ([results count] == 1) return [results lastObject];
    
    return results;
}

+ (NSArray *)all {
    return [self query:[NSString stringWithFormat:@"select * from %@;", [self tableName]]];
}

+ (id)find:(int)pk {
    id result = [self query:[NSString stringWithFormat:@"select * from %@ where id = %d limit 1;", [self tableName], pk]];
    
    if ([result isKindOfClass:[NSArray class]] && [result count] > 0) return [result lastObject];
    
    return result;
}

+ (NSString *)tableName {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end