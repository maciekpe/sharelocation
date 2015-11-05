#import "IdentificationService.h"
#import "LinkService.h"
#import "MessageService.h"

@interface SLShareLocationViewController : UIViewController
@property (nonatomic, strong, readonly) IdentificationService* identificationService;
@property (nonatomic, strong, readonly) LinkService* linkService;
@property (nonatomic, strong, readonly) MessageService* messageService;
@end