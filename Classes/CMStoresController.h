//
//  CMStoresController.h
//  CoffeeMe
//
//  Created by min on 5/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCLController.h"
#import "CMModalView.h"


@interface CMStoresController : UITableViewController <MyCLControllerDelegate> {
    MyCLController *location_;
    NSArray *stores_;
    id alert_;
    CLLocation *currentLocation_;
    CMModalView *modal_;
}

- (void)showAlert;
- (void)hideAlert;

- (void)locationUpdate:(CLLocation *)location; 
- (void)locationError:(NSError *)error;

@end