//
//  CMDetailView.m
//  CoffeeMe
//
//  Created by min on 5/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMDetailView.h"


@implementation CMDetailView

- (id)initWithFrame:(CGRect)frame withStore:(CMStore *)store {
    if (self = [super initWithFrame:frame]) {
        store_ = [store retain];
        
        gmapView_ = [[[TTImageView alloc] initWithFrame:CGRectMake(0,0,256,256)] retain];
        [gmapView_ setUrl:[store_ gmapUrl]];
        [self addSubview:gmapView_];
        
        // CGPoint point = [CMStore coordinate2CGPoint:store_.location.coordinate];
        // NSLog(@"center: %f, %f", point.x, point.y);
    }
    return self;
}

- (void)dealloc {
    [gmapView_ release];
    [store_ release];
    [super dealloc];
}

@end
