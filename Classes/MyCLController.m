#import "MyCLController.h"

@implementation MyCLController

@synthesize locationManager;
@synthesize delegate;

- (id) init {
	self = [super init];
	if (self != nil) {
		self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
		self.locationManager.delegate = self;
        first_ = YES;
	}
	return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSTimeInterval howRecent = [newLocation.timestamp timeIntervalSinceNow];
    
    if (howRecent < -5) {
        first_ = NO;
        return;
    }

    NSLog(@"newLocation: %f", newLocation.horizontalAccuracy);
    // if (newLocation.horizontalAccuracy < 100) {
        
        [self.locationManager stopUpdatingLocation];
        [self.delegate locationUpdate:newLocation];
    // }
	
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
