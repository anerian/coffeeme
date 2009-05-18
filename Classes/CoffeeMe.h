//
//  CoffeeMe.h
//  CoffeeMe
//
//  Created by min on 5/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMAppConfig.h"


typedef enum {
	CMStoreTypeStarbucks = 0,
	CMStoreTypeDunkin,
	CMStoreTypeCaribou,
	CMStoreTypeCount
} CMStoreType;

typedef struct _CMNutrition {
    int servingSize;
    int calories;
    int totalFat;
    int saturatedFat;
    int transFat;
    int cholesterol;
    int sodium;
    int totalCarbohydrates;
    int fiber;
    int sugars;
    int protein;
} CMNutrition;

NSString* CMSizeType(NSUInteger type);
NSString* CMMilkType(NSUInteger type);
UILabel* CMLabelMake(CGRect rect, CGFloat fontSize, BOOL bold);
