//
//  CMNutritionView.m
//  CoffeeMe
//
//  Created by min on 5/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMNutritionView.h"
#import "math.h"

@implementation CMNutritionUnderlinedView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        thickness_ = 1;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    const CGFloat *clr = CGColorGetComponents([UIColor whiteColor].CGColor);
	
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, thickness_);
    CGContextSetRGBFillColor(context, clr[0], clr[1], clr[2], clr[3]);
    CGContextSetRGBStrokeColor(context, 0.25, 0.25, 0.25, 0.8);
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);
}

@end

@implementation CMMetricView

@end

@interface CMNutritionValueView(PrivateMethods)

- (UILabel *)createLabel:(CGRect)frame withText:(NSString *)text isBold:(BOOL)bold;

@end

@implementation CMNutritionValueView

@synthesize title = title_, value = value_, daily = daily_;
    
- (id)initWithFrame:(CGRect)frame withOptions:(NSDictionary *)options {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];

        NSString *titleText;
        NSString *unitText;
        float indent;
        
        if (options == nil) {
            total_ = -1;
            subvalue_ = NO;
            indent = 10;
            titleText = @"Calories";
            unitText = @"";
            thickness_ = 10;
        } else {
            total_ = [[options objectForKey:@"total"] floatValue];
            subvalue_ = [[options objectForKey:@"isSubtitle"] boolValue];
            titleText = [options objectForKey:@"title"];
            unitText = [options objectForKey:@"unit"];
            indent = subvalue_ ? 30 : 10;
        }

        title_ = [[self createLabel:CGRectMake(indent,11,200,20) withText:titleText isBold:!(subvalue_)] retain];
        [title_ sizeToFit];
        
        value_ = [[self createLabel:CGRectMake(5 + indent + title_.frame.size.width,11,200,20) withText:@"" isBold:NO] retain];
        
        daily_ = [[self createLabel:CGRectMake(170,11,100,20) withText:@"" isBold:NO] retain];
        daily_.textAlignment = UITextAlignmentRight;
        if (total_ < 0)
            daily_.hidden = YES;
        
        unit_ = [unitText copy];
        
        [self addSubview:title_];
        [self addSubview:value_];
        [self addSubview:daily_];
    }
    return self;
}

- (void)updateValue:(NSUInteger)value {
    int daily = round(value/total_* 100);
    value_.text = [NSString stringWithFormat:@"%d%@", value, unit_];
    daily_.text = [NSString stringWithFormat:@"%d%%", daily];
}

- (UILabel *)createLabel:(CGRect)frame withText:(NSString *)text isBold:(BOOL)bold {
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    label.font = bold ? [UIFont boldSystemFontOfSize:16] : [UIFont systemFontOfSize:16];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.text = text;
    return label;
}

- (void)dealloc {
    [super dealloc];
}

@end

@interface CMNutritionView(PrivateMethods)

- (void)createMetrics;
- (void)setNutritionValue:(int)value tag:(NSUInteger)tag total:(float)total unit:(NSString *)unit;

@end

@implementation CMNutritionView

@synthesize drink = drink_;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {        
        self.backgroundColor = [UIColor blackColor];

        drinkName_ = [CMLabelMake(CGRectMake(20,20,280,40), 16) retain];
        drinkName_.numberOfLines = 2;
        drinkName_.textColor = [UIColor whiteColor];
        
        metrics_ = [[[CMMetricView alloc] initWithFrame:CGRectMake(20,100,280,267)] retain];
        metrics_.contentSize = CGSizeMake(280,473); 
        metrics_.showsVerticalScrollIndicator = NO;
        metrics_.alwaysBounceVertical = YES;
        metrics_.backgroundColor = [UIColor clearColor];
        
        UIImageView *bg = [[[UIImageView alloc] initWithFrame:metrics_.frame] autorelease];
        bg.image = [UIImage imageNamed:@"bg-nutrition.png"];
        
        UIImageView *bgMetrics = [[[UIImageView alloc] initWithFrame:metrics_.frame] autorelease];
        bgMetrics.image = [[UIImage imageNamed:@"bg-metrics.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
        bgMetrics.backgroundColor = [UIColor clearColor];
        
        [self addSubview:drinkName_];
        [self addSubview:bg];
        [self addSubview:metrics_];
        [self addSubview:bgMetrics];
        [self createMetrics];
    }
    return self;
}

- (void)createMetrics {
    NSArray *nutrition = [[CMAppConfig instance].plist objectForKey:@"nutrition"];
    
    CMNutritionUnderlinedView *caloriesView = [[[CMNutritionUnderlinedView alloc] initWithFrame:CGRectMake(0,0,280,43)] autorelease];

    UILabel *lblServing = CMLabelMake(CGRectMake(10,0,270,43), 16);
    lblServing.textColor = [UIColor whiteColor];
    lblServing.text = @"Amount Per Serving";
    [caloriesView addSubview:lblServing];
    [metrics_ addSubview:caloriesView];
    
    CMNutritionUnderlinedView *dailyView = [[[CMNutritionUnderlinedView alloc] initWithFrame:CGRectMake(0,86,280,43)] autorelease];
    UILabel *lblDaily = CMLabelMake(CGRectMake(0,0,270,43), 16);
    lblDaily.textColor = [UIColor whiteColor];
    lblDaily.text = @"% Daily Value";
    lblDaily.textAlignment = UITextAlignmentRight;
    [dailyView addSubview:lblDaily];
    [metrics_ addSubview:dailyView];
    
    calories_= [[[CMNutritionValueView alloc] initWithFrame:CGRectMake(0,43,280,43) withOptions:nil] retain];
    [metrics_ addSubview:calories_];
    
    for (int i = 0; i < [nutrition count]; i++) {
        CMNutritionValueView *view = [[CMNutritionValueView alloc] initWithFrame:CGRectMake(0,129+i*43,280,43) withOptions:[nutrition objectAtIndex:i]];
        view.tag = 100 + i;
        
        [metrics_ addSubview:view];
        [view release];
    }
}

- (void)setNutritionValue:(int)value tag:(NSUInteger)tag {
    [((CMNutritionValueView *)[metrics_ viewWithTag:tag+100]) updateValue:value];
}

- (void)refreshView {
    [self setNutritionValue:drink_.nutrition.totalFat tag:0];
    [self setNutritionValue:drink_.nutrition.saturatedFat tag:1];
    [self setNutritionValue:drink_.nutrition.cholesterol tag:2];
    [self setNutritionValue:drink_.nutrition.sodium tag:3];
    [self setNutritionValue:drink_.nutrition.totalCarbohydrates tag:4];
    [self setNutritionValue:drink_.nutrition.fiber tag:5];
    [self setNutritionValue:drink_.nutrition.sugars tag:6];
    [self setNutritionValue:drink_.nutrition.protein tag:7];
    
    calories_.value.text = [NSString stringWithFormat:@"%d", drink_.nutrition.calories];
}

- (void)setDrink:(CMDrink *)drink {
    [drink_ release];
    [drink retain];
    drink_ = drink;
    
    drinkName_.text = [NSString stringWithFormat:@"%@ %@ %@", CMSizeType(drink_.size), CMMilkType(drink_.milk), drink_.name];
    
    [self refreshView];
}

- (void)dealloc {
    [metrics_ release];
    [super dealloc];
}

@end