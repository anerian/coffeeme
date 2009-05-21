//
//  CMTriviaView.m
//  CoffeeMe
//
//  Created by Todd Fisher on 5/10/09.
//  Copyright 2009 Anerian LLC. All rights reserved.
//

#import "CMTriviaView.h"
#import "CMTrivia.h"

@implementation CMTriviaView

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor whiteColor];

    cup_ = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-trivia.png"]] retain];
    coffee_ = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-coffee.png"]] retain];

    fact_ = [[UITextView alloc] initWithFrame:CGRectMake(80, 110, 170, 140)];
    fact_.backgroundColor = [UIColor clearColor];
    fact_.textColor = [UIColor whiteColor];
    fact_.editable = NO;
    fact_.font = [UIFont systemFontOfSize:14];
    fact_.textAlignment = UITextAlignmentCenter;
        
    [self addSubview:coffee_];
    [self addSubview:cup_];
    [self addSubview:fact_];
  }
  return self;
}

- (void)rotate:(float)angle {
  coffee_.transform = CGAffineTransformMakeRotation(DEG2RAD(angle));
}

- (void)updateTrivia {
  fact_.text = [[[CMTrivia randomTrivia].fact copy] autorelease];
  // XXX: below code cuases the coffee graphic to move out of the cup bounds
   /* CATransition *transition = [CATransition animation];
    transition.type = @"rippleEffect";
    transition.duration = 2.0f;
    transition.timingFunction = UIViewAnimationCurveEaseInOut;
    [[coffee_ layer] addAnimation:transition forKey:@"transitionViewAnimation"];
	*/
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [self updateTrivia];
}

- (void)drawRect:(CGRect)rect {
}

- (void)dealloc {
  [cup_ release];
  [coffee_ release];
  [fact_ release];
  [super dealloc];
}

@end