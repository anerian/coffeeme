//
//  CMLocation.h
//  CoffeeMe
//
//  Created by min on 5/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//



@interface CMLocation : NSObject<CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

+ (CMLocation *)instance;

- (void)start;
- (void)stop;
- (BOOL)locationKnown;

@property(nonatomic, retain) CLLocation *currentLocation;

@end