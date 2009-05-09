//
//  CMModalView.h
//  CoffeeMe
//
//  Created by min on 5/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CMModalView : UIView {
    UIImageView *cup_;
    UIView *window_;
    UIView *background_;
    NSTimer *timer_;
    float mAngle_;
}

- (id)initWithWindow:(UIView *)window;
- (void)show:(BOOL)shouldShow;

@end
