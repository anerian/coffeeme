//
//  CMNutritionController.m
//  CoffeeMe
//
//  Created by min on 5/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMNutritionController.h"


@implementation CMNutritionController

- (void)determineCurrentDrink {
    for (CMDrink *drink in drinks_) if (drink.milk == 2 && drink.size == 1) currentDrink_ = [drink retain];
    
    if (!currentDrink_) currentDrink_ = [drinks_ objectAtIndex:0];
    
    NSLog(@"current drink: %@", currentDrink_);
}

- (id)initWithDrinkName:(NSString *)drinkName {
    if (self = [super initWithNibName:@"Nutrition" bundle:nil]) {
        self.title = @"Nutrition Facts";
        drinkName_ = [drinkName retain];
        hasMultiple_ = NO;
        
        id drinks = [CMDrink forName:drinkName];
        
        if ([drinks isKindOfClass:[NSArray class]]) {
            hasMultiple_ = YES;
            
            drinks_ = [drinks retain];
            sizes_ = [[CMDrink sizesForName:drinkName_] retain];
            milkTypes_ = [[CMDrink milkTypesForName:drinkName_] retain];
            
            [self determineCurrentDrink];
        } else {
            currentDrink_ = [drinks retain];
        }
        
        pickerEnabled_ = YES;
    }
    return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    self.navigationController.navigationBar.tintColor = HexToUIColor(0x372010);
    
    nutritionView_ = [[[CMNutritionView alloc] initWithFrame:self.view.bounds] autorelease];
    nutritionView_.drink = currentDrink_;
    self.view = nutritionView_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (hasMultiple_) {

        picker_ = [[[UIPickerView alloc] initWithFrame:CGRectMake(0,self.view.bounds.size.height,320,200)] autorelease];
        picker_.showsSelectionIndicator = YES;
        picker_.delegate = self;
        picker_.dataSource = self;
        [picker_ selectRow:currentDrink_.milk inComponent:0 animated:NO];
        [picker_ selectRow:currentDrink_.size inComponent:1 animated:NO];
        
        
        [self.view addSubview:picker_];
        self.navigationItem.rightBarButtonItem = 
            [[[UIBarButtonItem alloc] initWithTitle:@"Size/Milk" 
                                              style:UIBarButtonItemStyleBordered
                                             target:self 
                                            action:@selector(settings)] autorelease];
    }
    
}

- (void)settings {
    if (!pickerEnabled_) return;
    pickerEnabled_ = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(pickerDidAppear)];
    picker_.frame = CGRectMake(0,self.view.bounds.size.height - picker_.bounds.size.height,320,picker_.bounds.size.height);
    [UIView commitAnimations];
}

- (void)pickerDidAppear {
    pickerEnabled_ = YES;
    
    self.navigationItem.rightBarButtonItem = 
        [[[UIBarButtonItem alloc] initWithTitle:@"Done" 
                                          style:UIBarButtonItemStyleDone
                                         target:self 
                                        action:@selector(pickerWillDissappear)] autorelease];
}

- (void)pickerWillDissappear {
    if (!pickerEnabled_) return;
    pickerEnabled_ = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(pickerDidDisappear)];
    picker_.frame = CGRectMake(0,self.view.bounds.size.height,320,picker_.bounds.size.height);
    [UIView commitAnimations];
}

- (void)pickerDidDisappear {
    pickerEnabled_ = YES;
    
    self.navigationItem.rightBarButtonItem = 
        [[[UIBarButtonItem alloc] initWithTitle:@"Size/Milk" 
                                          style:UIBarButtonItemStyleBordered
                                         target:self 
                                        action:@selector(settings)] autorelease];
    
    for (CMDrink *drink in drinks_) {
        if (drink.milk == [[milkTypes_ objectAtIndex:[picker_ selectedRowInComponent:0]] intValue] && 
        drink.size == [[sizes_ objectAtIndex:[picker_ selectedRowInComponent:1]] intValue]) {
            NSLog(@"found");
            nutritionView_.drink = drink;
        }
    }
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

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == CMNutritionPickerTagSize) {
        return CMSizeType([[sizes_ objectAtIndex:row] integerValue]);
    }
    return CMMilkType([[milkTypes_ objectAtIndex:row] integerValue]);
}

@end
