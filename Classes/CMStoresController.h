//
//  CMStoresController.h
//  CoffeeMe
//
//  Created by min on 5/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMModalView.h"
#import "CMDetailController.h"
#import "CMLocation.h"


@interface CMStoresController : UITableViewController <UIAccelerometerDelegate> {
    NSArray *stores_;
    CMModalView *modal_;
    CFTimeInterval lastShake_;
    
    BOOL isLoading_;
    BOOL isDirty_;
}

- (void)refresh;
- (void)showAlert;
- (void)hideAlert;

@end