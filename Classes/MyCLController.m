#import "MyCLController.h"

@implementation MyCLController

@synthesize locationManager;
@synthesize delegate;

- (id) init {
	self = [super init];
	if (self != nil) {
		self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.distanceFilter = 1000;
		self.locationManager.delegate = self;
	}
	return self;
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
    NSLog(@"newLocation: %@", newLocation);
    [self.locationManager stopUpdatingLocation];
	[self.delegate locationUpdate:newLocation];
}


- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	[self.delegate locationError:error];
}

- (void)dealloc {
	[self.locationManager release];
    [super dealloc];
}

@end
