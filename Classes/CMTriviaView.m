//
//  CMTriviaView.m
//  CoffeeMe
//
//  Created by Todd Fisher on 5/10/09.
//  Copyright 2009 Anerian LLC. All rights reserved.
//

#import "CMTriviaView.h"

@implementation CMTriviaView

@synthesize text = _text;

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor whiteColor];
  }
  return self;
}

- (void)setText:(NSString *)text {
  NSLog(text);
  [_text autorelease];
  _text = [text copy];
  [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  // [self updateTrivia];
}

- (void)drawRect:(CGRect)rect {
  if (!_text) return;
  [[UIImage imageNamed:@"bg-corkboard.jpg"] drawAsPatternInRect:rect];
  
  [_text drawInRect:CGRectMake(10,10,300,400) 
           withFont:[UIFont boldSystemFontOfSize:16] 
      lineBreakMode:UILineBreakModeWordWrap
          alignment:UITextAlignmentCenter];
  
  // do the drawing in here
}

- (void)dealloc {
  [_text release];
  [super dealloc];
}

@end