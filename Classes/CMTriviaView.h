//
//  CMTriviaView.h
//  CoffeeMe
//
//  Created by Todd Fisher on 5/10/09.
//  Copyright 2009 Anerian LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMTrivia.h"

@interface CMTriviaView : UIImageView {
  UILabel *label_;
}
@property (nonatomic, retain) UILabel *label;

-(void) updateTrivia;

@end
