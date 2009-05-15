//
//  CMMapView.m
//  CoffeeMe
//
//  Created by min on 5/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMMapView.h"


@implementation CMMapView

- (id)initWithFrame:(CGRect)frame withCoordinate:(CLLocationCoordinate2D)coordinate {
    if (self = [super initWithFrame:frame]) {
        // self.style = [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:10] next:
        // [TTSolidFillStyle styleWithColor:[UIColor whiteColor] next:
        // [TTInnerShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.5) blur:6 offset:CGSizeMake(1, 1) next:
        // [TTSolidBorderStyle styleWithColor:[UIColor grayColor] width:1 next:nil]]]];
        
        self.url = [NSString stringWithFormat:@"http://maps.google.com/staticmap?center=%f,%f&zoom=14&size=300x236&maptype=mobile&key=%@&sensor=false", coordinate.latitude, coordinate.longitude, GMAP_KEY];
    }
    return self;
}


- (void)dealloc {
    [super dealloc];
}

@end