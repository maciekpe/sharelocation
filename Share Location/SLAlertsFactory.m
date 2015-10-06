#import <Foundation/Foundation.h>
#import "SLAlertsFactory.h"
@implementation SLAlertsFactory

+ (instancetype) getInstance {
    static SLAlertsFactory *factory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        factory = [[self alloc] init];
    });
    return factory;
}

+(UIAlertController *) createErrorAlert:(NSString *) message{
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Error"
                               message:message
                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:nil];
    [alert addAction:ok];
    return alert;
}

+(UIAlertController *) createAlertWithMsg:(NSString *) message withTitle:(NSString *) title withConfirmBtnTitle:(NSString *)confirmButon {
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:title
                               message:message
                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:confirmButon style:UIAlertActionStyleDefault
                                               handler:nil];
    [alert addAction:ok];
    return alert;
}

@end
