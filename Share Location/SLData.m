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
    bool result = ( self.currentLocation == nil ||
                   (([location distanceFromLocation:self.currentLocation] > 10) && (fabs([self.currentLocation.timestamp timeIntervalSinceNow]) > 10)) ||
                   (([location distanceFromLocation:self.mateLocation] < 10) && (fabs([self.currentLocation.timestamp timeIntervalSinceNow]) > 2))
                   );
    //NSLog(@"Revelant time interval = [%f]", [self.currentLocation.timestamp timeIntervalSinceNow]);
    //NSLog(@"Revelant distance =[%f]", [location distanceFromLocation:self.currentLocation]);
    //NSLog(@"Revelant distance [%d] > 10", ([location distanceFromLocation:self.currentLocation] > 10 ));
    //NSLog(@"Revelant distance to mate [%d] < 10", ([location distanceFromLocation:self.currentLocation] < 10 ));
    //NSLog(@"Revelant distance to mate [%f]", [location distanceFromLocation:self.mateLocation]);
    //NSLog(@"Revelant current is null =[%d]", self.currentLocation == nil);
    //NSLog(@"Revelant result =[%d]", result);
    return result;
}

@end
