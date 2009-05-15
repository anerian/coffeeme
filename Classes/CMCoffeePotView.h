//
//  CMCoffeePotView.h
//  CoffeeMe
//
//  Created by min on 5/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CMCoffeePotView : UIView {
    UIView *liquid_;
    UIImageView *pot_;
}

- (void)tilt:(float)degrees;

@end
