//
//  CMTriviaController.m
//  CoffeeMe
//
//  Created by min on 5/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMTriviaController.h"
#import "CMTriviaView.h"

@implementation CMTriviaController

- (void)loadView {
    self.view = [[CMTriviaView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.supportsShake = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)userDidShake {
    [self refresh];
}

- (void)refresh {
    [((CMTriviaView*)self.view) updateTrivia];
}

- (void)dealloc {
    [super dealloc];
}

@end