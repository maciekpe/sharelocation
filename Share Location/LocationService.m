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

- (MKCoordinateRegion) calculateRegionWithBase:(CLLocation *) basePoint withRemote: (CLLocation *) remotePoint {
    CLLocationDistance distance = [remotePoint distanceFromLocation:basePoint];
    double calculatedDistance = distance * 2.5;
    NSLog(@" calculatedDistance %.0f", calculatedDistance);
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(remotePoint.coordinate, calculatedDistance, calculatedDistance);
    return viewRegion;
}

- (BOOL) isRegionNotAdjusted:(MKCoordinateRegion) adjustedRegion {
    return (isnan(adjustedRegion.span.latitudeDelta) || isnan(adjustedRegion.span.longitudeDelta));
}

- (SLMapAnnotation*) createMapAnnotationWith: (CLLocationCoordinate2D) pinLocation withTitle:(NSString *) title {
    NSMutableString *userTitle = [[NSMutableString alloc] init];
    [userTitle appendString:title];
    NSString *titleName = @"Destination";
    if([SLData getNameString] != nil){
        titleName = [SLData getNameString];
    }
    SLMapAnnotation *annotation =
    [[SLMapAnnotation alloc] initWithCoordinates:pinLocation
                                           title:titleName subTitle:userTitle];
    return annotation;
}

- (MKPolyline*) createLineWithBase:(CLLocation *) basePoint withRemote: (CLLocation *) remotePoint {
    CLLocationCoordinate2D coordinates[2];
    coordinates[0] = basePoint.coordinate;
    coordinates[1] = remotePoint.coordinate;
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
