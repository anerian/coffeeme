//
//  CMDetailView.m
//  CoffeeMe
//
//  Created by min on 5/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMDetailView.h"

@interface CMDetailView(PrivateMethods)

- (UILabel *)createLabel:(CGRect)frame;

@end

@implementation CMDetailView

- (id)initWithFrame:(CGRect)frame withStore:(CMStore *)store {
    if (self = [super initWithFrame:frame]) {
        self.contentSize = frame.size;
        store_ = [store retain];
        
        mapView_ = [[[CMMapView alloc] initWithFrame:CGRectMake((320-280)/2,100,280,280) withCoordinate:store_.location.coordinate] retain];
        // mapView_.style = [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:10] next:
        // [TTSolidFillStyle styleWithColor:[UIColor whiteColor] next:
        // [TTInnerShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.5) blur:6 offset:CGSizeMake(1, 1) next:
        // [TTSolidBorderStyle styleWithColor:[UIColor grayColor] width:1 next:nil]]]];
        // mapView_.backgroundColor = [UIColor clearColor];
        // 
        // gmapView_ = [[[TTImageView alloc] initWithFrame:CGRectMake(0,0,280,280)] retain];
        // [gmapView_ setUrl:[store_ gmapUrl]];
        
        [self addSubview:mapView_];
        // [mapView_ addSubview:gmapView_];
        
        // UIImageView *pin_ = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin-blue.png"]] autorelease];
        // pin_.frame = CGRectMake(140-16,140-50,33,50);
        // [gmapView_ addSubview:pin_];
        
        
        address_ = [[self createLabel:CGRectMake(20,10,280,50)] retain];
        address_.text = [store_ address];
        address_.numberOfLines = 2;
        
        // CGPoint point = [CMStore coordinate2CGPoint:store_.location.coordinate];
        // NSLog(@"center: %f, %f", point.x, point.y);
        self.backgroundColor = HexToUIColor(0xededed);
        
        [self addSubview:address_];
    }
    return self;
}

# pragma mark Private Methods

- (UILabel *)createLabel:(CGRect)frame {
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.font = [UIFont boldSystemFontOfSize:15];
    label.backgroundColor = [UIColor clearColor];
    label.shadowOffset = CGSizeMake(0,1);
    label.shadowColor = [UIColor whiteColor];
    label.textColor = [UIColor blackColor];
    return label;
}

- (void)dealloc {
    [mapView_ release];
    [store_ release];
    
    [company_ release];
    [address_ release];
    [distance_ release];
    [super dealloc];
}

@end