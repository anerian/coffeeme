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

@interface CMDetailHeaderView : UIView {
}
@end

@interface CMDetailContentView : UIView {
}
@end

@interface CMDetailView : UIView<TTImageViewDelegate, UIScrollViewDelegate> {
    UIScrollView *scroller_;
    CMStore *store_;
    CMMapView *mapView_;
    
    UILabel *company_;
    UILabel *address_;
    UILabel *distance_;
}

- (id)initWithFrame:(CGRect)frame withStore:(CMStore *)store;

@end