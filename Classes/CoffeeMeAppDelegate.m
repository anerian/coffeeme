//
//  CoffeeMeAppDelegate.m
//  CoffeeMe
//
//  Created by min on 5/6/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "CoffeeMeAppDelegate.h"
#import "CMStore.h"
#import "CMStoresController.h"
#import "CMNutritionController.h"
#import "CMTriviaController.h"


@implementation CoffeeMeAppDelegate

@synthesize window = window_;

- (UINavigationController *)createNavItem:(UIViewController *)viewController withName:(NSString *)name {
    viewController.title = name;
    viewController.tabBarItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"tab%@.png", name]];
    
    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
    navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    navigationController.navigationBar.tintColor = HexToUIColor(0x56523c);
    
    [viewController release];
    
    return navigationController;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    [CMStore establishConnection];
	
	// setup tab bar controllers
	NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:3];
    
    tabBarController_ = [[UITabBarController alloc] init];
    
    [viewControllers addObject:[self createNavItem:[[CMStoresController alloc] initWithStyle:UITableViewStylePlain] withName:@"coffeeme"]];
    [viewControllers addObject:[self createNavItem:[[CMNutritionController alloc] init] withName:@"Nutrition"]];
    [viewControllers addObject:[self createNavItem:[[CMTriviaController alloc] init] withName:@"Trivia"]];
    
    tabBarController_.viewControllers = viewControllers;
    
    [window_ addSubview:tabBarController_.view];
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

- (void)dealloc {
    [tabBarController_ release];
    [window_ release];
    [super dealloc];
}

@end