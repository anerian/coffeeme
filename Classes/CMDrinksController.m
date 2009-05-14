//
//  CMDrinksController.m
//  CoffeeMe
//
//  Created by min on 5/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMDrinksController.h"
#import "CMDrinksDataSource.h"


@implementation CMDrinksController

@synthesize drinks = drinks_;

- (void)loadView {
    CGRect appFrame = [UIScreen mainScreen].applicationFrame;
    self.view = [[[UIView alloc] initWithFrame:appFrame] autorelease];
     
    self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.sectionIndexMinimumDisplayRowCount = 2;
    [self.view addSubview:self.tableView];

    TTSearchBar* searchBar = [[[TTSearchBar alloc] initWithFrame:CGRectMake(0, 0, appFrame.size.width, 0)] autorelease];
    searchBar.delegate = self;
    
    searchBar.dataSource = [[[CMDrinksDataSource alloc] initWithDrinks:drinks_] autorelease];
    searchBar.showsDoneButton = YES;
    searchBar.showsDarkScreen = YES;
    [searchBar sizeToFit];
    self.tableView.tableHeaderView = searchBar;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewController

- (id<TTTableViewDataSource>)createDataSource {
    CMDrinksDataSource *dataSource = [[[CMDrinksDataSource alloc] initWithDrinks:drinks_] autorelease];
    [dataSource rebuildItems];
    
    return dataSource;
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    // [_delegate searchTestController:self didSelectObject:object];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTSearchTextFieldDelegate

- (void)textField:(TTSearchTextField*)textField didSelectObject:(id)object {
    // [_delegate searchTestController:self didSelectObject:object];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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


@end
