#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>

@interface LocationService : NSObject
- (instancetype) init;
- (NSString *) getDistanceString:(CLLocationDistance) distance;
- (void) logLocation: (CLLocation *) location logString:(NSString *) log;
- (CLLocationManager* ) createLocationManager;
@end
