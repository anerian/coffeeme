//
//  CMTriviaController.m
//  CoffeeMe
//
//  Created by min on 5/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMTriviaController.h"

@implementation CMTriviaController

- (id)init {
  if (self = [super init]) {
    triviaView_ = [[[CMTriviaView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] retain];
  }
  return self;
}

- (void)loadView {
  [super loadView];
  self.view = triviaView_;
  self.supportsAccelerometer = YES;
  self.navigationBarTintColor = HexToUIColor(0x372010);
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self refresh];    
}
- (void)viewDidLoad {
  self.navigationItem.rightBarButtonItem = 
    [[[UIBarButtonItem alloc] initWithTitle:@"More" 
                                      style:UIBarButtonItemStyleBordered
                                     target:self 
                                     action:@selector(refresh)] autorelease];
}

- (void)userDidShake {
  [self refresh];
}

- (void)userDidRotate:(float)angle {
  [triviaView_ rotate:angle-90];
}

- (void)refresh {
  [((CMTriviaView*)self.view) updateTrivia];
}

- (void)dealloc {
  [triviaView_ release];
  [super dealloc];
}

@end