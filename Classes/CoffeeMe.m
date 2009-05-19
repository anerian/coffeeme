//
//  CoffeeMe.m
//  CoffeeMe
//
//  Created by min on 5/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//



#import "CoffeeMe.h"

NSString* CMSizeType(NSUInteger type) {
  NSString *size;

  switch(type) {
    case CMDrinkSizeTall: size = @"Tall"; break;
    case CMDrinkSizeGrande: size = @"Grande"; break;
    case CMDrinkSizeVenti: size = @"Venti"; break;
    case CMDrinkSizeSolo: size = @"Solo"; break;
    case CMDrinkSizeDoppio: size = @"Doppio"; break;
    case CMDrinkSizeShort: size = @"Short"; break;
    case CMDrinkSizeMedium: size = @"Medium"; break;
    case CMDrinkSizeLarge: size = @"Large"; break;
    case CMDrinkSizeExtraLarge: size = @"Extra Large"; break;
    case CMDrinkSizeSmall: size = @"Small"; break;
    case CMDrinkSizeJunior: size = @"Junior"; break;
    default: size = @""; break;
  }

  return size;
}

NSString* CMMilkType(NSUInteger type) {
  NSString *milk;
  switch(type) {
    case CMDrinkMilkNonFat: milk = @"Nonfat"; break;
    case CMDrinkMilkWhole: milk = @"Whole"; break;
    case CMDrinkMilkTwoPercent: milk = @"2%"; break;
    case CMDrinkMilkSoyUS: milk = @"Soy (US)"; break;
    case CMDrinkMilkSoyCD: milk = @"Soy (CD)"; break;
    case CMDrinkMilkSkim: milk = @"Skim"; break;
    case CMDrinkMilkSplenda: milk = @"Splenda"; break;
    case CMDrinkMilkCream: milk = @"Cream"; break;
    case CMDrinkMilkSkimAndSplenda: milk = @"Skim Milk and Splenda"; break;
    default: milk = @""; break;
  }
  
  return milk;
}

NSString* CMShopType(CMStoreType type) {
  return [[CMAppConfig objectForKey:@"shops"] objectAtIndex:type];
}

UILabel* CMLabelMake(CGRect rect, CGFloat fontSize, BOOL bold) {
  UILabel *label = [[[UILabel alloc] initWithFrame:rect] autorelease];
  label.font = bold ? [UIFont boldSystemFontOfSize:fontSize] : [UIFont systemFontOfSize:fontSize];
  label.backgroundColor = [UIColor clearColor];
  return label;
}