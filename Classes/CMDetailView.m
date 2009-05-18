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
    self.backgroundColor = HexToUIColor(0xfbf6ec);
    
    UILabel *storeType_ = CMLabelMake(CGRectMake(70,10,230,24), 18, YES);
    storeType_.textColor = CMTextColor;
    storeType_.text = [CMStore storeNameForCode:store.type];
    
    UILabel *address_ = CMLabelMake(CGRectMake(70,34,230,40), 16, NO);
    address_.numberOfLines = 2;
    address_.text = [store address];
    
    TTButton *call_ = [TTButton buttonWithStyle:@"blueToolbarButton:" title:@"Call"];
    call_.frame = CGRectMake(20,80,135,43);
    [call_ addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];

    TTButton *mapIt_ = [TTButton buttonWithStyle:@"blueToolbarButton:" title:@"Get directions"];
    mapIt_.frame = CGRectMake(165,80,135,43);
    [mapIt_ addTarget:self action:@selector(mapIt) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:storeType_];
    [self addSubview:address_];
    [self addSubview:call_];
    [self addSubview:mapIt_];
  }
  return self;
}

- (void)call {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", store_.phone]]];
}

- (void)mapIt {
  NSString *mapUrl_ = [NSString stringWithFormat:@"maps://maps.google.com/maps?a=1&saddr=%f,%f&daddr=%f,%f&z=17", store_.userLatitude, store_.userLongitude, store_.latitude, store_.longitude];

  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mapUrl_]];
}

# pragma mark Private Methods

- (void)dealloc {
  [store_ release];  
  [super dealloc];
}

@end