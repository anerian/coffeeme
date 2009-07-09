//
//  CMDetailController.h
//  CoffeeMe
//
//  Created by min on 5/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMDetailView.h"
#import "CMStore.h"


@interface CMDetailController : UIViewController<MKMapViewDelegate> {
  CMDetailView *detailView_;
  CMStore *store_;
  MKMapView *mapView_;
}

- (id)initWithStore:(CMStore *)store;

@end