//
//  CMStoresController.m
//  CoffeeMe
//
//  Created by min on 5/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSNotificationAdditions.h"
#import "CMStoresController.h"
#import "CMStore.h"

#define kAccelerometerFrequency      25 //Hz
#define kFilteringFactor             0.1
#define kMinEraseInterval            0.5
#define kEraseAccelerationThreshold  2.0

@implementation CMStoresController

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kAccelerometerFrequency)];
        [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!stores_) {
        [self refresh];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadView {
    [super loadView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storesReceived:) name:@"stores:received" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	location_ = [[MyCLController alloc] init];
	location_.delegate = self;
	
    alert_ = [[UIProgressHUD alloc] initWithWindow:[self.navigationController.view superview]];
    
    modal_ = [[[CMModalView alloc] initWithWindow:[self.navigationController.view superview]] retain];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 100;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    UIImageView *top = [[[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,20)] autorelease];
    top.image = [UIImage imageNamed:@"bg-shadow-top.png"];
    UIImageView *btm = [[[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,20)] autorelease];
    btm.image = [UIImage imageNamed:@"bg-shadow-bottom.png"];
    
    self.tableView.tableHeaderView = top;
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    self.tableView.tableFooterView = btm;
    
    self.navigationItem.rightBarButtonItem = 
        [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
                                                       target:self 
                                                       action:@selector(refresh)] autorelease];
}

- (void)viewDidUnload {
    
}

- (void)dealloc {
    [alert_ release];
    [super dealloc];
}

- (void)refresh {
    if (isLoading_) return;
    
    isLoading_ = YES;
    [self showAlert];
    [location_.locationManager startUpdatingLocation];
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMStore *store = [stores_ objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"CMStoreCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
        // cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-cell.png"]] autorelease];
        cell.backgroundColor = [UIColor clearColor];
	}
	[[cell viewWithTag:99] removeFromSuperview];
    [cell addSubview:[store cell]];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CMDetailController *detailController = [[[CMDetailController alloc] initWithStore:[stores_ objectAtIndex:indexPath.row]] autorelease];
    
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!stores_) return 0;
	return [stores_ count];
}

#pragma mark MyCLControllerDelegate

- (void)getStores {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc ]init];
    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:@"stores:received" object:[CMStore nearby:currentLocation_.coordinate]];
    [pool release];
}

- (void)locationUpdate:(CLLocation *)location {    
    [currentLocation_ release];
    [location retain];
    currentLocation_ = location;
    
    [NSThread detachNewThreadSelector:@selector(getStores) toTarget:self withObject:nil];
    
    [self.tableView reloadData];
    
    isLoading_ = NO;
}

- (void)locationError:(NSError *)error {
    
}

#pragma mark Alert methods

- (void)hideAlert {
    [modal_ show:NO];
}

- (void)showAlert {
    [modal_ show:YES];
}

#pragma mark Notifications methods

- (void)storesReceived:(NSNotification*)notify {
	NSArray *stores = [notify object];
	
    [stores_ release];
    [stores retain];
    stores_ = stores;
    [self.tableView reloadData];
    [self hideAlert];
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