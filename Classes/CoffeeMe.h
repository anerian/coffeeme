//
//  CoffeeMe.h
//  CoffeeMe
//
//  Created by min on 5/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMAppConfig.h"

#define CMTextColor HexToUIColor(0x351f0f)

typedef enum {
	CMStoreTypeStarbucks = 0,
	CMStoreTypeDunkin,
	CMStoreTypeCaribou,
	CMStoreTypeCount
} CMStoreType;

typedef enum {
  CMDrinkSizeTall = 0,
  CMDrinkSizeGrande,
  CMDrinkSizeVenti,
  CMDrinkSizeSolo,
  CMDrinkSizeDoppio,
  CMDrinkSizeShort,
  CMDrinkSizeMedium,
  CMDrinkSizeLarge,
  CMDrinkSizeExtraLarge,
  CMDrinkSizeSmall,
  CMDrinkSizeJunior
} CMDrinkSize;

typedef enum {
  CMDrinkMilkNonFat = 0,
  CMDrinkMilkWhole,
  CMDrinkMilkTwoPercent,
  CMDrinkMilkSoyUS,
  CMDrinkMilkSoyCD,
  CMDrinkMilkSkim,
  CMDrinkMilkSplenda,
  CMDrinkMilkCream,
  CMDrinkMilkSkimAndSplenda
} CMDrinkMilk;

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
    int caffeine;
} CMNutrition;

NSString* CMSizeType(NSUInteger type);
NSString* CMMilkType(NSUInteger type);
UILabel* CMLabelMake(CGRect rect, CGFloat fontSize, BOOL bold);
