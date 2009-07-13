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
  _triviaView.page.delegate = self;
  self.view = _triviaView;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [_trivias release];
  _trivias = [[CMTrivia allByRandomOrder] retain];
  _currentIndex = 0;
  
  [self refresh:CMTriviaPageSwipeNone];
}
- (void)viewDidLoad {
  self.navigationItem.rightBarButtonItem = 
    [[[UIBarButtonItem alloc] initWithTitle:@"More" 
                                      style:UIBarButtonItemStyleBordered
                                     target:self 
                                     action:@selector(flip)] autorelease];
}

- (void)flip {
  [self refresh:CMTriviaPageSwipeUp];
}

- (void)refresh:(CMTriviaPageSwipe)swipe {
  if (_currentIndex < 0) _currentIndex = [_trivias count] - 1;
  if (_currentIndex >= [_trivias count]) _currentIndex = 0;
  
  CMTrivia *_trivia = [_trivias objectAtIndex:_currentIndex];
  [((CMTriviaView*)self.view).page setText:_trivia.fact swipe:swipe];
  
  _currentIndex++;
}

- (void)dealloc {
  [_triviaView release];
  [super dealloc];
}

- (void)triviaPage:(CMTriviaPage *)triviaPage didSwipe:(CMTriviaPageSwipe)swipe {
  if (swipe == CMTriviaPageSwipeDown) {
    _currentIndex--;
    _currentIndex--;
  }
  
  [self refresh:swipe];
}

@end