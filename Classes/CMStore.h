//
//  CMStore.h
//  CoffeeMe
//
//  Created by min on 5/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMModel.h"


@interface CMStore : CMModel<CMModel> {
    NSString *street_;
    NSString *city_;
    NSString *state_;
    NSString *zip_;
    NSString *phone_;
    NSUInteger type_;
    
    UIView *cell_;
    
    double latitude_;
    double longitude_;
}

@property (nonatomic, retain) NSString *street;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *zip;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) UIView *cell;

@property (nonatomic, assign) NSUInteger type;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

- (id)initWithFMResultSet:(FMResultSet *)resultSet;

+ (NSArray *)nearby:(CLLocationCoordinate2D)coordinate;

// helpers
+ (NSString *)storeNameForCode:(NSUInteger)code;

- (NSString *)address;
- (NSString *)address2;
- (CLLocation *)location;

@end