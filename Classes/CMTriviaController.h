//
//  CMTriviaController.h
//  CoffeeMe
//
//  Created by min on 5/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMBaseController.h"
#import "CMTrivia.h"
#import "CMTriviaView.h"


@interface CMTriviaController : CMBaseController<CMTriviaPageDelegate> {
  CMTriviaView *_triviaView;
  NSArray      *_trivias;
  NSUInteger   _currentIndex;
}

- (void)refresh;

@end