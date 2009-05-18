//
//  CMModel.h
//  CoffeeMe
//
//  Created by min on 5/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@protocol CMModel

// Initializers
- (id)initWithFMResultSet:(FMResultSet *)resultSet;

@end

@interface CMModel : NSObject {
    int pk_;
}

@property(nonatomic, assign) int pk;

+ (FMDatabase *)connection;
+ (void)establishConnection;

// Conversions
+ (id)fromJSON:(id)json;
+ (id)fromDB:(FMResultSet *)result;

// Query helpers
+ (id)query:(NSString *)sql;
- (id)query:(NSString *)sql;

+ (id)find:(int)pk;
+ (NSArray *)all;
+ (NSArray *)selectOneColumn:(NSString *)column withCondition:(NSString *)condition;

// Accessors
+ (NSString *)tableName;

@end