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
        // [self addSubview:cup_];
        UIImageView *steam_ = [[[UIImageView alloc] initWithFrame:CGRectMake(40,0,240,290)] autorelease];
        // UIImageView *mug_ = [[[UIImageView alloc] initWithFrame:CGRectMake(0,280,320,182)] autorelease];
        // mug_.image = [UIImage imageNamed:@"mug.png"];
        NSMutableArray *steamImages = [NSMutableArray arrayWithCapacity:28];
        for (int i = 1; i <= 14; i++) {
            [steamImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"coffeeme_steam-%d.png", i]]];
        }
        for (int i = 14; i >= 1; i--) {
            [steamImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"coffeeme_steam-%d.png", i]]];
        }
        steam_.animationImages = steamImages;
        steam_.animationDuration = 2;
        [steam_ startAnimating];
        [self addSubview:steam_];
        // [self addSubview:mug_];
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
        
        // [UIView beginAnimations:nil context:nil];
        // [UIView setAnimationDuration:1];
        cup_.alpha = 1;
        background_.alpha = 0.8;

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
    // timer_ = [NSTimer scheduledTimerWithTimeInterval:(1.0/30.0) target:self selector:@selector(rotateCup) userInfo:nil repeats:YES];
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
