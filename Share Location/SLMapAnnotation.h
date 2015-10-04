#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SLMapAnnotation : NSObject <MKAnnotation>

// lokalizacja
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
// tytuł
@property (nonatomic, copy, readonly) NSString *title;
// podpis
@property (nonatomic, copy, readonly) NSString *subtitle;

/*
    obiekt adnotacji na mapie
 */
- (id) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates title:(NSString *)paramTitle
                  subTitle:(NSString *)paramSubTitle;

@end
