#import <Foundation/Foundation.h>

@interface IdentificationService : NSObject

- (instancetype) initWithUserDefaults:(NSUserDefaults *) userDefaults;
-(NSString *) getUserIdentification;
@property (nonatomic, strong, readonly) NSUserDefaults *userDefaults;

@end
