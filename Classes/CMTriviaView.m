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
        self.contentMode = UIViewContentModeCenter;
        // Initialization code
        NSLog(@"Loading View");
        self.label = [[[UILabel alloc] initWithFrame:frame] autorelease];
        NSLog(@"getting random trivia");
        NSString *str = [CMTrivia randomTrivia].fact;
        NSLog(@"display random trivia: %@", str);
        [self.label setText: str ];
        [self.label setTextAlignment:UITextAlignmentCenter];
        [self addSubview:self.label];
        self.backgroundColor = [UIColor blackColor];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)dealloc {
    [super dealloc];
}

@end
