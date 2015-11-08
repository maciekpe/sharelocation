#import "LocationService.h"
#import <MapKit/MapKit.h>

@implementation LocationService

- (instancetype)init {
    self = [super init];
    if (self) {
    
    }
    return self;
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
