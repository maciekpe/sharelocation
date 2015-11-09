#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>
#import "SLMapAnnotation.h"

@interface LocationService : NSObject
- (instancetype) init;
- (NSString *) getDistanceString:(CLLocationDistance) distance;
- (void) logLocation: (CLLocation *) location logString:(NSString *) log;
- (CLLocationManager* ) createLocationManager;
- (MKCoordinateRegion) calculateRegionWithBase:(CLLocation *) basePoint withRemote: (CLLocation *) remotePoint;
- (BOOL) isRegionNotAdjusted:(MKCoordinateRegion) adjustedRegion;
- (SLMapAnnotation*) createMapAnnotationWith: (CLLocationCoordinate2D) pinLocation withTitle:(NSString *) title;
- (MKPolyline*) createLineWithBase:(CLLocation *) basePoint withRemote: (CLLocation *) remotePoint;
- (MKPinAnnotationView*) createAnnotationView: (MKPinAnnotationView*) annotationView forAnnotation:(id <MKAnnotation>)annotation ;
@end
