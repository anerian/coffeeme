//
//  CMNutritionView.h
//  CoffeeMe
//
//  Created by min on 5/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMDrink.h"

@interface CMMetricView : UIScrollView {
}
@end

@interface CMNutritionUnderlinedView : UIView {
    NSUInteger thickness_;
}
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
    CMNutritionValueView *calories_;
    
    UILabel *drinkName_;
}

@property (nonatomic, retain) CMDrink *drink;

- (void)refreshView;

@end