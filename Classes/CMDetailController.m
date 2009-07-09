//
//  CMDetailController.m
//  CoffeeMe
//
//  Created by min on 5/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CMDetailController.h"


@implementation CMDetailController

- (id)initWithStore:(CMStore *)store {
  if (self = [super init]) {
    store_ = [store retain];
        
    self.title = @"Details";
  }
  return self;
}

- (void)loadView {
  [super loadView];
  detailView_ = [[CMDetailView alloc] initWithFrame:self.view.bounds withStore:store_]; 
  mapView_    = [[[MKMapView alloc] initWithFrame:CGRectMake(20, 140, 280, 200)] autorelease];
  mapView_.delegate = self;
  mapView_.centerCoordinate = store_.coordinate;
  [mapView_ setRegion:MKCoordinateRegionMake(store_.coordinate, MKCoordinateSpanMake(.005,.005))];
  [mapView_ addAnnotation:store_];
  
  [self.view addSubview:detailView_];
  [detailView_ insertSubview:mapView_ atIndex:0];  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
  [store_ release];
  [detailView_ release];
  [super dealloc];
}

#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
  MKPinAnnotationView *view = nil;
  
  NSLog(@"annotation: %f,%f", annotation.coordinate.latitude, annotation.coordinate.longitude);

  if (annotation != mapView.userLocation) {
    view = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MKPinAnnotationViewIdentifier"];
    if (nil == view) {
      view = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MKPinAnnotationViewIdentifier"] autorelease];
      view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    [view setPinColor:MKPinAnnotationColorRed];
    [view setCanShowCallout:YES];
    [view setAnimatesDrop:YES];
  }
  return view;
}

@end