//
//  CMTrivia.h
//  CoffeeMe
//
//  Created by min on 5/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMModel.h"

@interface CMTrivia : CMModel<CMModel> {
  NSString *fact_;
}

@property (nonatomic, retain) NSString *fact;

+ (CMTrivia *)randomTrivia;
+ (NSArray *)allByRandomOrder;

@end