//
//  CMStore.h
//  CoffeeMe
//
//  Created by min on 5/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "CMModel.h"


@interface CMStore : CMModel<CMModel> {
  NSString *address_;
  NSString *phone_;
    
  CMStoreType type_;
    
  double latitude_;
  double longitude_;
  double userLatitude_;
  double userLongitude_;
  double distance_;

  CLLocationCoordinate2D userCoordinate_;
}

@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *phone;

@property (nonatomic, assign) CMStoreType type;

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double userLatitude;
@property (nonatomic, assign) double userLongitude;
@property (nonatomic, assign) double distance;

+ (NSArray *)nearby:(CLLocationCoordinate2D)coordinate withType:(CMStoreType)type;

- (NSString *)address;
- (NSString *)formattedDistance;

- (CLLocation *)location;
- (NSString *)gmapUrl;
- (NSString *)bearing;

@end