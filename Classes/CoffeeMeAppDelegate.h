//
//  CoffeeMeAppDelegate.h
//  CoffeeMe
//
//  Created by min on 5/6/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoffeeMeAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window_;
    UITabBarController *tabBarController_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end