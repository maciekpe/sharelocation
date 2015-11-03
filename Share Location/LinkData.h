#import <Foundation/Foundation.h>

@interface LinkData : NSObject
- (instancetype) initWithLatitude:(NSString *) latitude withLongitude: (NSString *) longitude withPrimaryContactToken: (NSString *) primaryToken withSecondaryContactToken: (NSString *) secondaryToken;
@property (nonatomic, strong, readonly) NSString *latitudeValue;
@property (nonatomic, strong, readonly) NSString *longitudeValue;
@property (nonatomic, strong, readonly) NSString *primaryContactToken;
@property (nonatomic, strong, readonly) NSString *secondaryContactToken;
@end