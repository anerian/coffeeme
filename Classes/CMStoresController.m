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


@implementation CMStoresController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!stores_) {
        [self showAlert];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadView {
    [super loadView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storesReceived:) name:@"stores:received" object:nil];
}

- (void)updateLocation {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[location_.locationManager startUpdatingLocation];
	[pool release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //     UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar-coffeeme.png"]] autorelease];
    // imageView.contentMode = UIViewContentModeCenter;
    // self.navigationItem.titleView = imageView;
	location_ = [[MyCLController alloc] init];
	location_.delegate = self;
	[NSThread detachNewThreadSelector:@selector(updateLocation) toTarget:self withObject:nil];
	
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
    // [location_.locationManager stopUpdatingLocation];
    
    if (currentLocation_) return;
    
    [currentLocation_ release];
    [location retain];
    currentLocation_ = location;
    
    [NSThread detachNewThreadSelector:@selector(getStores) toTarget:self withObject:nil];
    
    [self.tableView reloadData];
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

@end