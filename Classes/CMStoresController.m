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

// - (id)init {
//     if (self = [super init]) {
// 
//     }
//     return self;
// }

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
    //     self.variableHeightRows = YES;
    //     self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
    // self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // 
    // [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //     UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar-coffeeme.png"]] autorelease];
    // imageView.contentMode = UIViewContentModeCenter;
    // self.navigationItem.titleView = imageView;
	
    location_ = [[MyCLController alloc] init];
	location_.delegate = self;
	[location_.locationManager startUpdatingLocation];
    alert_ = [[UIProgressHUD alloc] initWithWindow:[self.navigationController.view superview]];
    
    modal_ = [[[CMModalView alloc] initWithWindow:[self.navigationController.view superview]] retain];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 100;
    self.tableView.backgroundColor = [UIColor clearColor];
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
    
    [self.tableView reloadData];
}

- (void)locationError:(NSError *)error {
    
}

#pragma mark Alert methods

- (void)hideAlert {
    [modal_ show:NO];
}

- (void)showAlert {
    // [alert_ setText:@"One moment while we determine your location."];
    [modal_ show:YES];
}

@end