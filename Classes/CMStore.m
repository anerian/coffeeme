//
//  CMStore.m
//  CoffeeMe
//
//  Created by min on 5/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMStore.h"
#import "math.h"

@implementation CMStore

@synthesize address = address_, phone = phone_, type = type_, latitude = latitude_, longitude = longitude_, 
distance = distance_, userLatitude = userLatitude_, userLongitude = userLongitude_;

- (id)initWithFMResultSet:(FMResultSet *)resultSet {
  if (self = [super init]) {
    self.pk            = [resultSet intForColumn:@"id"];
    
    NSString *street   = [resultSet stringForColumn:@"street"];
    NSString *city     = [resultSet stringForColumn:@"city"];
    NSString *zip      = [resultSet stringForColumn:@"zip"];
    NSString *state    = [resultSet stringForColumn:@"state"];
    
    self.address       = [NSString stringWithFormat:@"%@\n%@, %@. %@", street, city, state, zip];
    self.phone         = [[[resultSet stringForColumn:@"phone"] copy] autorelease];
    self.type          = [resultSet intForColumn:@"store_type"];
    self.latitude      = [resultSet doubleForColumn:@"latitude"];
    self.longitude     = [resultSet doubleForColumn:@"longitude"];
    self.userLatitude  = [resultSet doubleForColumn:@"user_latitude"];
    self.userLongitude = [resultSet doubleForColumn:@"user_longitude"];
    self.distance      = [resultSet doubleForColumn:@"dist"];
	}
	
	return self;
}

+ (NSArray *)nearby:(CLLocationCoordinate2D)coordinate withType:(CMStoreType)type {
  #if defined(TARGET_IPHONE_SIMULATOR) && defined(DEBUG)
  // Alameda, CA 94501
  // coordinate.latitude = 37.763853;
  // coordinate.longitude = -122.243340;
  
  // NY
  coordinate.latitude = 40.714935;
  coordinate.longitude = -73.999639;
  
  // Dupont - Washington, DC 20036
  //coordinate.latitude = 38.906786;
  //coordinate.longitude = -77.041787;
  #endif
  
  NSString *query;
  if (type == CMStoreTypeAll) {
    query = [NSString stringWithFormat:@"select stores.*, %f as user_latitude, %f as user_longitude, distance(latitude, longitude, %f, %f) as dist from stores where dist < 10 order by dist limit 20", coordinate.latitude, coordinate.longitude, coordinate.latitude, coordinate.longitude];
  } else {
    query = [NSString stringWithFormat:@"select stores.*, %f as user_latitude, %f as user_longitude, distance(latitude, longitude, %f, %f) as dist from stores where store_type = %d and dist < 10 order by dist limit 20", coordinate.latitude, coordinate.longitude, coordinate.latitude, coordinate.longitude, type];
  }
    
  return [self query:query];
}

+ (NSString *)tableName {
  return @"stores";
}

- (CLLocationCoordinate2D)coordinate {
  return (CLLocationCoordinate2D){self.latitude, self.longitude};
}

- (NSString *)title {
  return CMShopType(type_);
}

- (NSString *)subtitle {
  return address_;
}

- (NSString *)description {
  return [self address];
}

- (CLLocation *)location {
  return [[[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude] autorelease];
}

- (NSString *)bearing {
  double rLat1 = DEG2RAD(userLatitude_);
  double rLat2 = DEG2RAD(latitude_);
  double lngDelta = DEG2RAD((longitude_ - userLongitude_));

  double y = asin(lngDelta) * cos(rLat2);
  double x = (cos(rLat1) * sin(rLat2)) - (sin(rLat1) * cos(rLat2) * cos(lngDelta));

  double bearing = fmod(RAD2DEG(atan2(y,x)) + 360, 360);

  NSString *direction = @"N";

  if (bearing >= 0 && bearing < 22.5) {
    direction = @"N";
  } else if (bearing >= 22.5  && bearing < 67.5) {
    direction = @"NE";
  } else if (bearing >= 67.5  && bearing < 112.5) {
    direction = @"E";
  } else if (bearing >= 112.5 && bearing < 157.5) {
    direction = @"SE";
  } else if (bearing >= 157.5 && bearing < 202.5) {
    direction = @"S";
  } else if (bearing >= 202.5 && bearing < 247.5) {
    direction = @"SW";
  } else if (bearing >= 247.5 && bearing < 292.5) {
    direction = @"W";
  } else if (bearing >= 292.5 && bearing < 337.5) {
    direction = @"NW";
  }

  return direction;
}

- (NSString *)formattedDistance {
  return [NSString stringWithFormat:@"%.2f mi", (self.distance * .621371192)];
}

- (NSString *)gmapUrl {
  return [NSString stringWithFormat:@"http://maps.google.com/staticmap?center=%f,%f&zoom=14&size=280x200&maptype=mobile&key=%2&sensor=false", self.latitude, self.longitude, GMAP_KEY];
}

- (void)dealloc {
  [address_ release];
  [phone_ release];
  [super dealloc];
}

@end