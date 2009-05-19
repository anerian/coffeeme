//
//  CMBaseController.m
//  CoffeeMe
//
//  Created by min on 5/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMBaseController.h"
#import "CoffeeMeAppDelegate.h"

static const int   kAccelerometerFrequency = 25; //Hz
static const float kFilteringFactor = 0.1;
static const float kMinEraseInterval = 0.5;
static const float kEraseAccelerationThreshold = 3.0;

@implementation CMBaseController

@synthesize supportsAccelerometer = supportsAccelerometer_;

- (id)init {
  if (self = [super init]) {
    supportsAccelerometer_ = NO;
    lastShake_ = 0;
    calibrationOffset_ = 0.0;
    firstCalibrationReading_ = 999;
  }
  return self;
}

- (void)loadView {
  [super loadView];
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationBarTintColor = HexToUIColor(0x372010);
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.supportsAccelerometer = supportsAccelerometer_;
}

- (void)viewWillDisappear:(BOOL)animated {
  [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
}

- (void)setSupportsAccelerometer:(BOOL)supports {
  supportsAccelerometer_ = supports;

  UIAccelerometer* accelerometer = [UIAccelerometer sharedAccelerometer];
  if (supportsAccelerometer_) {
    accelerometer.updateInterval = 1.0 / kAccelerometerFrequency;
    accelerometer.delegate = self;
  } else {
    accelerometer.delegate = nil;
  }
}

- (void)userDidShake {
}

- (void)userDidRotate:(float)angle {
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}

- (void)dealloc {
  [super dealloc];
}

- (UIWindow *)appWindow {
  return [(CoffeeMeAppDelegate *)[[UIApplication sharedApplication] delegate] window];
}

#pragma mark UIAccelerometerDelegate methods

- (float)calibratedAngleFromAngle:(float)angle {
  return calibrationOffset_ + angle;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
  UIAccelerationValue length, x, y, z;
  accel_[0] = acceleration.x * kFilteringFactor + accel_[0] * (1.0 - kFilteringFactor);
	accel_[1] = acceleration.y * kFilteringFactor + accel_[1] * (1.0 - kFilteringFactor);
	accel_[2] = acceleration.z * kFilteringFactor + accel_[2] * (1.0 - kFilteringFactor);
	x = acceleration.x - accel_[0];
	y = acceleration.y - accel_[0];
	z = acceleration.z - accel_[0];
	length = sqrt(x * x + y * y + z * z);
  
  if ((length >= kEraseAccelerationThreshold) && (CFAbsoluteTimeGetCurrent() > lastShake_ + kMinEraseInterval)) {
    lastShake_ = CFAbsoluteTimeGetCurrent();

    [self userDidShake];
	} else {
    currentRawReading_ = atan2(accel_[1], accel_[0]);
    float calibratedAngle = [self calibratedAngleFromAngle:currentRawReading_];
    [self userDidRotate:-RAD2DEG(calibratedAngle)];
	}
}

@end