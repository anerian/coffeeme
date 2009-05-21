//
//  CMStoresController.h
//  CoffeeMe
//
//  Created by min on 5/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMModalView.h"
#import "CMDetailController.h"
#import "CMBaseController.h"
#import "CMLocation.h"


@interface CMStoresController : CMBaseController<UITableViewDelegate, UITableViewDataSource, TTTabDelegate> {
    UITableView *tableView_;
    NSArray *stores_;

    BOOL isLoading_;
    BOOL isDirty_;
    
    UIBarButtonItem *spinner_;
    UIBarButtonItem *refresh_;
    
    CMStoreType storeFilter_;
    
    TTActivityLabel* statusView_;
}

@property(nonatomic, retain) UITableView *tableView;

- (id)initWithStyle:(UITableViewStyle)style;
- (void)refresh;
- (void)showAlert;
- (void)hideAlert;

@end