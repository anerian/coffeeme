//
//  CMAppConfig.h
//  CoffeeMe
//
//  Created by min on 5/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CMAppConfig : NSObject {
    NSDictionary *plist_;
}

@property (nonatomic, readonly) NSDictionary *plist;

+ (CMAppConfig *)instance;

@end