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
  self.variableHeightRows = YES;
  self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds
    style:UITableViewStyleGrouped] autorelease];
	self.tableView.autoresizingMask = 
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self.view addSubview:self.tableView];
}

- (id<TTTableViewDataSource>)createDataSource {
    
    TTImageTableField *map = [[[TTImageTableField alloc] initWithText:@"Map"] autorelease];
    map.url = [store_ gmapUrl];
    
    return [TTSectionedDataSource dataSourceWithObjects:
      @"",
      [[[TTTitledTableField alloc] initWithTitle:@"Address"
        text:[store_ address]] autorelease],
      [[[TTTitledTableField alloc] initWithTitle:@"Call"
        text:[store_ phone]] autorelease],
      [[[TTTitledTableField alloc] initWithTitle:@"Distance"
        text:[store_ formattedDistance]] autorelease],
      @"",
      [[[TTButtonTableField alloc] initWithText:@"Map"] autorelease],
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
