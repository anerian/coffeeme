//
//  CMBaseController.h
//  CoffeeMe
//
//  Created by min on 5/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CMBaseController : UIViewController <UIAccelerometerDelegate> {
    BOOL supportsShake_;
    CFTimeInterval lastShake_;
	UIAccelerationValue	accel_[3];
}

@property(nonatomic) BOOL supportsShake;

- (void)userDidShake;

@end
