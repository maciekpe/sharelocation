#import "LocationService.h"
#import <MapKit/MapKit.h>
#import "SLData.h"
#import "SLPinAnnotationView.h"

@implementation LocationService

- (instancetype)init {
    self = [super init];
    if (self) {
    
    }
    return self;
}

- (MKCoordinateRegion) calculateRegionForCurrentAndMateLocations {
    
    CLLocationDistance distance = [[SLData getCurrentLocation] distanceFromLocation:[SLData getMateLocation]];
    double calculatedDistance = distance * 2.5;
    NSLog(@" calculatedDistance %.0f", calculatedDistance);
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance([SLData getCurrentLocation].coordinate, calculatedDistance, calculatedDistance);
    return viewRegion;
}

- (MKCoordinateRegion) calculateRegionForCurrentLocation {
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance([SLData getCurrentLocation].coordinate, 600, 600);
    return viewRegion;
}

- (BOOL) isRegionNotAdjusted:(MKCoordinateRegion) adjustedRegion {
    return (isnan(adjustedRegion.span.latitudeDelta) || isnan(adjustedRegion.span.longitudeDelta));
}

- (SLMapAnnotation*) createMapAnnotationForMate {
    
    CLLocationDistance distance = [[SLData getMateLocation] distanceFromLocation:[SLData getCurrentLocation]];
    NSString *title = [self getDistanceString:distance];
    
    NSMutableString *userTitle = [[NSMutableString alloc] init];
    [userTitle appendString:title];
    NSString *titleName = @"Destination";
    if([SLData getNameString] != nil){
        titleName = [SLData getNameString];
    }
    SLMapAnnotation *annotation =
    [[SLMapAnnotation alloc] initWithCoordinates:[SLData getMateLocation].coordinate
                                           title:titleName subTitle:userTitle];
    return annotation;
}

- (MKPolyline*) createLineBetweenCurrentAndMateLocation {
    CLLocationCoordinate2D coordinates[2];
    coordinates[0] = [SLData getMateLocation].coordinate;
    coordinates[1] = [SLData getCurrentLocation].coordinate;
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:2];
    return polyLine;
}

- (MKPinAnnotationView*) createAnnotationView: (MKPinAnnotationView*) annotationView forAnnotation:(id <MKAnnotation>)annotation {
    MKPinAnnotationView* pinView = [[SLPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationIdentifier"];
    UIImage *img = nil;
    if([SLData getImage] != nil){
        img = [SLData getImage];
    }else{
        img = [UIImage imageNamed:@"multimedia/pics/target.jpg"];
    }
    UIImageView *houseIconView = [[UIImageView alloc] initWithImage:img];
    [houseIconView setFrame:CGRectMake(0, 0, 30, 30)];
    pinView.leftCalloutAccessoryView = houseIconView;
    return pinView;
}

- (CLLocationManager* ) createLocationManager {
    CLLocationManager* locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    locationManager.distanceFilter = 10;
    [locationManager requestAlwaysAuthorization];
    return locationManager;
}

- (MKOverlayRenderer*) createLineViewWith:(MKPolyline *)polyline {
    MKPolylineRenderer *polylineView = [[MKPolylineRenderer alloc] initWithPolyline:polyline];
    if([SLData isDistanceShorter]){
        polylineView.strokeColor = [UIColor greenColor];
    }else{
        polylineView.strokeColor = [UIColor redColor];
    }
    polylineView.lineWidth = 4.0;
    NSArray* array = [NSArray arrayWithObjects:[NSNumber numberWithInt:10], [NSNumber numberWithInt:10], nil];
    polylineView.lineDashPattern = array;
    return polylineView;
}

/*
 Wylicza string okreslajacy odleglosc punktu na podstawie dystansu.
 */
- (NSString *) getDistanceString:(CLLocationDistance) distance {
    NSString *title = @"";
    if(distance > 1000){
        title = [title stringByAppendingString : [NSString stringWithFormat:@"%.2f kilometers", distance/1000]];
    }else{
        title = [title stringByAppendingString : [NSString stringWithFormat:@"%.0f meters", distance]];
    }
    return title;
}

/*
 Loguje lokacje.
 */
- (void) logLocation: (CLLocation *) location logString:(NSString *) log {
    
    NSString *logString = @"Location : ";
    NSNumber *longtitude = [NSNumber numberWithDouble:location.coordinate.longitude];
    NSNumber *latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
    logString = [logString stringByAppendingString: @" latitude=" ];
    logString = [logString stringByAppendingString: [latitude stringValue] ];
    logString = [logString stringByAppendingString: @" longitude=" ];
    logString = [logString stringByAppendingString: [longtitude stringValue] ];
    NSLog(@"%@",logString);
}

@end
