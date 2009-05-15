//
//  CMDrink.h
//  CoffeeMe
//
//  Created by min on 5/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMModel.h"

@interface CMDrink : CMModel<CMModel> {
    NSString *name_;
    NSUInteger milk_;
    NSUInteger size_;
    CMStoreType type_;
    CMNutrition nutrition_;
}

@property(nonatomic, retain) NSString *name;
@property(nonatomic, assign) CMStoreType type;
@property(nonatomic, assign) CMNutrition nutrition;
@property(nonatomic, assign) NSUInteger milk;
@property(nonatomic, assign) NSUInteger size;

+ (NSArray *)forStore:(CMStoreType)type;
+ (NSArray *)forName:(NSString *)name;
+ (NSArray *)sizesForName:(NSString *)name;
+ (NSArray *)milkTypesForName:(NSString *)name;

- (NSString *)formattedName;

@end