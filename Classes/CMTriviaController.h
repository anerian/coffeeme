//
//  CMTriviaController.h
//  CoffeeMe
//
//  Created by min on 5/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBaseController.h"
#import "CMTrivia.h"
#import "CMTriviaView.h"


@interface CMTriviaController : CMBaseController {
    CMTriviaView *triviaView_;
}

- (void)refresh;

@end
