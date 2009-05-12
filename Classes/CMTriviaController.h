//
//  CMTriviaController.h
//  CoffeeMe
//
//  Created by min on 5/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMTrivia.h"


@interface CMTriviaController : UIViewController<UIAccelerometerDelegate> {
    CFTimeInterval lastShake_;
}

- (void)refresh;

@end
