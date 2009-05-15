//
//  CMDrinksController.m
//  CoffeeMe
//
//  Created by min on 5/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMDrinksController.h"
#import "CMNutritionController.h"
#import "CMDrinksDataSource.h"


@implementation CMDrinksController

@synthesize drinks = drinks_;

- (void)loadView {
    CGRect appFrame = [UIScreen mainScreen].applicationFrame;
    self.view = [[[UIView alloc] initWithFrame:appFrame] autorelease];
     
    self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.variableHeightRows = YES;
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
    NSString *drinkName = [object text];
    CMNutritionController *nutritionController = [[CMNutritionController alloc] initWithDrinkName:[[drinkName copy] autorelease]];
    [self.navigationController pushViewController:nutritionController animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTSearchTextFieldDelegate

- (void)textField:(TTSearchTextField*)textField didSelectObject:(id)object {

    // [_delegate searchTestController:self didSelectObject:object];
}

- (void)dealloc {
    [super dealloc];
}


@end
