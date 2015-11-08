#import <Foundation/Foundation.h>

@interface IdentificationService : NSObject

- (instancetype) initWithUserDefaults:(NSUserDefaults *) userDefaults;
- (NSString *) getUserIdentification;
- (BOOL) isUserIdentificationEmpty;
- (void) saveUserIdentification: (NSString *) uid;
@property (nonatomic, strong, readonly) NSUserDefaults *userDefaults;

@end
