#import "SLData.h"
#import <MapKit/MapKit.h>

@implementation SLData

- (void) setCurrentLocation:(CLLocation *) location{
    _prevoiusLocation = _currentLocation;
    _currentLocation = location;
}

- (bool) isDistanceShorter{
    if(self.mateLocation == nil || self.prevoiusLocation == nil || self.currentLocation == nil){
        return YES;
    }
    return ([self.mateLocation distanceFromLocation:self.currentLocation]) < ([self.mateLocation distanceFromLocation:self.prevoiusLocation]);
}

- (bool) isLocationChangeRevelant:(CLLocation*) location {
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    return (fabs(howRecent) < 15.0 && (self.currentLocation==nil || [location distanceFromLocation:self.currentLocation] >10));
}

@end
