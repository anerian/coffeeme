//
//  CMTriviaView.h
//  CoffeeMe
//
//  Created by Todd Fisher on 5/10/09.
//  Copyright 2009 Anerian LLC. All rights reserved.
//

@protocol CMTriviaPageDelegate;

@interface CMTriviaPage : UIView {
  NSString       *_text;
  CGPoint        _startTouchPosition;
  NSTimeInterval _theSecondLastTime;
  CGPoint        _theSecondLastPosition;
  BOOL           _isSwipe;
  id<CMTriviaPageDelegate>_delegate;
}

@property(nonatomic, copy) NSString *text;
@property(nonatomic, assign) id<CMTriviaPageDelegate> delegate;

- (void)setText:(NSString *)text animated:(BOOL)animated;

@end

@protocol CMTriviaPageDelegate<NSObject>

- (void)triviaPageDidSwipe;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@interface CMTriviaView : UIView {
  CMTriviaPage *_page;
}

@property(nonatomic, readonly) CMTriviaPage *page;

@end