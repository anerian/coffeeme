//
//  CoffeeMe.h
//  CoffeeMe
//
//  Created by min on 5/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	CMStoreTypeStarbucks = 0,
	CMStoreTypeDunkin,
	CMStoreTypeCaribou,
	CMStoreTypeCount
} CMStoreType;

struct CMNutrition {
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
};
typedef struct CMNutrition CMNutrition;