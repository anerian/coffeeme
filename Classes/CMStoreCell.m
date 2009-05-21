//
//  CMStoreCell.m
//  CoffeeMe
//
//  Created by min on 5/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMStoreCell.h"


@interface CMStoreCell(Private)

- (UILabel *)labelForFrame:(CGRect)frame withText:(NSString *)text withFontSize:(double)fontSize;

@end

@implementation CMStoreCell
  
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)identifier {
  if (self = [super initWithFrame:frame reuseIdentifier:identifier]) {
    self.backgroundColor = [UIColor clearColor];
    
    icon_ = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 49, 62)] retain];
    
    name_ = [[self labelForFrame:CGRectMake(70, 10, 250, 20) withText:@"" withFontSize:14] retain];
    name_.textColor = HexToUIColor(0x25190c);
    
    address_ = [[self labelForFrame:CGRectMake(70, 30, 250, 40) withText:@"" withFontSize:14] retain];
    address_.font = [UIFont systemFontOfSize:14];
    address_.numberOfLines = 2;
    
    distance_ = [[self labelForFrame:CGRectMake(70, 10, 230, 20) withText:@"" withFontSize:12] retain];
    distance_.textAlignment = UITextAlignmentRight;
    distance_.font = [UIFont systemFontOfSize:12];
    
    [self.contentView addSubview:icon_];
    [self.contentView addSubview:name_];
    [self.contentView addSubview:address_];
    [self.contentView addSubview:distance_];
  }
  return self;
}

- (void)update:(CMStore *)store {
  icon_.image = [UIImage imageNamed:[NSString stringWithFormat:@"cup-%d.png", store.type]];
  name_.text = CMShopType([store type]);
  address_.text = [store address];
  distance_.text = [NSString stringWithFormat:@"%@ %@", [store formattedDistance], [store bearing]];
}

- (UILabel *)labelForFrame:(CGRect)frame withText:(NSString *)text withFontSize:(double)fontSize {
  UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
  
  label.text = text;
	label.font = [UIFont boldSystemFontOfSize:fontSize];
  label.backgroundColor = [UIColor clearColor];
  label.shadowOffset = CGSizeMake(0,1);
  label.shadowColor = [UIColor whiteColor];
  label.textColor = [UIColor blackColor];
  return label;
}

- (void)dealloc {
  [icon_ release];
  [name_ release];
  [address_ release];
  [distance_ release];
  [super dealloc];
}
  
@end