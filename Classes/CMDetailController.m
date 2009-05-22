//
//  CMDetailController.m
//  CoffeeMe
//
//  Created by min on 5/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMDetailController.h"


@implementation CMDetailController

- (id)initWithStore:(CMStore *)store {
  if (self = [super init]) {
    store_ = [store retain];
        
    self.title = @"Details";
  }
  return self;
}

- (void)loadView {
  [super loadView];
  detailView_ = [[CMDetailView alloc] initWithFrame:self.view.bounds withStore:store_]; 
  [self.view addSubview:detailView_];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
  [store_ release];
  [detailView_ release];
  [super dealloc];
}

@end