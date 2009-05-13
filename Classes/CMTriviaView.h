//
//  CMTriviaView.h
//  CoffeeMe
//
//  Created by Todd Fisher on 5/10/09.
//  Copyright 2009 Anerian LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMTrivia.h"

@interface CMTriviaView : UIView {
  UIImageView *cup_;
  UIImageView *coffee_;
  UITextView *fact_;
}

- (void)updateTrivia;
- (void)rotate:(float)angle;

@end