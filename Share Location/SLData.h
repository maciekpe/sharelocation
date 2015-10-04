#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SLData : NSObject

//getter (statyczny) dla aktualnej lokalizacji
+ (CLLocation*) getCurrentLocation ;
//setter (statyczny) dla aktualnej lokalizacji
+ (void) setCurrentLocation:(CLLocation *) location;

//getter (statyczny) dla kolegi lokalizacji
+ (CLLocation*) getMateLocation ;
//setter (statyczny) dla kolegi lokalizacji
+ (void) setMateLocation:(CLLocation *) location;

//getter (statyczny)
+ (NSString*) getNameString;
//setter (statyczny) tokena
+ (void) setNameString:(NSString *) name;

//getter (statyczny) tokena
+ (UIImage*) getImage;
//setter (statyczny) tokena
+ (void) setImage:(UIImage *) img;

//getter (statyczny) dla poprzedniej lokalizacji
+ (CLLocation*) getPrevoiusLocation;

//wylicza czy dystans do celu jest mniejszy
+ (bool) isDistanceShorter;


@end
