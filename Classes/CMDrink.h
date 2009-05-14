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
    CMStoreType type_;
    CMNutrition nutrition_;
}

@property(nonatomic, retain) NSString *name;
@property(nonatomic, assign) CMStoreType type;
@property(nonatomic, assign) CMNutrition nutrition;

+ (NSArray *)forStore:(CMStoreType)type;

@end