//
//  CoffeeMeAppDelegate.m
//  CoffeeMe
//
//  Created by min on 5/6/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "CoffeeMeAppDelegate.h"
#import "CMStore.h"


@implementation CoffeeMeAppDelegate

@synthesize window;
@synthesize tabBarController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    [CMStore establishConnection];
	location_ = [[MyCLController alloc] init];
	location_.delegate = self;
	[location_.locationManager startUpdatingLocation];
    
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
}


/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/

- (void)locationUpdate:(CLLocation *)location {
    NSLog(@"location updated: %f %f", location.coordinate.latitude, location.coordinate.longitude);
    NSLog(@"coffee: %@", [CMStore nearby:location.coordinate]);
}

- (void)locationError:(NSError *)error {
    
}

- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

