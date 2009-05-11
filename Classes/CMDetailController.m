//
//  CMDetailController.m
//  CoffeeMe
//
//  Created by min on 5/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMDetailController.h"
#import "CMDetailView.h"


@implementation CMDetailController


- (id)initWithStore:(CMStore *)store {
    if (self = [super init]) {
        store_ = [store retain];
    }
    return self;
}

// - (void)loadView {
//     [super loadView];
//     
//     self.view = [[[CMDetailView alloc] initWithFrame:self.view.bounds withStore:store_] autorelease];
// }

- (void)loadView {
  [super loadView];

  self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds
    style:UITableViewStyleGrouped] autorelease];
	self.tableView.autoresizingMask = 
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self.view addSubview:self.tableView];
}

- (id<TTTableViewDataSource>)createDataSource {
    
    TTImageTableField *map = [[[TTImageTableField alloc] init] autorelease];
    map.url = [store_ gmapUrl];
    
    return [TTSectionedDataSource dataSourceWithObjects:
      @"Map",
      map,
      [[[TTTableField alloc] initWithText:@"Search Bar"
        url:@"tt://searchTest"] autorelease],

      @"Styles",
      [[[TTTableField alloc] initWithText:@"Styled Views"
        url:@"tt://styleTest"] autorelease],
      [[[TTTableField alloc] initWithText:@"Styled Labels"
        url:@"tt://styledTextTest"] autorelease],

      @"Controls",
      [[[TTTableField alloc] initWithText:@"Buttons"
        url:@"tt://buttonTest"] autorelease],
      [[[TTTableField alloc] initWithText:@"Tabs"
        url:@"tt://tabBarTest"] autorelease],

      @"Tables",
      [[[TTTableField alloc] initWithText:@"Table States"
        url:@"tt://tableTest"] autorelease],
      [[[TTTableField alloc] initWithText:@"Table Cells"
        url:@"tt://tableFieldTest"] autorelease],
      [[[TTTableField alloc] initWithText:@"Styled Labels in Table"
        url:@"tt://styledTextTableTest"] autorelease],
      [[[TTTableField alloc] initWithText:@"Web Images in Table"
        url:@"tt://imageTest2"] autorelease],

      @"General",
      [[[TTTableField alloc] initWithText:@"Web Image"
        url:@"tt://imageTest1"] autorelease],
      [[[TTTableField alloc] initWithText:@"Activity Labels"
        url:@"tt://activityTest"] autorelease],
      [[[TTTableField alloc] initWithText:@"Scroll View"
        url:@"tt://scrollViewTest"] autorelease],
      nil];
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
