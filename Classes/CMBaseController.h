//
//  CMBaseController.h
//  CoffeeMe
//
//  Created by min on 5/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CMBaseController : UIViewController <UIAccelerometerDelegate> {
    BOOL supportsAccelerometer_;
    CFTimeInterval lastShake_;
	UIAccelerationValue	accel_[3];
    
    float firstCalibrationReading_;
    float currentRawReading_;
    float calibrationOffset_;
}

@property(nonatomic) BOOL supportsAccelerometer;

- (void)userDidShake;
- (void)userDidRotate:(float)angle;
- (UIWindow *)appWindow;

@end
