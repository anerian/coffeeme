//
//  CoffeeMeAppDelegate.h
//  CoffeeMe
//
//  Created by min on 5/6/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCLController.h"

@interface CoffeeMeAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, MyCLControllerDelegate> {
    UIWindow *window_;
    UITabBarController *tabBarController_;
    
    MyCLController *location_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (void)locationUpdate:(CLLocation *)location; 
- (void)locationError:(NSError *)error;

@end