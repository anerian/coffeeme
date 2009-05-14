//
//  CMDrinksDataSource.h
//  CoffeeMe
//
//  Created by min on 5/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMDrink.h"


@interface CMDrinksDataSource : TTSectionedDataSource {
    NSArray *drinks_;
}

- (id)initWithDrinks:(NSArray*)drinks;
- (void)rebuildItems;

@end
