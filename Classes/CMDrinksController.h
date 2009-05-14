//
//  CMDrinksController.h
//  CoffeeMe
//
//  Created by min on 5/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CMDrinksController : TTTableViewController <TTSearchTextFieldDelegate> {
    NSArray *drinks_;
}

@property (nonatomic, retain) NSArray *drinks;

@end
