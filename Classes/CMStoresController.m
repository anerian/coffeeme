    //
//  CMStoresController.m
//  CoffeeMe
//
//  Created by min on 5/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSNotificationAdditions.h"
#import "CMStoresController.h"
#import "CMSettingsController.h"
#import "CMStore.h"
// #import "RMMapView.h"

@implementation CMStoresController

@synthesize tableView = tableView_;

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super init]) {
        isLoading_ = NO;
        isDirty_ = YES;
        self.supportsAccelerometer = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!stores_) {
        [self refresh];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(storesReceived:) 
                                                 name:@"stores:received" 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(locationUpdated:) 
                                                 name:@"location:updated" 
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:@"stores:received" 
                                                  object:nil];
                                                  
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:@"location:updated" 
                                                  object:nil];
}

- (void)loadView {
    [super loadView];
    self.tableView = [[[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain] autorelease];
    self.tableView.frame = CGRectMake(0,40,320,self.view.frame.size.height-40);

    [self.view addSubview:self.tableView];

    
    NSArray *shops = [CMAppConfig objectForKey:@"shops"];
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
    [items addObject:[[[TTTabItem alloc] initWithTitle:@"All"] autorelease]];
    for (NSString *shop in shops) {
      [items addObject:[[[TTTabItem alloc] initWithTitle:shop] autorelease]];
    }
    DLog(@"shops: %@", shops);
    
    UIColor* border = [RGBCOLOR(211, 198, 189) multiplyHue:0 saturation:0 value:0.4];



    TTTabStrip *tabBar_ = [[TTTabStrip alloc] initWithFrame:CGRectMake(0, 0, 320, 41)];
    tabBar_.tabItems = items;
    tabBar_.style = 
      [TTReflectiveFillStyle styleWithColor:RGBCOLOR(230, 224, 213) next:
      [TTFourBorderStyle styleWithTop:nil right:nil bottom:border left:nil width:1 next:nil]];
      
    [self.view addSubview:tabBar_];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *top = [[[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,20)] autorelease];
    top.image = [UIImage imageNamed:@"bg-shadow-top.png"];
    UIImageView *btm = [[[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,20)] autorelease];
    btm.image = [UIImage imageNamed:@"bg-shadow-bottom.png"];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    self.tableView.tableHeaderView = top;
    self.tableView.tableFooterView = btm;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 100;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.rightBarButtonItem = 
        [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
                                                       target:self 
                                                       action:@selector(refresh)] autorelease];
    self.navigationItem.leftBarButtonItem = 
        [[[UIBarButtonItem alloc] initWithTitle:@"Settings" 
                                          style:UIBarButtonItemStyleBordered
                                         target:self 
                                        action:@selector(settings)] autorelease];
    modal_ = [[[CMModalView alloc] initWithWindow:[self appWindow]] retain];
}

- (void)dealloc {
    [super dealloc];
}

- (void)refresh {
    if (isLoading_) return;
    
    isDirty_ = YES;
    isLoading_ = YES;
    [self showAlert];
    [[CMLocation instance] start];
}

- (void)settings {
    CMSettingsController *settingsController = [[[CMSettingsController alloc] init] autorelease];
    UINavigationController *modal = [[[UINavigationController alloc] initWithRootViewController:settingsController] autorelease];
    modal.navigationBar.tintColor = HexToUIColor(0x3d2210);
    [self.navigationController presentModalViewController:modal animated:YES];
}

- (void)getStores {
    if (!isDirty_) return;
    isDirty_ = NO;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc ]init];
    CLLocation *location = [CMLocation instance].currentLocation;
    
    NSArray *stores = [CMStore nearby:location.coordinate];

    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:@"stores:received" object:stores];
    
    [NSThread exit];
    [pool release];
}

#pragma mark Notifications methods

- (void)storesReceived:(NSNotification*)notify {
	NSArray *stores = [notify object];

	[stores retain];
    [stores_ release];
    stores_ = stores;
    
    [self hideAlert];
    isLoading_ = NO;
    
    [self.tableView reloadData];
    
    // self.view = [[RMMapView alloc] initWithFrame:self.view.frame WithLocation:[CMLocation instance].currentLocation.coordinate];
}

- (void)locationUpdated:(NSNotification*)notify {    
    [NSThread detachNewThreadSelector:@selector(getStores) toTarget:self withObject:nil];
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
        cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-cell.png"]] autorelease];
        cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-cell-selected.png"]] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectedTextColor = [UIColor whiteColor];
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

#pragma mark Alert methods

- (void)hideAlert {
    [modal_ show:NO];
}

- (void)showAlert {
    [modal_ show:YES];
}

- (void)userDidShake {
    [self refresh];
}

@end
