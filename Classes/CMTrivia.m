//
//  CMTrivia.m
//  CoffeeMe
//
//  Created by min on 5/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMTrivia.h"


@implementation CMTrivia

@synthesize pk = pk_, fact = fact_;

- (id)initWithFMResultSet:(FMResultSet *)resultSet {
    if (self = [super init]) {
        self.pk   = [resultSet intForColumn:@"id"];
        self.fact = [resultSet stringForColumn:@"fact"];
    }
    return self;
}

+ (NSString *)tableName {
    return @"trivias";
}

+ (CMTrivia *)randomTrivia {
  NSString *table = [self tableName];
  NSString *query = [NSString stringWithFormat:@"select id,fact from %@ where id >= (abs(random()) %% (select max(id) from %@)) limit 1", table, table];
  NSLog(@"Querying: '%@'", query);
  return [self query:query];
}

@end
