//
//  CMStore.h
//  CoffeeMe
//
//  Created by min on 5/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMModel.h"


@interface CMStore : CMModel<CMModel, MKAnnotation> {
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

@property(nonatomic, retain) NSString *address;
@property(nonatomic, retain) NSString *phone;

@property(nonatomic) CMStoreType type;

@property(nonatomic) double latitude;
@property(nonatomic) double longitude;
@property(nonatomic) double userLatitude;
@property(nonatomic) double userLongitude;
@property(nonatomic) double distance;
@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;

+ (NSArray *)nearby:(CLLocationCoordinate2D)coordinate withType:(CMStoreType)type;

- (NSString *)address;
- (NSString *)formattedDistance;

- (CLLocation *)location;
- (NSString *)gmapUrl;
- (NSString *)bearing;

@end