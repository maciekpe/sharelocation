#import "LinkData.h"
#import "Consts.h"

@implementation LinkData

- (instancetype) initWithLatitude:(NSString *) latitude withLongitude: (NSString *) longitude withPrimaryContactToken: (NSString *) primaryToken withSecondaryContactToken: (NSString *) secondaryToken
{
    self = [super init];
    if (self) {
        _latitudeValue = latitude;
        _longitudeValue = longitude;
        _primaryContactToken = primaryToken;
        _secondaryContactToken = secondaryToken;
    }
    return self;
}

@end