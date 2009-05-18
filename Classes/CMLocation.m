//
//  CMLocation.m
//  CoffeeMe
//
//  Created by min on 5/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMLocation.h"


@implementation CMLocation

@synthesize currentLocation;

static CMLocation *instance;

+ (CMLocation *)instance {
  @synchronized(self) {
    if (!instance)
      [[CMLocation alloc] init];              
  }
  return instance;
}

+ (id)alloc {
  @synchronized(self) {
    NSAssert(instance == nil, @"Attempted to allocate a second instance of a singleton LocationController.");
    instance = [super alloc];
  }
  return instance;
}

- (id)init {
  if (self = [super init]) {
    self.currentLocation = [[CLLocation alloc] init];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [self start];
  }
  return self;
}

- (void)start {
  [locationManager startUpdatingLocation];
}

- (void)stop {
  [locationManager stopUpdatingLocation];
}

- (BOOL)locationKnown {
  return (currentLocation ? YES : NO);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
  DLog(@"verticalAccuracty: %f", newLocation.verticalAccuracy);
  DLog(@"verticalAccuracty: %f", newLocation.horizontalAccuracy);
  if (abs([newLocation.timestamp timeIntervalSinceDate:[NSDate date]]) < 5) {
    
    [self stop];
    DLog(@"verticalAccuracty: %f", newLocation.verticalAccuracy);
    self.currentLocation = newLocation;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"location:updated" object:newLocation];
  }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

@end