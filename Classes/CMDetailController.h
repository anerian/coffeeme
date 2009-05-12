//
//  CMDetailController.h
//  CoffeeMe
//
//  Created by min on 5/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMStore.h"


@interface CMDetailController : UIViewController {
    CMStore *store_;
}

- (id)initWithStore:(CMStore *)store;

@end