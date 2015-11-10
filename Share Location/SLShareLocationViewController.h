#import "IdentificationService.h"
#import "LinkService.h"
#import "MessageService.h"
#import "ContactsService.h"
#import "LocationService.h"

@interface SLShareLocationViewController : UIViewController
@property (nonatomic, strong, readonly) IdentificationService* identificationService;
@property (nonatomic, strong, readonly) LinkService* linkService;
@property (nonatomic, strong, readonly) ContactsService* contactsService;
@property (nonatomic, strong, readonly) MessageService* messageService;
@property (nonatomic, strong, readonly) LocationService* locationService;
@end