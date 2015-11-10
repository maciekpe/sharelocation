#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>
#import "SLMapAnnotation.h"
#import "SLData.h"

@interface LocationService : NSObject
//- (instancetype) init;
+ (instancetype) getInstance;
- (void) logLocation: (CLLocation *) location logString:(NSString *) log;
- (CLLocationManager* ) createLocationManager;
- (MKCoordinateRegion) calculateRegionForCurrentAndMateLocations;
- (MKCoordinateRegion) calculateRegionForCurrentLocation;
- (BOOL) isRegionNotAdjusted:(MKCoordinateRegion) adjustedRegion;
- (SLMapAnnotation*) createMapAnnotationForMate;
- (MKPolyline*) createLineBetweenCurrentAndMateLocation;
- (MKPinAnnotationView*) createAnnotationView: (MKPinAnnotationView*) annotationView forAnnotation:(id <MKAnnotation>)annotation ;
- (MKOverlayRenderer*) createLineViewWith:(MKPolyline *)polyline;
@property (nonatomic, strong, readwrite) SLData* locationData;
@end
