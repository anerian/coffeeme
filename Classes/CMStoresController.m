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
#import "CMStoreCell.h"
// #import "RMMapView.h"

@implementation CMStoresController

@synthesize tableView = tableView_;

- (id)initWithStyle:(UITableViewStyle)style {
  if (self = [super init]) {
    isLoading_   = NO;
    isDirty_     = YES;
    storeFilter_ = -1;
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
  self.view.backgroundColor = HexToUIColor(0xb4b4b4);

  [self.view addSubview:self.tableView];


  NSArray *shops = [CMAppConfig objectForKey:@"shops"];
  NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
  
  [items addObject:[[[TTTabItem alloc] initWithTitle:@"All"] autorelease]];
  
  TTTabItem *tabItem_;
  for (NSString *shop in shops) {
    tabItem_ = [[[TTTabItem alloc] initWithTitle:shop] autorelease];

    [items addObject:tabItem_];
  }
  
  TTTabStrip *tabBar_ = [[TTTabStrip alloc] initWithFrame:CGRectMake(0, 0, 320, 41)];
  tabBar_.delegate = self;
  tabBar_.tabItems = items;
  tabBar_.style = 
    [TTReflectiveFillStyle styleWithColor:RGBCOLOR(222, 222, 222) next:
    [TTFourBorderStyle styleWithTop:nil right:nil bottom:self.view.backgroundColor left:nil width:1 next:nil]];
  
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
  
  refresh_ = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)] retain];
  
  UIActivityIndicatorView *indicator_ = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
  [indicator_ startAnimating];
  
  spinner_ = [[[UIBarButtonItem alloc] initWithCustomView:indicator_] retain];
  
  self.navigationItem.rightBarButtonItem = refresh_;

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

- (void)getStores:(NSNumber *)filter {
  CMStoreType storeType = [filter integerValue];
  
  if (!isDirty_) return;
  isDirty_ = NO;
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc ]init];
  CLLocation *location = [CMLocation instance].currentLocation;
  
  NSArray *stores = [CMStore nearby:location.coordinate withType:storeType];
  
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
}

- (void)locationUpdated:(NSNotification*)notify {    
  [NSThread detachNewThreadSelector:@selector(getStores:) toTarget:self withObject:[NSNumber numberWithInt:storeFilter_]];
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
		cell = [[[CMStoreCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-cell.png"]] autorelease];
    cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-cell-selected.png"]] autorelease];
    cell.selectedTextColor = [UIColor whiteColor];
	}
  [(CMStoreCell *)cell update:store];
	
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
  self.navigationItem.rightBarButtonItem = refresh_;
  // [modal_ show:NO];
}

- (void)showAlert {
  [self invalidateViewState:TTViewRefreshing];
  self.navigationItem.rightBarButtonItem = spinner_;
  // [modal_ show:YES];
}

- (void)userDidShake {
  [self refresh];
}

- (void)tabBar:(TTTabBar*)tabBar tabSelected:(NSInteger)selectedIndex {
  storeFilter_ = (selectedIndex - 1);
  isDirty_ = YES;
  [NSThread detachNewThreadSelector:@selector(getStores:) toTarget:self withObject:[NSNumber numberWithInt:storeFilter_]];
  
  // NSArray *stores = [CMStore nearby:[CMLocation instance].currentLocation.coordinate withType:storeFilter_];
  // [stores retain];
  // [stores_ release];
  // stores_ = stores;
  //   
  // [self.tableView reloadData];  
}

@end