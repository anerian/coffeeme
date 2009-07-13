//
//  CoffeeMe.h
//  CoffeeMe
//
//  Created by min on 5/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/CoreAnimation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CMAppConfig.h"

#define HexToUIColor(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0]

#define GMAP_KEY @"ABQIAAAAPbIrQY6Tw4qExHaj02Mk2hRVqMhVQ_5kbSl3aRaLvxPKrOmdqRQ20bPBuwPn-AtQx0rYiRgLXkADFQ"

#define DEG2RAD(degrees) (M_PI * degrees / 180)
#define RAD2DEG(radians) (radians * 180 / M_PI)
#define CMTextColor HexToUIColor(0x351f0f)

typedef enum {
  CMStoreTypeAll = -1,
	CMStoreTypeStarbucks,
	CMStoreTypeDunkin,
	CMStoreTypeCaribou,
	CMStoreTypeTimHorton,
	CMStoreTypeSaxbys,
	CMStoreTypePeets,
	CMStoreTypeDunnBros,
	CMStoreTypeBeanery,
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
NSString* CMShopType(CMStoreType type);
UILabel* CMLabelMake(CGRect rect, CGFloat fontSize, BOOL bold);