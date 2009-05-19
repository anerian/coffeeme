//
//  CMStoreCell.h
//  CoffeeMe
//
//  Created by min on 5/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMStore.h"


@interface CMStoreCell : UITableViewCell {
  UIImageView *icon_;
  UILabel *name_;
  UILabel *address_;
  UILabel *distance_;
}

- (void)update:(CMStore *)store;

@end