//
//  CMDetailView.h
//  CoffeeMe
//
//  Created by min on 5/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMStore.h"
#import "CMMapView.h"

@interface CMDetailView : UIView<TTImageViewDelegate, UIScrollViewDelegate> {
    CMStore *store_;
}

- (id)initWithFrame:(CGRect)frame withStore:(CMStore *)store;

@end