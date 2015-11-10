#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>
#import "SLMapAnnotation.h"

@interface LocationService : NSObject
- (instancetype) init;
- (NSString *) getDistanceString:(CLLocationDistance) distance;
- (void) logLocation: (CLLocation *) location logString:(NSString *) log;
- (CLLocationManager* ) createLocationManager;
- (MKCoordinateRegion) calculateRegionForCurrentAndMateLocations;
- (MKCoordinateRegion) calculateRegionForCurrentLocation;
- (BOOL) isRegionNotAdjusted:(MKCoordinateRegion) adjustedRegion;
- (SLMapAnnotation*) createMapAnnotationForMate;
- (MKPolyline*) createLineBetweenCurrentAndMateLocation;
- (MKPinAnnotationView*) createAnnotationView: (MKPinAnnotationView*) annotationView forAnnotation:(id <MKAnnotation>)annotation ;
- (MKOverlayRenderer*) createLineViewWith:(MKPolyline *)polyline;
@end
