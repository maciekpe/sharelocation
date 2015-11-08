#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocationService.h"
@interface SLLocationViewController : UIViewController
- (IBAction)unwindToMap:(UIStoryboardSegue *)segue;
@property (nonatomic, strong, readonly) LocationService* locationService;
@property (nonatomic, strong, readonly) CLLocationManager* locationMgr;
@end