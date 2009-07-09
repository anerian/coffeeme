//
//  CMStoreTypesController.m
//  CoffeeMe
//
//  Created by min on 5/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMStoreTypesController.h"
#import "CMDrinksController.h"
#import "CMDrink.h"


@implementation CMStoreTypesController

- (void)loadView {
  [super loadView];
  
  self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds
    style:UITableViewStylePlain] autorelease];
	self.tableView.autoresizingMask = 
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.view addSubview:self.tableView];
  
  self.navigationBarTintColor = HexToUIColor(0x2c1e10);
  self.statusBarStyle = UIStatusBarStyleBlackOpaque;
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"CMStoreTypeCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  CMDrinksController *drinksController = [[[CMDrinksController alloc] init] autorelease];
  drinksController.drinks = [CMDrink forStore:indexPath.row];
  
  [self.navigationController pushViewController:drinksController animated:YES];
}

- (void)viewDidLoad {
  // TTNavigationCenter* nav = [TTNavigationCenter defaultCenter];
  // nav.mainViewController = self.navigationController;
  // nav.delegate = self;
  // nav.urlSchemes = [NSArray arrayWithObject:@"cm"];
  // 
  // [nav addView:@"drinks" controller:[CMDrinksController class]];
  // self.navigationBarTintColor = HexToUIColor(0x372010);
}

- (id<TTTableViewDataSource>)createDataSource {
  return [TTListDataSource dataSourceWithObjects:
    [TTTableTextItem itemWithText:@"Starbucks" URL:@"cm://drinks/0"],
    [TTTableTextItem itemWithText:@"Dunkin Donuts" URL:@"cm://drinks/1"],
    [TTTableTextItem itemWithText:@"Caribou" URL:@"cm://drinks/2"],
    nil];
}

- (void)willNavigateToObject:(id)object inView:(NSString*)viewType withController:(UIViewController*)viewController {
  NSIndexPath* indexPath = self.tableView.indexPathForSelectedRow;

  ((CMDrinksController *)viewController).drinks = [CMDrink forStore:indexPath.row];
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


@end
