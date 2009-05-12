//
//  CMTriviaController.m
//  CoffeeMe
//
//  Created by min on 5/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMTriviaController.h"
#import "CMTriviaView.h"

#define kAccelerometerFrequency      25
#define kFilteringFactor             0.1
#define kMinEraseInterval            0.5
#define kEraseAccelerationThreshold  2.0

@implementation CMTriviaController

-(id) init {
    if (self = [super init]) {
    }
    return self;
}

- (void)loadView {
    self.view = [[CMTriviaView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kAccelerometerFrequency)];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(storesReceived:) 
                                                 name:@"stores:received" 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(locationUpdated:) 
                                                 name:@"location:updated" 
                                                   object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [self refresh];
    [super viewWillAppear:animated];
}

- (void)refresh {
    [((CMTriviaView*)self.view) updateTrivia];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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

#pragma mark UIAccelerometerDelegate methods

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    UIAccelerationValue length, x, y, z;
    
    UIAccelerationValue myAccelerometer[3];
    myAccelerometer[0] = acceleration.x * kFilteringFactor + myAccelerometer[0] * (1.0 - kFilteringFactor);
    myAccelerometer[1] = acceleration.y * kFilteringFactor + myAccelerometer[1] * (1.0 - kFilteringFactor);
    myAccelerometer[2] = acceleration.z * kFilteringFactor + myAccelerometer[2] * (1.0 - kFilteringFactor);

    x = acceleration.x - myAccelerometer[0];
    y = acceleration.y - myAccelerometer[0];
    z = acceleration.z - myAccelerometer[0];
    
    length = sqrt(x * x + y * y + z * z);
    
    if ((length >= kEraseAccelerationThreshold) && (CFAbsoluteTimeGetCurrent() > lastShake_ + kMinEraseInterval)) {    
        lastShake_ = CFAbsoluteTimeGetCurrent();
        [self refresh];
    }
}

@end
