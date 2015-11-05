#import <Foundation/Foundation.h>
#import "LinkData.h"
#import "IdentificationService.h"

@interface LinkService : NSObject
- (instancetype) initWithIdentificationService:(IdentificationService *) identificationService;
- (LinkData *) decomposeLinkDataFromUrl :(NSURL *)url;
- (NSString *) composeLink;
@property (nonatomic, strong, readonly) IdentificationService *identificationService;
@end
