//
//  CMDetailView.m
//  CoffeeMe
//
//  Created by min on 5/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMDetailView.h"

@implementation CMDetailContentView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [[[UIImage imageNamed:@"bg-detail-content.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:100] drawInRect:rect];
}

@end

@interface CMDetailView(PrivateMethods)

- (UILabel *)createLabel:(CGRect)frame;

@end

@implementation CMDetailView

- (id)initWithFrame:(CGRect)frame withStore:(CMStore *)store {
    if (self = [super initWithFrame:frame]) {
        scroller_ = [[UIScrollView alloc] initWithFrame:frame];
        scroller_.contentSize = CGSizeMake(320, frame.size.height); 
        scroller_.delegate = self;
        scroller_.showsVerticalScrollIndicator = NO;
        scroller_.alwaysBounceVertical = YES;
        
        CMDetailContentView *content = [[[CMDetailContentView alloc] initWithFrame:CGRectMake(0,70,320,frame.size.height)] autorelease];
        content.backgroundColor = [UIColor clearColor];
        [scroller_ addSubview:content];
        
        
        mapView_ = [[[CMMapView alloc] initWithFrame:CGRectMake(10,40,300,236) withCoordinate:(CLLocationCoordinate2D){store.latitude, store.longitude}] retain];
        mapView_.backgroundColor = [UIColor clearColor];
        [content addSubview:mapView_];
        
        address_ = [[self createLabel:CGRectMake(20,10,280,50)] retain];
        address_.text = [store address];
        address_.numberOfLines = 2;

        // // // CGPoint point = [CMStore coordinate2CGPoint:store_.location.coordinate];
        // // // NSLog(@"center: %f, %f", point.x, point.y);
        // // // self.backgroundColor = HexToUIColor(0xededed);
        // // self.backgroundColor = [UIColor whiteColor];
        // // 
        // // TTButton *call = [TTButton buttonWithStyle:@"embossedButton:" title:@"Call"];
        // // call.frame = CGRectMake(20,80,135,43);
        // // 
        // // TTButton *mapIt = [TTButton buttonWithStyle:@"embossedButton:" title:@"Show on Map"];
        // // mapIt.frame = CGRectMake(165,80,135,43);
        // // 
        // // 
        // // [self addSubview:call];
        // // [self addSubview:mapIt];
        // 
        [self addSubview:address_];
        [self addSubview:scroller_];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [[[UIImage imageNamed:@"bg-detail.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:100] drawInRect:rect];
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