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

+(UIAlertController *) createExitAlert {
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Confirmation"
                               message:@"Do you want to exit?"
                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                            //home button press programmatically
                            UIApplication *app = [UIApplication sharedApplication];
                            [app performSelector:@selector(suspend)];
                            [NSThread sleepForTimeInterval:2.0];
                            exit(0);
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    [alert addAction:ok];
    [alert addAction:cancel];
    return alert;
}

@end


