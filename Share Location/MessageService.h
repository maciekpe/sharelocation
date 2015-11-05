#import <Foundation/Foundation.h>
#import "LinkService.h"

@interface MessageService : NSObject
- (instancetype) initWithLinkService:(LinkService*) linkService;
@property (nonatomic, strong, readonly) LinkService *linkService;
-(NSAttributedString *) composeHtmlAttributedMessage;
-(NSString *) composeHtmlStringMessage;
-(NSString *) composeStringMessage;
@end
