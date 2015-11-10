#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SLData : NSObject
@property (nonatomic, strong, readwrite) CLLocation *currentLocation;
@property (nonatomic, strong, readwrite) CLLocation *prevoiusLocation;
@property (nonatomic, strong, readwrite) CLLocation *mateLocation;
@property (nonatomic, strong, readwrite) NSString *nameString;
@property (nonatomic, strong, readwrite) UIImage *image;
@property (nonatomic, strong, readwrite) NSDate *lastSound;
- (void) setCurrentLocation:(CLLocation *) location;
- (bool) isDistanceShorter;
- (bool) isLocationChangeRevelant:(CLLocation*) location;
@end
