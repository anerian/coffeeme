//
//  CMAppConfig.m
//  CoffeeMe
//
//  Created by min on 5/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMAppConfig.h"


@implementation CMAppConfig

static CMAppConfig *instance;

@synthesize plist = plist_;

+ (CMAppConfig *)instance {
    @synchronized(self) {
        if (!instance)
            [[CMAppConfig alloc] init];              
    }
    return instance;
}

+ (id)objectForKey:(NSString *)key {
  return [[self instance].plist objectForKey:key];
}

+ (id)alloc {
  @synchronized(self) {
    NSAssert(instance == nil, @"Attempted to allocate a second instance of a singleton CMAppConfig.");
    instance = [super alloc];
  }
  return instance;
}

- (id)init {
  if (self = [super init]) {
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"AppConfig.plist"];
    plist_ = [[NSDictionary dictionaryWithContentsOfFile:path] retain];
  }
  return self;
}

@end