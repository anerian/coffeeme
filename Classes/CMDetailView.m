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
    self.backgroundColor = HexToUIColor(0xeddabe);
    
    UIImageView *icon_ = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 49, 62)];
    icon_.image = [UIImage imageNamed:[NSString stringWithFormat:@"cup-%d.png", store.type]];
    
    TTLabel *storeType_ = [[TTLabel alloc] initWithFrame:CGRectMake(80,10,220,24)];
    storeType_.backgroundColor = [UIColor clearColor];
    storeType_.style = TTSTYLE(titleLabel);
    storeType_.text = CMShopType(store.type);
    
    UILabel *address_ = CMLabelMake(CGRectMake(80,34,220,40), 16, NO);
    address_.numberOfLines = 2;
    address_.text = [store address];
    
    TTButton *call_ = [TTButton buttonWithStyle:@"embossedButton:" title:@"Call"];
    call_.frame = CGRectMake(20,80,135,50);
    [call_ addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    [call_ setTitle:@"Call (N/A)" forState:UIControlStateDisabled];
    
    if (!store.phone || TTIsEmptyString(store.phone)) {
      call_.enabled = NO;  
    }

    TTButton *mapIt_ = [TTButton buttonWithStyle:@"embossedButton:" title:@"Get directions"];
    mapIt_.frame = CGRectMake(165,80,135,50);
    [mapIt_ addTarget:self action:@selector(mapIt) forControlEvents:UIControlEventTouchUpInside];
    
    TTImageView *map_ = [[TTImageView alloc] initWithFrame:CGRectMake(20, 140, 280, 200)];
    map_.backgroundColor = [UIColor clearColor];
    
    UIImageView *mapMask_ = [[UIImageView alloc] initWithFrame:map_.frame];
    mapMask_.image = [[UIImage imageNamed:@"bg-map-mask.png"] stretchableImageWithLeftCapWidth:40 topCapHeight:40];
    
    [self addSubview:icon_];
    [self addSubview:storeType_];
    [self addSubview:address_];
    [self addSubview:call_];
    [self addSubview:mapIt_];
    [self addSubview:mapMask_];
    
    [icon_ release];
    [storeType_ release];
    [mapMask_ release];
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