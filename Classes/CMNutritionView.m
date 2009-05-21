//
//  CMNutritionView.m
//  CoffeeMe
//
//  Created by min on 5/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMNutritionView.h"
#import "math.h"

#define CMNutritionTextColor HexToUIColor(0x351f0f)

@implementation CMNutritionUnderlinedView

@synthesize thickness = thickness_;

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor clearColor];
    self.thickness = 1;
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  UIColor *color = HexToUIColor(0x351f0f);
  const CGFloat *clr = CGColorGetComponents(color.CGColor);
	
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetLineWidth(context, thickness_);
  CGContextSetRGBFillColor(context, clr[0], clr[1], clr[2], clr[3]);
  CGContextSetRGBStrokeColor(context, clr[0], clr[1], clr[2], clr[3]);
  CGContextMoveToPoint(context, 0, rect.size.height);
  CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
  CGContextStrokePath(context);
}

@end

@implementation CMNutritionHeaderView

@synthesize servingSize = servingSize_;

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    UILabel *nutritionInfo_ = CMLabelMake(CGRectMake(0,0,280,16), 20, YES);
    nutritionInfo_.text = @"Nutrition Info";
    nutritionInfo_.textColor = CMNutritionTextColor;
    
    UILabel *servingLabel_ = CMLabelMake(CGRectMake(0,20,280,16), 12, NO);
    servingLabel_.text = @"Serving Size";
    nutritionInfo_.textColor = CMNutritionTextColor;
    
    self.thickness = 20;
    
    [self addSubview:nutritionInfo_];
    [self addSubview:servingLabel_];
  }
  return self;
}

@end

@interface CMNutritionValueView(PrivateMethods)

- (UILabel *)createLabel:(CGRect)frame withText:(NSString *)text isBold:(BOOL)bold;

@end

@implementation CMNutritionValueView

@synthesize title = title_, value = value_, daily = daily_;
    
- (id)initWithFrame:(CGRect)frame withOptions:(NSDictionary *)options {
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor clearColor];
    self.thickness = 10;

    NSString *titleText_ = @"Calories";
    NSString *unitText_ = @"";
    float indent_ = 10;
    
    total_    = -1;
    subvalue_ = NO;
    indent_   = 10;

    if (options) {
      self.thickness = 1;
      total_     = [[options objectForKey:@"total"] floatValue];
      subvalue_  = [[options objectForKey:@"isSubtitle"] boolValue];
      titleText_ = [options objectForKey:@"title"];
      unitText_  = [options objectForKey:@"unit"];
      indent_    = subvalue_ ? 30 : 10;
    }

    title_ = [[self createLabel:CGRectMake(indent_,5,200,20) withText:titleText_ isBold:!(subvalue_)] retain];
    [title_ sizeToFit];
        
    value_ = [[self createLabel:CGRectMake(5 + indent_ + title_.frame.size.width,5,200,20) withText:@"" isBold:NO] retain];
        
    daily_ = [[self createLabel:CGRectMake(170,5,100,20) withText:@"" isBold:NO] retain];
    daily_.textAlignment = UITextAlignmentRight;
    
    if (total_ < 0)
      daily_.hidden = YES;
        
    unit_ = [unitText_ copy];
        
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
  label.textColor = CMNutritionTextColor;
  label.text = text;
  return label;
}

- (void)dealloc {
  [title_ release];
  [value_ release];
  [daily_ release];
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
    self.backgroundColor = [UIColor whiteColor];

    drinkName_ = [CMLabelMake(CGRectMake(20,10,280,48), 18, NO) retain];
    drinkName_.numberOfLines = 2;
    drinkName_.textColor = CMNutritionTextColor;

    metrics_ = [[[UIScrollView alloc] initWithFrame:CGRectMake(20,120,280,267)] retain];
    metrics_.contentSize = CGSizeMake(280,330); 
    metrics_.showsVerticalScrollIndicator = NO;
    metrics_.alwaysBounceVertical = YES;
    metrics_.backgroundColor = [UIColor clearColor];
    
    header_ = [[[CMNutritionHeaderView alloc] initWithFrame:CGRectMake(20,60,280,60)] autorelease];
    
    [self addSubview:drinkName_];
    [self addSubview:metrics_];
    [self createMetrics];
    [self addSubview:header_];
  }
  return self;
}

- (void)createMetrics {
  NSArray *nutrition = [[CMAppConfig instance].plist objectForKey:@"nutrition"];
  
  CMNutritionUnderlinedView *caloriesView = [[[CMNutritionUnderlinedView alloc] initWithFrame:CGRectMake(0,0,280,30)] autorelease];

  UILabel *lblServing = CMLabelMake(CGRectMake(10,0,270,30), 16, YES);
  lblServing.textColor = CMNutritionTextColor;
  lblServing.text = @"Amount Per Serving";
  [caloriesView addSubview:lblServing];
  [metrics_ addSubview:caloriesView];
  
  CMNutritionUnderlinedView *dailyView = [[[CMNutritionUnderlinedView alloc] initWithFrame:CGRectMake(0,60,280,30)] autorelease];
  UILabel *lblDaily = CMLabelMake(CGRectMake(0,0,270,30), 16, YES);
  lblDaily.textColor = CMNutritionTextColor;
  lblDaily.text = @"% Daily Value";
  lblDaily.textAlignment = UITextAlignmentRight;
  [dailyView addSubview:lblDaily];
  [metrics_ addSubview:dailyView];
  
  calories_= [[[CMNutritionValueView alloc] initWithFrame:CGRectMake(0,30,280,30) withOptions:nil] retain];
  [metrics_ addSubview:calories_];
    
  for (int i = 0; i < [nutrition count]; i++) {
    CMNutritionValueView *view = [[CMNutritionValueView alloc] initWithFrame:CGRectMake(0,90+i*30,280,30) withOptions:[nutrition objectAtIndex:i]];
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
  [drink_ release];
  [metrics_ release];
  [calories_ release];
  [drinkName_ release];
  [super dealloc];
}

@end