#import <Foundation/Foundation.h>
#import "LinkService.h"
#import <MapKit/MapKit.h>

@interface MessageService : NSObject
- (instancetype) initWithLinkService:(LinkService*) linkService;
@property (nonatomic, strong, readonly) LinkService *linkService;
-(NSAttributedString *) composeHtmlAttributedMessageWithLocation:(CLLocation*) location;
-(NSString *) composeHtmlStringMessageWithLocation:(CLLocation*) location;
-(NSString *) composeStringMessageWithLocation:(CLLocation*) location;
@end
