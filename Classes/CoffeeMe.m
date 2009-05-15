//
//  CoffeeMe.m
//  CoffeeMe
//
//  Created by min on 5/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//



#import "CoffeeMe.h"

NSString* CMSizeType(NSUInteger type) {
    NSString *size;
    switch(type) {
        case 0: size = @"Tall"; break;
        case 1: size = @"Grande"; break;
        case 2: size = @"Venti"; break;
        case 3: size = @"Solo"; break;
        case 4: size = @"Doppio"; break;
        case 5: size = @"Short"; break;
    }
  
    return size;
}

NSString* CMMilkType(NSUInteger type) {
    NSString *milk;
    switch(type) {
        case 0: milk = @"Nonfat"; break;
        case 1: milk = @"Whole"; break;
        case 2: milk = @"2%"; break;
        case 3: milk = @"Soy (US)"; break;
        case 4: milk = @"Soy (CD)"; break;
    }
  
    return milk;
}
	