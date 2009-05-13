//
//  CMModalView.m
//  CoffeeMe
//
//  Created by min on 5/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMModalView.h"

@interface CMModalView(PrivateMethods)

- (void)startAnimation;
- (void)stopAnimation;

@end

@implementation CMModalView

- (id)initWithWindow:(UIView *)window {
    if (self = [super initWithFrame:window.bounds]) {
        window_ = window;
        
        background_ = [[[UIView alloc] initWithFrame:self.frame] autorelease];
        background_.backgroundColor = [UIColor blackColor];
        background_.alpha = 0.8;
        
        cup_ = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cup.png"]] retain];
        cup_.center = self.center;
        
        [self addSubview:background_];
        [self addSubview:cup_];
    }
    return self;
}

- (void)show:(BOOL)shouldShow {
    mAngle_ = 0;
    
    if (shouldShow) {
        [window_ addSubview:self];
        [window_ bringSubviewToFront:self];
        cup_.alpha = 0;
        background_.alpha = 0;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        cup_.alpha = 1;
        background_.alpha = 0.8;
        
        [UIView commitAnimations];

        [self startAnimation];
    } else {
        [self stopAnimation];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(willDisappear)];
        cup_.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(-2 * M_PI), CGAffineTransformMakeScale(3.0,3.0));
        cup_.alpha = 0;
        background_.alpha = 0;
        
        [UIView commitAnimations];
    }
}

- (void)willDisappear {
    [self removeFromSuperview];
    cup_.transform = CGAffineTransformMakeScale(1.0,1.0);
    cup_.alpha = 1;
    background_.alpha = 1;
}

- (void)rotateCup {
    cup_.transform = CGAffineTransformMakeRotation(mAngle_);
    mAngle_ += 0.1;
}

- (void)startAnimation {
    timer_ = [NSTimer scheduledTimerWithTimeInterval:(1.0/30.0) target:self selector:@selector(rotateCup) userInfo:nil repeats:YES];
}

- (void)stopAnimation {
    [timer_ invalidate];
    timer_ = nil;
}

- (void)dealloc {
    [cup_ release];
    [super dealloc];
}

@end
