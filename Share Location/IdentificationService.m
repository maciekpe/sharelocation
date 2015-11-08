#import "IdentificationService.h"
#import "Consts.h"

@implementation IdentificationService

//dodac test na save


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

-(NSString *) getUserIdentification {
    NSString *userIdentification = [self.userDefaults stringForKey:SL_UID];
    return userIdentification;
}

- (BOOL) isUserIdentificationEmpty {
    NSString *userUdentification = [self getUserIdentification];
    userUdentification = [userUdentification stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ];
    return [userUdentification length] == 0;
}

-(void) saveUserIdentification: (NSString *) uid {
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:SL_UID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
