//
//  CMNutritionController.h
//  CoffeeMe
//
//  Created by min on 5/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMNutritionView.h"
#import "CMDrink.h"

typedef enum {
	CMNutritionPickerTagSize = 1,
	CMNutritionPickerTagMilk
} CMNutritionPickerTag;

@interface CMNutritionController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    NSString *drinkName_;
    NSArray *drinks_;
    NSArray *sizes_;
    NSArray *milkTypes_;
    
    BOOL hasMultiple_;
    
    UIPickerView *milkPicker_;
    UIPickerView *sizePicker_;
    
    CMDrink *currentDrink_;
    
    CMNutritionView *nutritionView_;
    UIView *settingsView_;
    UIPickerView *picker_;
    
    BOOL pickerEnabled_;
}

- (id)initWithDrinkName:(NSString *)drinkName;

@end
