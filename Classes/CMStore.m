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
type = type_, latitude = latitude_, longitude = longitude_, cell = cell_, distance = distance_;

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
    imageView.frame = CGRectMake(10, 23, 53, 53);
    
    UILabel *lblStore = [[[UILabel alloc] initWithFrame:CGRectMake(70, 10, 250, 20)] autorelease];
    lblStore.backgroundColor = [UIColor clearColor];
    lblStore.text = [[self class] storeNameForCode:[self type]];
    lblStore.font= [UIFont boldSystemFontOfSize:16];
    
    UILabel *lblStreet = [[[UILabel alloc] initWithFrame:CGRectMake(70, 30, 250, 40)] autorelease];
    lblStreet.backgroundColor = [UIColor clearColor];
    lblStreet.text = [self address];
    lblStreet.numberOfLines = 2;
    lblStreet.font= [UIFont boldSystemFontOfSize:14];
    
    [cell addSubview:lblStore];
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
        self.distance  = [resultSet doubleForColumn:@"dist"];
        self.cell      = [self viewForCell];
	}
	
	return self;
}

+ (NSArray *)nearby:(CLLocationCoordinate2D)coordinate {
    NSString *query = [NSString stringWithFormat:@"select stores.*, distance(latitude, longitude, %f, %f) as dist from stores where dist < 10 order by dist limit 20", coordinate.latitude, coordinate.longitude];
    NSLog(query);
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

- (NSString *)directionFrom:(CLLocationCoordinate2D)coordinate {
    double dLng = DEG2RAD(longitude_ - coordinate.longitude);
    double fromLat = DEG2RAD(latitude_);
    double toLat = DEG2RAD(coordinate.latitude);
    double y = sin(dLng) * cos(toLat);
    double x = cos(fromLat) * sin(toLat) - sin(fromLat) * cos(toLat) * cos(dLng);
    int heading = round(atan2(y,x) * 180 / M_PI);
    int direction = (heading+360) % 360;
    
    NSLog(@"direction: %d", direction);
    
    return @"direction";
}

- (NSString *)formattedDistance {
    return [NSString stringWithFormat:@"%f mi", (self.distance * .000621371192)];
}

- (NSString *)gmapUrl {
    return [NSString stringWithFormat:@"http://maps.google.com/staticmap?center=%f,%f&zoom=14&size=256x256&maptype=mobile&key=%2&sensor=false", self.latitude, self.longitude, GMAP_KEY];
}



@end