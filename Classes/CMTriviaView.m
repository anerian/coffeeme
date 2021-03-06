//
//  CMTriviaView.m
//  CoffeeMe
//
//  Created by Todd Fisher on 5/10/09.
//  Copyright 2009 Anerian LLC. All rights reserved.
//

#import "CMTriviaView.h"

@implementation CMTriviaPage

#define kDragDistance 50

@synthesize text = _text, delegate = _delegate;

- (id)init {
  if (self = [super initWithFrame:CGRectMake(32,56,256,307)]) {
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    self.userInteractionEnabled = YES;
    
    _isSwipe = NO;
  }
  return self;
}

- (void)setText:(NSString *)text swipe:(CMTriviaPageSwipe)swipe {
  [_text autorelease];
  _text = [text copy];
  [self setNeedsDisplay];

  if (swipe != CMTriviaPageSwipeNone) {
    [UIView beginAnimations:nil  context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:((swipe == CMTriviaPageSwipeUp) ? UIViewAnimationTransitionCurlUp : UIViewAnimationTransitionCurlDown) forView:self cache:YES];
    [UIView commitAnimations];
  }
}

- (void)setText:(NSString *)text {
  [self setText:text swipe:CMTriviaPageSwipeUp];
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  [[UIImage imageNamed:@"bg-notesheet-bottom.png"] drawInRect:rect];
  
  if (!_text) return;

  [HexToUIColor(0x321d0e) set];
  
  [_text drawInRect:CGRectMake(10,10,self.width-20,self.height-20) 
           withFont:[UIFont fontWithName:@"AmericanTypewriter" size:18]
      lineBreakMode:UILineBreakModeWordWrap
          alignment:UITextAlignmentCenter];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  _swipe   = CMTriviaPageSwipeNone;
  _isSwipe = NO;
  _startTouchPosition = [[touches anyObject] locationInView:self]; 
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject]; 
  CGPoint currentTouchPosition = [touch locationInView:self]; 
  float deltaY = currentTouchPosition.y - _theSecondLastPosition.y;

  float moveSpeed = fabsf(deltaY / (touch.timestamp - _theSecondLastTime));

  if (moveSpeed >= 1000.0) { 
    _isSwipe = YES;
    
    if (_theSecondLastPosition.y > currentTouchPosition.y){ 
      _swipe = CMTriviaPageSwipeUp;
    } else {
      _swipe = CMTriviaPageSwipeDown;
    }
  } else if (!_isSwipe) {
    _swipe = CMTriviaPageSwipeNone;
  }

  _theSecondLastPosition = [touch locationInView:self]; 
  _theSecondLastTime = touch.timestamp;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  if (_swipe != CMTriviaPageSwipeNone) {
    if ([_delegate respondsToSelector:@selector(triviaPage:didSwipe:)]) {
      [_delegate triviaPage:self didSwipe:_swipe];
    }
  }
  _swipe = CMTriviaPageSwipeNone;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation CMTriviaView

@synthesize page = _page;

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _page = [[[CMTriviaPage alloc] init] retain];
    
    [self addSubview:_page];
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  [[UIImage imageNamed:@"bg-corkboard.jpg"] drawAsPatternInRect:rect];
  [[UIImage imageNamed:@"bg-notesheet.png"] drawInRect:CGRectMake(32,10,256,353)];
}

- (void)dealloc {
  [_page release];
  [super dealloc];
}

@end