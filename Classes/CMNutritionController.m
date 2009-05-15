//
//  CMNutritionController.m
//  CoffeeMe
//
//  Created by min on 5/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMNutritionController.h"


@implementation CMNutritionController

- (id)initWithDrinkName:(NSString *)drinkName {
    if (self = [super initWithNibName:@"Nutrition" bundle:nil]) {
        drinkName_ = [drinkName retain];
        drinks_ = [[CMDrink forName:drinkName] retain];
        sizes_ = [[CMDrink sizesForName:drinkName_] retain];
        milkTypes_ = [[CMDrink milkTypesForName:drinkName_] retain];
        
        
    }
    return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    nutritionView_ = [[[CMNutritionView alloc] initWithFrame:self.view.bounds] autorelease];
    nutritionView_.drink = [drinks_ lastObject];
    self.view = nutritionView_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // self.view.backgroundColor = HexToUIColor(0xdddddd);
    // 
    // milkPicker_ = [[[UIPickerView alloc] initWithFrame:CGRectMake(0,0,160,50)] retain];
    // milkPicker_.delegate = self;
    // milkPicker_.dataSource = self;
    
    // [self.view addSubview:milkPicker_];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == CMNutritionPickerTagSize) {
        return [sizes_ count];
    }
    return [milkTypes_ count];
}

@end