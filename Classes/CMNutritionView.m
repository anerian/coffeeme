//
//  CMNutritionView.m
//  CoffeeMe
//
//  Created by min on 5/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMNutritionView.h"
#import "math.h"

@interface CMNutritionView(PrivateMethods)

- (void)createMetrics;
- (void)setNutritionValue:(int)value tag:(NSUInteger)tag total:(float)total unit:(NSString *)unit;

@end

@implementation CMNutritionView

@synthesize drink = drink_;

- (UILabel *)createTitleLabel:(CGRect)frame withText:(NSString *)text isBold:(BOOL)bold {
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    label.font = bold ? [UIFont boldSystemFontOfSize:16] : [UIFont systemFontOfSize:16];
    label.backgroundColor = [UIColor clearColor];
    label.shadowOffset = CGSizeMake(0,1);
    label.shadowColor = [UIColor whiteColor];
    label.textColor = [UIColor blackColor];
    label.text = text;
    return label;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        metrics_ = [[[UIView alloc] initWithFrame:CGRectMake(0,100,frame.size.width,frame.size.height-100)] retain];
        [self addSubview:metrics_];
        [self createMetrics];
    }
    return self;
}

- (void)createMetrics {
    NSArray *titles = [NSArray arrayWithObjects:
        @"Total Fat",
        @"Saturated Fat", 
        @"Cholesterol", 
        @"Sodium", 
        @"Total Carbohydrate",
        @"Dietary Fiber", 
        @"Sugars", 
        @"Protein", 
    nil];
    
    NSArray *indentedTitles = [NSArray arrayWithObjects:@"Saturated Fat", @"Dietary Fiber", @"Sugars", nil];
    
    for (int i = 0; i < [titles count]; i++) {
        id title = [titles objectAtIndex:i];
        
        BOOL subtitle = [indentedTitles containsObject:title];
        float indent = subtitle ? 40 : 20;
        UILabel *label = [self createTitleLabel:CGRectMake(indent,i*24,200,20) withText:title isBold:!(subtitle)];
        [label sizeToFit];
        UILabel *value = [self createTitleLabel:CGRectMake(10 + indent + label.frame.size.width,label.frame.origin.y,200,20) withText:@"" isBold:NO];
        value.tag = i+100;
        UILabel *percent = [self createTitleLabel:CGRectMake(200,label.frame.origin.y,100,20) withText:@"" isBold:NO];
        percent.textAlignment = UITextAlignmentRight;
        percent.tag = i+200;
        
        [metrics_ addSubview:label];
        [metrics_ addSubview:value];
        [metrics_ addSubview:percent];
    }
}

- (void)setNutritionValue:(int)value tag:(NSUInteger)tag total:(float)total unit:(NSString *)unit {
    NSString *grams = [NSString stringWithFormat:@"%d%@", value, unit];
    
    int p = (value/total)*100;
    NSString *percent = total > 0 ? [NSString stringWithFormat:@"%d%", p] : nil;

    ((UILabel *)[metrics_ viewWithTag:tag+100]).text = grams;
    
    UILabel *lblPercent = ((UILabel *)[metrics_ viewWithTag:tag+200]);
    if (percent) {
        lblPercent.text = percent;
        lblPercent.hidden = NO;
    } else {
        lblPercent.hidden = YES;
    }
}

- (void)refreshView {
    [self setNutritionValue:drink_.nutrition.totalFat tag:0 total:65.0 unit:@"g"];
    [self setNutritionValue:drink_.nutrition.saturatedFat tag:1 total:20.0 unit:@"g"];
    [self setNutritionValue:drink_.nutrition.cholesterol tag:2 total:300.0 unit:@"mg"];
    [self setNutritionValue:drink_.nutrition.sodium tag:3 total:2400.0 unit:@"mg"];
    [self setNutritionValue:drink_.nutrition.totalCarbohydrates tag:4 total:300.0 unit:@"g"];
    [self setNutritionValue:drink_.nutrition.fiber tag:5 total:25.0 unit:@"g"];
    [self setNutritionValue:drink_.nutrition.sugars tag:6 total:-1 unit:@"g"];
    [self setNutritionValue:drink_.nutrition.protein tag:7 total:-1 unit:@"g"];
}

- (void)setDrink:(CMDrink *)drink {
    [drink_ release];
    [drink retain];
    drink_ = drink;
    
    [self refreshView];
}

- (void)dealloc {
    [metrics_ release];
    [super dealloc];
}

@end