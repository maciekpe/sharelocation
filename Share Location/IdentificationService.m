#import "IdentificationService.h"
#import "Consts.h"

@implementation IdentificationService


- (instancetype) initWithUserDefaults:(NSUserDefaults *) userDefaults
{
    self = [super init];
    if (self) {
        if(userDefaults == nil){
            NSException* myException = [NSException
                                        exceptionWithName:@"CNContactStoreNotFoundException"
                                        reason:@"CNContactStore is nil"
                                        userInfo:nil];
            @throw myException;
        }
        _userDefaults = userDefaults;
    }
    return self;
}

/*
 Pobiera UID identyfikacji uzytkownika jesl istnieje.
 */
-(NSString *) getUserIdentification{
    NSString *userIdentification = [self.userDefaults stringForKey:SL_UID];
    return userIdentification;
}

@end
