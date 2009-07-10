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
    self.supportsAccelerometer = YES;
    self.navigationBarTintColor = HexToUIColor(0x372010);
    _trivias = nil;
  }
  return self;
}

- (void)loadView {
  [super loadView];
  _triviaView = [[[CMTriviaView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
  self.view = _triviaView;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [_trivias release];
  _trivias = [[CMTrivia allByRandomOrder] retain];
  _currentIndex = 0;
  
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

- (void)refresh {
  if (_currentIndex >= [_trivias count]) _trivias = 0;
  
  CMTrivia *_trivia = [_trivias objectAtIndex:_currentIndex];
  _currentIndex++;
  [((CMTriviaView*)self.view) setText:_trivia.fact];
}

- (void)dealloc {
  [_triviaView release];
  [super dealloc];
}

@end