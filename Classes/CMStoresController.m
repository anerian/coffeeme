//
//  CMStoresController.m
//  CoffeeMe
//
//  Created by min on 5/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMStoresController.h"
#import "CMStore.h"


@implementation CMStoresController

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (id)init {
    if (self = [super init]) {
        location_ = [[MyCLController alloc] init];
    	location_.delegate = self;
    	[location_.locationManager startUpdatingLocation];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!stores_) {
        NSLog(@"show Alert");
        [self showAlert];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadView {
    [super loadView];
    self.variableHeightRows = YES;
    self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
  	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  	
  	[self.view addSubview:self.tableView];
  	
    alert_ = [[UIProgressHUD alloc] initWithWindow:[self.navigationController.view superview]];
}

- (void)viewDidUnload {

}

- (void)dealloc {
    [alert_ release];
    [super dealloc];
}

- (id<TTTableViewDataSource>)createDataSource {
    if (stores_) {
        NSMutableArray *items = [NSMutableArray arrayWithCapacity:[stores_ count]];
        
        for (CMStore *store in stores_) {
            // TTImageTableField *imageField_ = [[[TTImageTableField alloc] initWithText:[store address] subtext:[NSString stringWithFormat:@"%f miles", ([[store location] getDistanceFrom:currentLocation_] * .000621371192)]] autorelease];
            TTIconTableField *iconField_ = [[[TTIconTableField alloc] initWithText:[store address]] autorelease];
            iconField_.image = @"bundle://starbucks.png";
            
            // bundle://person.jpg
            [items addObject:iconField_];
        }
        return [TTListDataSource dataSourceWithItems:items];
    }
    return nil;
}

#pragma mark MyCLControllerDelegate

- (void)locationUpdate:(CLLocation *)location {
    [location_.locationManager stopUpdatingLocation];
    
    [currentLocation_ release];
    [location retain];
    currentLocation_ = location;
    [self hideAlert];
    NSArray *stores = [CMStore nearby:location.coordinate];
    [stores_ release];
    [stores retain];
    stores_ = stores;
    
    [self updateView];
}

- (void)locationError:(NSError *)error {
    
}

#pragma mark Alert methods

- (void)hideAlert {
	[alert_ show:NO];
}

- (void)showAlert {
    [alert_ setText:@"One moment while we determine your location."];
    [alert_ show:YES];
}

@end