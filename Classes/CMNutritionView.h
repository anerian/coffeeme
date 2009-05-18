//
//  CMNutritionView.h
//  CoffeeMe
//
//  Created by min on 5/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMDrink.h"

@interface CMNutritionUnderlinedView : UIView {
  @private
    NSUInteger thickness_;
}

@property (nonatomic, assign) NSUInteger thickness;

@end

@interface CMNutritionHeaderView : CMNutritionUnderlinedView {
  @private
    UILabel *servingSize_;
}

@property (nonatomic, retain) UILabel *servingSize;

@end

@interface CMNutritionValueView : CMNutritionUnderlinedView {
  float total_;
  UILabel *title_;
  UILabel *value_;
  UILabel *daily_;
  BOOL subvalue_;
    
  NSString *unit_;
}

@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UILabel *value;
@property (nonatomic, retain) UILabel *daily;

- (id)initWithFrame:(CGRect)frame withOptions:(NSDictionary *)options;
- (void)updateValue:(NSUInteger)value;

@end

@interface CMNutritionView : UIView {
  CMDrink *drink_;
  UIScrollView *metrics_;
  
  CMNutritionHeaderView *header_;
  CMNutritionValueView *calories_;
    
  UILabel *drinkName_;
}

@property (nonatomic, retain) CMDrink *drink;

- (void)refreshView;

@end