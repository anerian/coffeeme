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

- (UILabel *)labelForFrame:(CGRect)frame withText:(NSString *)text withFontSize:(double)fontSize {
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    label.text = text;
	label.font = [UIFont boldSystemFontOfSize:fontSize];
    label.backgroundColor = [UIColor clearColor];
    label.shadowOffset = CGSizeMake(0,1);
    label.shadowColor = [UIColor whiteColor];
    label.textColor = [UIColor blackColor];
    return label;
}

- (UIView *)viewForCell {
    UIView *cell = [[[UIView alloc] initWithFrame:CGRectMake(0,0,320,100)] autorelease];
    cell.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"cup-%d.png", self.type]]] autorelease];
    imageView.frame = CGRectMake(10, 10, 53, 53);
    
    UILabel *lblStore = [self labelForFrame:CGRectMake(70, 10, 250, 20) withText:[[self class] storeNameForCode:[self type]] withFontSize:16];
    lblStore.textColor = HexToUIColor(0x56523c);
    UILabel *lblStreet = [self labelForFrame:CGRectMake(70, 30, 250, 40) withText:[[[self address] copy] autorelease] withFontSize:14];
    lblStreet.numberOfLines = 2;
    UILabel *lblDistance = [self labelForFrame:CGRectMake(70, 70, 230, 20) withText:[NSString stringWithFormat:@"%@ %@", [self formattedDistance], [self bearing]] withFontSize:12];
    
    [cell addSubview:lblStore];
    [cell addSubview:lblDistance];
    [cell addSubview:lblStreet];
    [cell addSubview:imageView];
    
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

+ (CGPoint)coordinate2CGPoint:(CLLocationCoordinate2D)coordinate {
    double offset = 268435456;
    double radius = offset / M_PI;
    int targetX = round(offset * radius * coordinate.longitude * M_PI / 180) - 128;
    int targetY = round(offset - radius * log((1 + sin(coordinate.latitude * M_PI / 180)) / (1 - sin(coordinate.latitude * M_PI / 180))) / 2) - 128;
    
    int deltaX = targetX >> (21 - 14);
    int deltaY = targetY >> (21 - 14);
    
    return CGPointMake(deltaX, deltaY);
}

- (CGPoint)point {
    return [[self class] coordinate2CGPoint:(CLLocationCoordinate2D){latitude_, longitude_}];
}

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
    return [NSString stringWithFormat:@"http://maps.google.com/staticmap?center=%f,%f&zoom=14&size=280x280&maptype=mobile&key=%2&sensor=false", self.latitude, self.longitude, GMAP_KEY];
}

- (void)dealloc {
    [street_ release];
    [city_ release];
    [state_ release];
    [zip_ release];
    [phone_ release];
    [cell_ release];
    [super dealloc];
}

@end