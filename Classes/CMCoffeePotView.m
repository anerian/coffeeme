//
//  CMCoffeePotView.m
//  CoffeeMe
//
//  Created by min on 5/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMCoffeePotView.h"


@implementation CMCoffeePotView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        pot_ = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-pot.png"]] retain];
        liquid_ = [[UIView alloc] initWithFrame:CGRectMake(-400, 20, 1120, 600)];
        liquid_.backgroundColor = [UIColor redColor];
        [self addSubview:liquid_];
        [self addSubview:pot_];
        
    }
    return self;
}

- (void)tilt:(float)degrees {
    liquid_.transform = CGAffineTransformMakeRotation(DEG2RAD(degrees));
}

@end
