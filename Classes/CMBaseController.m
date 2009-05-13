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

@synthesize supportsShake = supportsShake_;

- (id)init {
    if (self = [super init]) {
        supportsShake_ = NO;
        lastShake_ = 0;
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.supportsShake = supportsShake_;
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
}

- (void)setSupportsShake:(BOOL)supports {
    supportsShake_ = supports;

    UIAccelerometer* accelerometer = [UIAccelerometer sharedAccelerometer];
    if (supportsShake_) {
        accelerometer.updateInterval = 1.0 / kAccelerometerFrequency;
        accelerometer.delegate = self;
    } else {
        accelerometer.delegate = nil;
    }
}

- (void)userDidShake {
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (UIWindow *)appWindow {
    return [(CoffeeMeAppDelegate *)[[UIApplication sharedApplication] delegate] window];
}

#pragma mark UIAccelerometerDelegate methods

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
	}
}

@end