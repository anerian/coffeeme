//
//  CMStore.h
//  CoffeeMe
//
//  Created by min on 5/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"


@interface CMStore : NSObject {
    int pk_;
    NSString *street_;
    NSString *city_;
    NSString *state_;
    NSString *zip_;
    NSString *phone_;
    NSUInteger type_;
    
    double latitude_;
    double longitude_;
}

@property (nonatomic, assign) int pk;
@property (nonatomic, retain) NSString *street;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *zip;
@property (nonatomic, retain) NSString *phone;

@property (nonatomic, assign) NSUInteger type;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

- (id)initWithFMResultSet:(FMResultSet *)resultSet;

// Connections
+ (FMDatabase *)connection;
+ (void)establishConnection;

+ (id)fromDB:(FMResultSet *)result;

+ (id)query:(NSString *)sql;
- (id)query:(NSString *)sql;

+ (NSArray *)nearby:(CLLocationCoordinate2D)coordinate;

// Accessors
+ (NSString *)tableName;

// helpers
- (NSString *)address;

@end