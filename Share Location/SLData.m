#import "SLData.h"
#import <MapKit/MapKit.h>

@implementation SLData

static CLLocation *currentLocation;

static CLLocation *prevoiusLocation;

static CLLocation *mateLocation;

static NSString *nameString;

static UIImage *image;

static NSDate *lastSound;

//getter (statyczny)
+ (NSString*) getNameString {
    return nameString;
}
//setter (statyczny) tokena
+ (void) setNameString:(NSString *) name{
    nameString = name;
}

//getter (statyczny) tokena
+ (UIImage*) getImage {
    return image;
}
//setter (statyczny) tokena
+ (void) setImage:(UIImage *) img{
    image = img;
}

//getter (statyczny) dla kolegi lokalizacji
+ (CLLocation*) getMateLocation {
    return mateLocation;
}
//setter (statyczny) dla kolegi lokalizacji
+ (void) setMateLocation:(CLLocation *) location{
    mateLocation = location;
}

//getter (statyczny) dla poprzedniej lokalizacji
+ (CLLocation*) getPrevoiusLocation {
    return prevoiusLocation;
}

//getter (statyczny) dla aktualnej  lokalizacji
+ (CLLocation*) getCurrentLocation {
    return currentLocation;
}
//setter (statyczny) dla aktualnej lokalizacji
+ (void) setCurrentLocation:(CLLocation *) location{
    prevoiusLocation = currentLocation;
    currentLocation = location;
}

+ (NSDate*) getLastSound {
    return lastSound;
}
//setter (statyczny) tokena
+ (void) setLastSound:(NSDate *) sound {
    lastSound = sound;
}

//wylicza czy odleglosc od punktu docelowego jest mniejsza niz w poprzednim pomiarze
+ (bool) isDistanceShorter{
    if(mateLocation == nil || prevoiusLocation == nil || currentLocation == nil){
        return YES;
    }
    return ([mateLocation distanceFromLocation:currentLocation]) < ([mateLocation distanceFromLocation:prevoiusLocation]);
}

@end
