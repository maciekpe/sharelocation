#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SLAlertsFactory : NSObject
+ (SLAlertsFactory*) getInstance;
+ (UIAlertController *) createErrorAlert:(NSString *) message;
+ (UIAlertController *) createAlertWithMsg:(NSString *) message
                                withTitle:(NSString *) title
                                withConfirmBtnTitle:(NSString *) confirmButon;
@end
