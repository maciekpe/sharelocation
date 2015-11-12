#import "LocationService.h"
#import <MapKit/MapKit.h>
#import "SLData.h"
#import "SLPinAnnotationView.h"

@implementation LocationService

- (instancetype)init {
    self = [super init];
    if (self) {
        _locationData = [[SLData alloc] init];
    }
    return self;
}

+ (instancetype) getInstance {
    static LocationService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[self alloc] init];
    });
    return service;
}

- (MKCoordinateRegion) calculateRegionForCurrentAndMateLocations {
    
    CLLocationDistance distance = [self.locationData.currentLocation distanceFromLocation:self.locationData.mateLocation];
    double calculatedDistance = 300;
    if(distance > 150){
        calculatedDistance = distance * 2.5;
    }
    NSLog(@" calculatedDistance %.0f", calculatedDistance);
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.locationData.currentLocation.coordinate, calculatedDistance, calculatedDistance);
    return viewRegion;
}

- (MKCoordinateRegion) calculateRegionForCurrentLocation {
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.locationData.currentLocation.coordinate, 600, 600);
    return viewRegion;
}

- (BOOL) isRegionNotAdjusted:(MKCoordinateRegion) adjustedRegion {
    return (isnan(adjustedRegion.span.latitudeDelta) || isnan(adjustedRegion.span.longitudeDelta));
}

- (SLMapAnnotation*) createMapAnnotationForMate {
    
    CLLocationDistance distance = [self.locationData.currentLocation distanceFromLocation:self.locationData.mateLocation];
    NSString *title = [self getDistanceString:distance];
    
    NSMutableString *userTitle = [[NSMutableString alloc] init];
    [userTitle appendString:title];
    NSString *titleName = @"Destination";
    if(self.locationData.nameString != nil){
        titleName = self.locationData.nameString;
    }
    SLMapAnnotation *annotation =
    [[SLMapAnnotation alloc] initWithCoordinates:self.locationData.mateLocation.coordinate
                                           title:titleName subTitle:userTitle];
    return annotation;
}

- (MKPolyline*) createLineBetweenCurrentAndMateLocation {
    CLLocationCoordinate2D coordinates[2];
    coordinates[0] = self.locationData.mateLocation.coordinate;
    coordinates[1] = self.locationData.currentLocation.coordinate;
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:2];
    return polyLine;
}

- (MKPinAnnotationView*) createAnnotationView: (MKPinAnnotationView*) annotationView forAnnotation:(id <MKAnnotation>)annotation {
    MKPinAnnotationView* pinView = [[SLPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationIdentifier"];
    UIImage *img = nil;
    if(self.locationData.image != nil){
        img = self.locationData.image;
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

- (MKPolylineRenderer*) createLineViewWith:(MKPolyline *)polyline {
    MKPolylineRenderer* polylineView = [[MKPolylineRenderer alloc] initWithPolyline:polyline];
    if(self.locationData.isDistanceShorter){
        polylineView.strokeColor = [UIColor greenColor];
    }else{
        polylineView.strokeColor = [UIColor redColor];
    }
    polylineView.lineWidth = 4.0;
    NSArray* array = [NSArray arrayWithObjects:[NSNumber numberWithInt:10], [NSNumber numberWithInt:10], nil];
    polylineView.lineDashPattern = array;
    return polylineView;
}

- (NSString *) getDistanceString:(CLLocationDistance) distance {
    NSString *title = @"";
    if(distance > 1000){
        title = [title stringByAppendingString : [NSString stringWithFormat:@"%.2f kilometers", distance/1000]];
    }else{
        if(distance < 10){
            title = [title stringByAppendingString : [NSString stringWithFormat:@"aprox 10 meters"]];
        }else{
            title = [title stringByAppendingString : [NSString stringWithFormat:@"%.0f meters", distance]];
        }
    }
    return title;
}

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
