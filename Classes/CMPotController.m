//
//  CMPotController.m
//  CoffeeMe
//
//  Created by min on 5/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMPotController.h"
#import "CMCoffeePotView.h"


@implementation CMPotController

- (id)init {
    if (self = [super init]) {
        self.supportsAccelerometer = YES;
        
    }
    return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    coffeePot_ = [[[CMCoffeePotView alloc] initWithFrame:self.view.bounds] autorelease];
    
    self.view = coffeePot_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)userDidRotate:(float)angle {
    [coffeePot_ tilt:(angle-90)];
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
    [coffeePot_ release];
    [super dealloc];
}


@end
