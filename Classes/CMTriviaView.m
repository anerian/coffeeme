//
//  CMTriviaView.m
//  CoffeeMe
//
//  Created by Todd Fisher on 5/10/09.
//  Copyright 2009 Anerian LLC. All rights reserved.
//

#import "CMTriviaView.h"
#import "CMTrivia.h"

@implementation CMTriviaView

@synthesize label = label_;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;

        self.contentMode = UIViewContentModeCenter;
        // Initialization code
        self.image = [UIImage imageNamed:@"trivia-bg.png"];

        // center the label over the coffee cup
        CGRect rect = CGRectMake(60.0f, 130.0f, 180.0f, 130.0f);

        self.label = [[[UILabel alloc] initWithFrame:rect] autorelease];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor whiteColor];
        self.label.numberOfLines = 10;
        self.label.adjustsFontSizeToFitWidth = YES;
        self.label.lineBreakMode = UILineBreakModeWordWrap;

        [self updateTrivia];

        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [self addSubview:self.label];
    }
    return self;
}

-(void) updateTrivia {
    NSString *str = [CMTrivia randomTrivia].fact;
    [self.label setText: str ];
    [self.label setTextAlignment:UITextAlignmentCenter];
    [str release];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touches began count %d, %@", [touches count], touches);
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touches moved count %d, %@", [touches count], touches);
    [self updateTrivia];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)dealloc {
    [super dealloc];
}

@end
