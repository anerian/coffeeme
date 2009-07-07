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
#import "CMStoreCell.h"

@implementation CMStoresController

@synthesize tableView = tableView_;

- (id)initWithStyle:(UITableViewStyle)style {
  if (self = [super init]) {
    isLoading_   = NO;
    isDirty_     = YES;
    storeFilter_ = -1;
    statusView_  = nil;
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

- (void)recenterMap {
  NSArray *coordinates = [map_ valueForKeyPath:@"annotations.coordinate"];
  CLLocationCoordinate2D maxCoord = {-90.0f, -180.0f};
  CLLocationCoordinate2D minCoord = {90.0f, 180.0f};
  
  for (NSValue *value in coordinates) {
    CLLocationCoordinate2D coord = {0.0f, 0.0f};
    
    [value getValue:&coord];
    if (coord.longitude > maxCoord.longitude) {
      maxCoord.longitude = coord.longitude;
    }
    if (coord.latitude > maxCoord.latitude) {
      maxCoord.latitude = coord.latitude;
    }
    if (coord.longitude < minCoord.longitude) {
      minCoord.longitude = coord.longitude;
    }
    if (coord.latitude < minCoord.latitude) {
      minCoord.latitude = coord.latitude;
    }
  }
  
  MKCoordinateRegion region = {{0.0f, 0.0f}, {0.0f, 0.0f}};
  region.center.longitude = (minCoord.longitude + maxCoord.longitude) / 2.0;
  region.center.latitude = (minCoord.latitude + maxCoord.latitude) / 2.0;
  region.span.longitudeDelta = maxCoord.longitude - minCoord.longitude;
  region.span.latitudeDelta = maxCoord.latitude - minCoord.latitude;
  [map_ setRegion:region animated:YES];
}

- (void)loadView {
  [super loadView];
  
  map_ = [[[MKMapView alloc] initWithFrame:self.view.frame] retain];
  map_.delegate = self;
  map_.showsUserLocation = YES;
  // map_.userLocationVisible = YES;

  self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
  self.tableView.frame = CGRectMake(0,40,320,self.view.bounds.size.height-60);
  self.view.backgroundColor = HexToUIColor(0x865836);
  
  UIImageView *shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow-bottom.png"]];
  shadow.frame = CGRectMake(0,self.tableView.frame.origin.y,320,29);

  NSArray *shops = [CMAppConfig objectForKey:@"shops"];
  NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
  
  [items addObject:[[[TTTabItem alloc] initWithTitle:@"All Shops"] autorelease]];
  
  TTTabItem *tabItem_;
  for (NSString *shop in shops) {
    tabItem_ = [[[TTTabItem alloc] initWithTitle:shop] autorelease];

    [items addObject:tabItem_];
  }
  
  TTTabStrip *tabBar_ = [[TTTabStrip alloc] initWithFrame:CGRectMake(0, 0, 320, 41)];
  tabBar_.delegate = self;
  tabBar_.tabItems = items;
  
  [self.view addSubview:shadow];
  [self.view addSubview:self.tableView];
  [self.view addSubview:tabBar_];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIImageView *top = [[[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,29)] autorelease];
  top.image = [UIImage imageNamed:@"shadow-top.png"];
  UIImageView *btm = [[[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,29)] autorelease];
  btm.image = [UIImage imageNamed:@"shadow-bottom.png"];

  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.contentInset = UIEdgeInsetsMake(-29, 0, 0, 0);
  self.tableView.tableHeaderView = top;
  self.tableView.tableFooterView = btm;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.rowHeight = 80;
  self.tableView.backgroundColor = [UIColor clearColor];
  
  refresh_ = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)] retain];
  
  UIActivityIndicatorView *indicator_ = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
  [indicator_ startAnimating];
  
  spinner_ = [[[UIBarButtonItem alloc] initWithCustomView:indicator_] retain];

  btnMap_  = [[[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStyleBordered target:self action:@selector(showMap)] retain];
  btnList_ = [[[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStyleBordered target:self action:@selector(showList)] retain];
  
  self.navigationItem.rightBarButtonItem = refresh_;
  self.navigationItem.leftBarButtonItem  = btnMap_;
}

- (void)showMap {
  [self.tableView removeFromSuperview];
  [self.view addSubview:map_];

  CATransition *animation = [CATransition animation];
  [animation setDuration:0.5];
  [animation setType:kCATransitionPush];
  [animation setSubtype:kCATransitionFromBottom];
  [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];

  [[self.view layer] addAnimation:animation forKey:@"SwitchToView1"];
  
  self.navigationItem.leftBarButtonItem = btnList_;
}

- (void)showList {
  [map_ removeFromSuperview];
  [self.view addSubview:self.tableView];

  CATransition *animation = [CATransition animation];
  [animation setDuration:0.5];
  [animation setType:kCATransitionPush];
  [animation setSubtype:kCATransitionFromTop];
  [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];

  [[self.view layer] addAnimation:animation forKey:@"SwitchToView2"];
  
  self.navigationItem.leftBarButtonItem = btnMap_;
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
  [map_ addAnnotations:stores_];
  [self recenterMap];
  
  if ([stores_ count] == 0) {
    [self invalidateViewState:TTViewEmpty];
  }
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

#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
  MKPinAnnotationView *view = nil;
  
  NSLog(@"annotation: %f,%f", annotation.coordinate.latitude, annotation.coordinate.longitude);

  if (annotation != mapView.userLocation) {
    view = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MKPinAnnotationViewIdentifier"];
    if (nil == view) {
      view = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MKPinAnnotationViewIdentifier"] autorelease];
      view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    [view setPinColor:MKPinAnnotationColorRed];
    [view setCanShowCallout:YES];
    [view setAnimatesDrop:YES];
  } // else {
  //     [self setCurrentLocation:[CMLocation instance].currentLocation];
  //   }
  return view;
}

#pragma mark Alert methods

- (void)hideAlert {
  self.navigationItem.rightBarButtonItem = refresh_;
  self.tableView.hidden = NO;
  [self invalidateViewState:TTViewDataLoaded];
}

- (void)showAlert {
  [self invalidateViewState:TTViewLoading];
  self.navigationItem.rightBarButtonItem = spinner_;
  self.tableView.hidden = YES;
}

- (void)userDidShake {
  [self refresh];
}

- (void)tabBar:(TTTabBar*)tabBar tabSelected:(NSInteger)selectedIndex {
  storeFilter_ = (selectedIndex - 1);
  isDirty_ = YES;
  [NSThread detachNewThreadSelector:@selector(getStores:) toTarget:self withObject:[NSNumber numberWithInt:storeFilter_]];
  [self showAlert];
}

- (void)updateLoadingView {
  if (self.viewState & TTViewLoading) {
    CGRect frame = CGRectMake(0, 0, self.view.width, self.view.height);
    TTActivityLabel* label = [[[TTActivityLabel alloc] initWithFrame:frame style:TTActivityLabelStyleBlackBezel] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"Loading...";
    label.centeredToScreen = YES;
    [self.view addSubview:label];
    
    [statusView_ release];
    statusView_ = [label retain];
    
    return;
  } 
  
  [statusView_ removeFromSuperview];
  [statusView_ release];
  statusView_ = nil;
}

- (void)updateDataView {
}

- (NSString*)titleForActivity {
  return @"some title";
}

@end