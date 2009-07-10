//
//  CMTriviaView.m
//  CoffeeMe
//
//  Created by Todd Fisher on 5/10/09.
//  Copyright 2009 Anerian LLC. All rights reserved.
//

#import "CMTriviaView.h"

@implementation CMTriviaPage

@synthesize text = _text;

- (id)init {
  if (self = [super initWithFrame:CGRectMake(0,0,320,276)]) {
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

- (void)drawRect:(CGRect)rect {
  [[UIImage imageNamed:@"bg-corkboard.jpg"] drawAsPatternInRect:rect];
  [[UIImage imageNamed:@"bg-sticky-pad.png"] drawInRect:CGRectMake(0,0,320,276)];
  
  [[UIImage imageNamed:@"bg-sticky.png"] drawInRect:CGRectMake(0,0,320,276)];
  
  if (!_text) return;

  [[UIColor blackColor] set];
  [_text drawInRect:CGRectMake(45,20,225,400) 
           withFont:[UIFont fontWithName:@"MarkerFelt-Thin" size:14]
      lineBreakMode:UILineBreakModeWordWrap
          alignment:UITextAlignmentCenter];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation CMTriviaView

@synthesize page = _page;

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor whiteColor];
    _page = [[[CMTriviaPage alloc] init] retain];
    
    [self addSubview:_page];
  }
  return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  // [self updateTrivia];
}

- (void)drawRect:(CGRect)rect {
  [[UIImage imageNamed:@"bg-corkboard.jpg"] drawAsPatternInRect:rect];
  [[UIImage imageNamed:@"bg-sticky-pad.png"] drawInRect:CGRectMake(0,0,320,276)];
}

- (void)dealloc {
  [_page release];
  [super dealloc];
}

@end