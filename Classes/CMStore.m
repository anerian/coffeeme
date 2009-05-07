//
//  CMStore.m
//  CoffeeMe
//
//  Created by min on 5/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMStore.h"

static FMDatabase *database_ = nil;

@implementation CMStore

@synthesize pk = pk_, street = street_, city = city_, state = state_, zip = zip_, phone = phone_, 
type = type_, latitude = latitude_, longitude = longitude_;


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

- (id)initWithFMResultSet:(FMResultSet *)resultSet {
    if (self = [super init]) {
        self.pk        = [resultSet intForColumn:@"id"];
        self.street    = [resultSet stringForColumn:@"street"];
        self.city      = [resultSet stringForColumn:@"city"];
        self.state     = [resultSet stringForColumn:@"state"];
        self.zip       = [resultSet stringForColumn:@"zip"];
        self.phone     = [resultSet stringForColumn:@"phone"];
        self.type      = [resultSet intForColumn:@"store_type"];
        self.latitude  = [resultSet doubleForColumn:@"latitude"];
        self.longitude = [resultSet doubleForColumn:@"longitude"];
	}
	
	return self;
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

+ (FMDatabase *)connection {
    return database_;
}

+ (id)fromDB:(FMResultSet *)result {
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:0];
    
    while ([result next]) [results addObject:[[[[self class] alloc] initWithFMResultSet:result] autorelease]];
    
    [result close];
    
    if ([results count] == 1) return [results lastObject];
    
    return results;
}

+ (id)query:(NSString *)sql {
    return [self fromDB:[[[self class] connection] executeQuery:sql]];
}

- (id)query:(NSString *)sql {
    return [[self class] query:sql];
}

+ (NSArray *)nearby:(CLLocationCoordinate2D)coordinate {
    return [self query:[NSString stringWithFormat:@"select * from %@ order by distance(latitude, longitude, %f, %f) limit 10", [self tableName], coordinate.latitude, coordinate.longitude]];
}

+ (NSString *)tableName {
    return @"stores";
}

- (NSString *)description {
    return [self address];
}

- (CLLocation *)location {
    return [[[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude] autorelease];
}

- (NSString *)address {
    return [NSString stringWithFormat:@"%@\n%@, %@. %@", street_, city_, state_, zip_];
}

- (NSString *)address2 {
    return [NSString stringWithFormat:@"%@, %@. %@", city_, state_, zip_];
}

@end