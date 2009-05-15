//
//  CMNutritionView.h
//  CoffeeMe
//
//  Created by min on 5/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMDrink.h"


@interface CMNutritionView : UIView {
    CMDrink *drink_;
    UIView *metrics_;
}

@property (nonatomic, retain) CMDrink *drink;

- (void)refreshView;

@end