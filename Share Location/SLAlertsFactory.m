#import <Foundation/Foundation.h>
#import "SLAlertsFactory.h"
#import "Consts.h"
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
                               alertControllerWithTitle:LABEL_ERROR
                               message:message
                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:LABEL_OK style:UIAlertActionStyleDefault
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
                               alertControllerWithTitle:LABEL_CONFIRMATION
                               message:LABEL_EXIT_QUESTION
                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:LABEL_OK
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
                             actionWithTitle:LABEL_CANCEL
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    [alert addAction:ok];
    [alert addAction:cancel];
    return alert;
}

+ (UIAlertController *) createEmptyAlert:(NSString *) message withTitle:(NSString *) title {
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:title
                               message:message
                               preferredStyle:UIAlertControllerStyleAlert];
    return alert;
}

@end
