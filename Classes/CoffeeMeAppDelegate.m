//
//  CoffeeMeAppDelegate.m
//  CoffeeMe
//
//  Created by min on 5/6/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "CoffeeMeAppDelegate.h"
#import "CMStore.h"
#import "CMDrink.h"
#import "CMDrinksController.h"
#import "CMStoresController.h"
#import "CMStoreTypesController.h"
#import "CMTriviaController.h"
#import "CMInfoController.h"
#import "CMStyleSheet.h"


@implementation CoffeeMeAppDelegate

@synthesize window = window_;

- (UINavigationController *)createNavItem:(UIViewController *)viewController withName:(NSString *)name {
  viewController.title = name;
  viewController.tabBarItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"tab%@.png", name]];
    
  UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
  navigationController.navigationBar.tintColor = HexToUIColor(0x372010);
  
  // decrease reference counter, adding to navigtion controller increments it
  [viewController release];
    
  return navigationController;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
  [TTStyleSheet setGlobalStyleSheet:[[[CMStyleSheet alloc] init] autorelease]];
  
  [CMModel establishConnection];
  
  TTAppMap* appMap = [TTAppMap sharedMap];

  [appMap addURL:@"cm://drinks/(initWithStoreType:)" create:[CMDrinksController class]];
	
	// setup tab bar controllers
	NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:3];
    
  tabBarController_ = [[UITabBarController alloc] init];
    
  [viewControllers addObject:[self createNavItem:[[CMStoresController alloc] initWithStyle:UITableViewStylePlain] withName:@"Coffeeme"]];
  [viewControllers addObject:[self createNavItem:[[CMStoreTypesController alloc] init] withName:@"Nutrition"]];
  [viewControllers addObject:[self createNavItem:[[CMTriviaController alloc] init] withName:@"Trivia"]];
  [viewControllers addObject:[self createNavItem:[[CMInfoController alloc] init] withName:@"Anerian"]];
    
  tabBarController_.viewControllers = viewControllers;
    
  [window_ addSubview:tabBarController_.view];
    
  splash_ = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
  splash_.image = [UIImage imageNamed:@"Default.png"];
  [window_ addSubview:splash_];
  [window_ bringSubviewToFront:splash_];
  
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:1];
  [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:window_ cache:YES];
  [UIView setAnimationDelegate:self]; 
  [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
  splash_.alpha = 0.0;
  splash_.frame = CGRectMake(-60, -60, 440, 600);
  [UIView commitAnimations];
}

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
  [splash_ removeFromSuperview];
  [splash_ release];
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