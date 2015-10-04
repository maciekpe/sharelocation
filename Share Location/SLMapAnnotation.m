#import "SLMapAnnotation.h"


@implementation SLMapAnnotation


/*
  adnotacja na mapie
 */

- (id) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates title:(NSString *)paramTitle
                  subTitle:(NSString *)paramSubTitle{ self = [super init];
    if (self != nil){
        _coordinate = paramCoordinates;
        _title = paramTitle;
        _subtitle = paramSubTitle;
    }
    return(self); }
@end
