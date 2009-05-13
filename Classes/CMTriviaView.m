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

        // Initialization code
        self.image = [UIImage imageNamed:@"trivia-bg.png"];

        // center the label over the coffee cup
        CGRect rect = CGRectMake(55.0f, 90.0f, 200.0f, 190.0f);

        self.label = [[[UILabel alloc] initWithFrame:rect] autorelease];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor whiteColor];
        self.label.numberOfLines = 0;
        CGSize offset;
        offset.width = 1;
        offset.height = 1;
        self.label.shadowOffset = offset;
        self.label.shadowColor = [UIColor blackColor];
        //self.label.adjustsFontSizeToFitWidth = YES;
        self.label.font = [UIFont systemFontOfSize:15];
        self.label.lineBreakMode = UILineBreakModeWordWrap;
        [self.label setTextAlignment:UITextAlignmentCenter];

        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [self addSubview:self.label];
    }
    return self;
}

-(void) updateTrivia {
    NSString *str = [CMTrivia randomTrivia].fact;
    [self.label setText: str ];
    [str release];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self updateTrivia];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)dealloc {
    [super dealloc];
}

@end
