//
//  CMDrink.m
//  CoffeeMe
//
//  Created by min on 5/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMDrink.h"


@implementation CMDrink

@synthesize name = name_, type = type_, nutrition = nutrition_;

- (id)initWithFMResultSet:(FMResultSet *)resultSet {
    if (self = [super init]) {
        self.pk        = [resultSet intForColumn:@"id"];
        self.name      = [[[resultSet stringForColumn:@"name"] copy] autorelease];
        self.type      = [resultSet intForColumn:@"store_type"];
        self.nutrition = (CMNutrition){
            [resultSet intForColumn:@"serving_size"],
            [resultSet intForColumn:@"calories"],
            [resultSet intForColumn:@"total_fat"],
            [resultSet intForColumn:@"saturated_fat"],
            [resultSet intForColumn:@"trans_fat"],
            [resultSet intForColumn:@"cholesterol"],
            [resultSet intForColumn:@"sodium"],
            [resultSet intForColumn:@"total_carbohydrates"],
            [resultSet intForColumn:@"fiber"],
            [resultSet intForColumn:@"sugars"],
            [resultSet intForColumn:@"protein"]
        };
    }
    return self;
}

+ (NSArray *)forStore:(CMStoreType)type {
    return [CMDrink query:[NSString stringWithFormat:@"select * from drinks where store_type = %d", type]];
}

- (void)dealloc {
    [name_ release];
    [super dealloc];
}

@end