//
//  CMMapView.h
//  CoffeeMe
//
//  Created by min on 5/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CMMapView : TTImageView<TTImageViewDelegate> {

}

- (id)initWithFrame:(CGRect)frame withCoordinate:(CLLocationCoordinate2D)coordinate;

@end
