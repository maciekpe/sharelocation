#import <Foundation/Foundation.h>
#import "LinkData.h"
#import "IdentificationService.h"
#import <MapKit/MapKit.h>

@interface LinkService : NSObject
- (instancetype) initWithIdentificationService:(IdentificationService *) identificationService;
- (LinkData *) decomposeLinkDataFromUrl :(NSURL *)url;
- (NSString *) composeLinkWithLocation:(CLLocation*) location;
@property (nonatomic, strong, readonly) IdentificationService *identificationService;
@end
