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

@synthesize pk = pk_, street = street_, city = city_, state = state_, zip = zip_, phone = phone_, 
type = type_, latitude = latitude_, longitude = longitude_, cell = cell_, distance = distance_,
userLatitude = userLatitude_, userLongitude = userLongitude_;

+ (NSString *)storeNameForCode:(NSUInteger)code {
    NSString *store;
    switch(code) {
        case 0:
            store = @"Starbucks";
            break;
		case 1:
            store = @"Dunkin Donuts";
            break;
		case 2:
            store = @"Caribou Coffee";
            break;
	}    
    return store;
}

- (UIView *)viewForCell {
    UIView *cell = [[[UIView alloc] initWithFrame:CGRectMake(0,0,320,100)] autorelease];
    cell.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"cup-%d.png", self.type]]] autorelease];
    imageView.frame = CGRectMake(10, 10, 53, 53);
    
    UILabel *lblStore = [[[UILabel alloc] initWithFrame:CGRectMake(70, 10, 250, 20)] autorelease];
    lblStore.backgroundColor = [UIColor clearColor];
    lblStore.text = [[self class] storeNameForCode:[self type]];
    lblStore.font= [UIFont boldSystemFontOfSize:16];
    
    UILabel *lblStreet = [[[UILabel alloc] initWithFrame:CGRectMake(70, 30, 250, 40)] autorelease];
    lblStreet.backgroundColor = [UIColor clearColor];
    lblStreet.text = [self address];
    lblStreet.numberOfLines = 2;
    lblStreet.font= [UIFont boldSystemFontOfSize:14];
    
    UILabel *lblDistance = [[[UILabel alloc] initWithFrame:CGRectMake(70, 70, 230, 20)] autorelease];
    lblDistance.backgroundColor = [UIColor clearColor];
    lblDistance.text = [NSString stringWithFormat:@"%@ %@", [self formattedDistance], [self directionFrom]];
    lblDistance.font = [UIFont systemFontOfSize:12];
    
    [cell addSubview:lblStore];
    [cell addSubview:lblDistance];
    [cell addSubview:lblStreet];
    [cell addSubview:imageView];
    
    [self directionFrom];
    
    cell.tag = 99;
    return cell;
}

- (id)initWithFMResultSet:(FMResultSet *)resultSet {
    if (self = [super init]) {
        self.pk        = [resultSet intForColumn:@"id"];
        self.street    = [resultSet stringForColumn:@"street"];
        self.city      = [resultSet stringForColumn:@"city"];
        self.state     = [resultSet stringForColumn:@"state"];
        self.zip       = [resultSet stringForColumn:@"zip"];
        self.phone     = [resultSet stringForColumn:@"phone"];
        self.type      = [resultSet intForColumn:@"store_type"];
        self.latitude  = [resultSet doubleForColumn:@"latitude"];
        self.longitude = [resultSet doubleForColumn:@"longitude"];
        self.userLatitude = [resultSet doubleForColumn:@"user_latitude"];
        self.userLongitude = [resultSet doubleForColumn:@"user_longitude"];
        self.distance  = [resultSet doubleForColumn:@"dist"];
        self.cell      = [self viewForCell];
	}
	
	return self;
}

+ (NSArray *)nearby:(CLLocationCoordinate2D)coordinate {
    NSString *query = [NSString stringWithFormat:@"select stores.*, %f as user_latitude, %f as user_longitude, distance(latitude, longitude, %f, %f) as dist from stores where dist < 10 order by dist limit 20", coordinate.latitude, coordinate.longitude, coordinate.latitude, coordinate.longitude];
    return [self query:query];
}

+ (NSString *)tableName {
    return @"stores";
}

// + (CGPoint)coordinate2CGPoint:(CLLocationCoordinate2D)coordinate {
//     double offset = 268435456;
//     double radius = offset / M_PI;
//     double targetX = round(offset * radius * coordinate.longitude * M_PI / 180);
//     double targetY = round(offset - radius * log((1 + sin(coordinate.latitude * M_PI / 180)) / (1 - sin(coordinate.latitude * M_PI / 180))) / 2);
//     double deltaX = ((targetX - 128) >> (21 - 14));
//     double deltaY = ((targetY - 128) >> (21 - 14));
//     
//     return CGPointMake(deltaX, deltaY);    
// }

- (NSString *)description {
    return [self address];
}

- (CLLocation *)location {
    return [[[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude] autorelease];
}

- (NSString *)address {
    return [NSString stringWithFormat:@"%@\n%@, %@. %@", street_, city_, state_, zip_];
}

- (NSString *)address2 {
    return [NSString stringWithFormat:@"%@, %@. %@", city_, state_, zip_];
}

// public static Double Bearing(Coordinate coordinate1, Coordinate coordinate2)
//    6:       {
//    7:           var latitude1 = coordinate1.Latitude.ToRadian();
//    8:           var latitude2 = coordinate2.Latitude.ToRadian();
//    9:  
//   10:           var longitudeDifference = (coordinate2.Longitude - coordinate1.Longitude).ToRadian();
//   11:  
//   12:           var y = Math.Sin(longitudeDifference) * Math.Cos(latitude2);
//   13:           var x = Math.Cos(latitude1) * Math.Sin(latitude2) -
//   14:                   Math.Sin(latitude1) * Math.Cos(latitude2) * Math.Cos(longitudeDifference);
//   15:  
//   16:           return (Math.Atan2(y, x).ToDegree() + 360) % 360;
//   17:       }


- (NSString *)directionFrom {
    
    double rLat1 = DEG2RAD(userLatitude_);
    double rLat2 = DEG2RAD(latitude_);
    double lngDelta = DEG2RAD((longitude_ - userLongitude_));
    
    // double rLat1 = DEG2RAD(38.906786);
    // double rLat2 = DEG2RAD(38.907635);
    // double lngDelta = DEG2RAD(-77.041919) - DEG2RAD(-77.041787);
    
    double y = asin(lngDelta) * cos(rLat2);
    double x = (cos(rLat1) * sin(rLat2)) - (sin(rLat1) * cos(rLat2) * cos(lngDelta));
    
    double bearing = fmod(RAD2DEG(atan2(y,x)) + 360, 360);
    
    NSLog(@"bearing: %f", bearing);
    
    NSString *direction = @"N";
    
    if (bearing >= 0 && bearing < 22.5) {
        direction = @"N";
    }
    else if (bearing >= 22.5 && bearing < 67.5) {
        direction = @"NE";
    }
    else if (bearing >= 67.5  && bearing < 112.5) {
        direction = @"E";
    }
    else if (bearing >= 112.5  && bearing < 157.5) {
        direction = @"SE";
    }
    else if (bearing >= 157.5 && bearing < 202.5) {
        direction = @"S";
    }
    else if (bearing >= 202.5 && bearing < 247.5) {
        direction = @"SW";
    }
    else if (bearing >= 247.5 && bearing < 292.5) {
        direction = @"W";
    }
    else if (bearing >= 292.5 && bearing < 337.5) {
        direction = @"NW";
    }
    
    return direction;
}

- (NSString *)formattedDistance {
    return [NSString stringWithFormat:@"%.2f mi", (self.distance * .621371192)];
}

- (NSString *)gmapUrl {
    return [NSString stringWithFormat:@"http://maps.google.com/staticmap?center=%f,%f&zoom=14&size=256x256&maptype=mobile&key=%2&sensor=false", self.latitude, self.longitude, GMAP_KEY];
}

@end