//
//  CMDetailView.h
//  CoffeeMe
//
//  Created by min on 5/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMStore.h"


@interface CMDetailView : UIView<TTImageViewDelegate> {
    CMStore *store_;
    
    TTImageView *gmapView_;
}

- (id)initWithFrame:(CGRect)frame withStore:(CMStore *)store;

@end