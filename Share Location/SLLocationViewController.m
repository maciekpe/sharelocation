#import "SLLocationViewController.h"
#import "SLAlertsFactory.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SLMapAnnotation.h"
#import "SLPinAnnotationView.h"
#import "SLData.h"
#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SoundService.h"
@import Contacts;

@interface SLLocationViewController ()<UIApplicationDelegate, UIAlertViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *composit;
@property (weak, nonatomic) IBOutlet MKMapView *viewMap;
@end

@implementation SLLocationViewController

CLLocationManager *locationMgr;
NSDate *lastSound;


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    NSLog(@"enter viewDidLoad");
    [super viewDidLoad];
    _viewMap.delegate = self;

    [self initLocationManager];
    [self initContacts];
    NSLog(@"end viewDidLoad");
}

- (void) initLocationManager {
    NSLog(@"enter initLocationManager start");
    if([SLData getCurrentLocation] == nil){
        locationMgr =[[CLLocationManager alloc] init];
        locationMgr.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        locationMgr.distanceFilter = 10;
        locationMgr.delegate = self;
        [locationMgr requestAlwaysAuthorization];
        [locationMgr startUpdatingLocation];
        NSLog(@"end initLocationManager started");
    }else{
        NSLog(@"end initLocationManager skip ");
    }
}

- (void) initContacts {
    //dobrobic obsluge zmiany statusu
    NSLog(@"enter initContacts start");
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    NSLog(@"status initContacts %ld", (long) status);
    if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusDenied) {
        UIAlertController *alert = [SLAlertsFactory createAlertWithMsg:@"This app previously was refused permissions to contacts; Please go to settings and grant permission to this app so it can add the desired contact." withTitle:@"Information" withConfirmBtnTitle:@"OK"];
        [self presentViewController:alert animated:TRUE completion:nil];
    }
}

- (void)initSound:(NSString *) pathToFile sound: (SystemSoundID *) soundID {
    NSString* path = [[NSBundle mainBundle] pathForResource:pathToFile ofType:@"wav"];
    NSURL* url = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, soundID);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//##############################################

/*
 Akcja powrotu do mapy.
 */
- (IBAction)unwindToMap:(UIStoryboardSegue *)segue {}

/*
 Loguje lokacje.
 */
- (void) logLocation: (CLLocation *) location logString:(NSString *) log {

    NSString *logString = @"Location : ";
    NSNumber *longtitude = [NSNumber numberWithDouble:location.coordinate.longitude];
    NSNumber *latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
    logString = [logString stringByAppendingString: @" latitude=" ];
    logString = [logString stringByAppendingString: [latitude stringValue] ];
    logString = [logString stringByAppendingString: @" longitude=" ];
    logString = [logString stringByAppendingString: [longtitude stringValue] ];
    NSLog(@"%@",logString);
}




- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if(![annotation isKindOfClass:[SLMapAnnotation class]]){
        return nil;
    }
    NSString *annotationIdentifier = @"annotationIdentifier";

    MKPinAnnotationView *pinView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    if (!pinView)
    {
        pinView = [[SLPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        UIImage *img = nil;
        if([SLData getImage] != nil){
            img = [SLData getImage];
        }else{
            img = [UIImage imageNamed:@"multimedia/pics/target.jpg"];
        }
        UIImageView *houseIconView = [[UIImageView alloc] initWithImage:img];
        [houseIconView setFrame:CGRectMake(0, 0, 30, 30)];
        pinView.leftCalloutAccessoryView = houseIconView;
    }
    else
    {
        pinView.annotation = annotation;
    }
    return pinView;

}


/*
 Dodaje PINa do mapy.
 */
-(void) addPinFromCurrentLocation:(CLLocation *) location withTitle:(NSString *) title fromBaseLocation: (CLLocation *) baseLocation{
    if(location != nil){
        
        [self deleteMapOverlays];
        [self deleteMapAnnotations];
        
        CLLocationCoordinate2D pinLocation = location.coordinate;
        CLLocationDistance distance = [baseLocation distanceFromLocation:location];
        double calculatedDistance = distance * 2.5;
        NSLog(@" calculatedDistance %.0f", calculatedDistance);
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(baseLocation.coordinate, calculatedDistance, calculatedDistance);
        
        //obsluga zbyt duzego dystansu
        MKCoordinateRegion adjustedRegion = [_viewMap regionThatFits:viewRegion];
        if(isnan(adjustedRegion.span.latitudeDelta) || isnan(adjustedRegion.span.longitudeDelta)){
            viewRegion.span.latitudeDelta = 90;
            viewRegion.span.longitudeDelta = 180;
        }
        [_viewMap setRegion:viewRegion animated:NO];
        [_viewMap setCenterCoordinate:baseLocation.coordinate animated:YES];
        
        NSMutableString *userTitle = [[NSMutableString alloc] init];
        [userTitle appendString:title];
        NSString *title = @"Destination";
        if([SLData getNameString] != nil){
            title = [SLData getNameString];
        }
        SLMapAnnotation *annotation =
        [[SLMapAnnotation alloc] initWithCoordinates:pinLocation
                                               title:title subTitle:userTitle];
        
        [_viewMap addAnnotation:annotation];
        [_viewMap selectAnnotation:annotation animated:YES];
        CLLocationCoordinate2D coordinates[2];
        coordinates[0] = location.coordinate;
        coordinates[1] = baseLocation.coordinate;
        MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:2];
        [_viewMap addOverlay:polyLine];
        
        
        
        }
}

/*
 Wylicza string okreslajacy odleglosc punktu na podstawie dystansu.
 */
- (NSString *) getDistanceString:(CLLocationDistance) distance{
    NSString *title = @"";
    if(distance > 1000){
        title = [title stringByAppendingString : [NSString stringWithFormat:@"%.2f kilometers", distance/1000]];
    }else{
        title = [title stringByAppendingString : [NSString stringWithFormat:@"%.0f meters", distance]];
    }
    return title;
}

/*
 Obsluga chwilowego pokazania callouta wlasne aktualizacji.
 */
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
    for (aV in views) {
        aV.canShowCallout = YES;
        if (![aV.annotation isKindOfClass:[SLMapAnnotation class]]) {
            ((MKUserLocation *)aV.annotation).title = @"Your's current location";
            [aV setSelected:YES];
            [self.viewMap selectAnnotation:aV.annotation animated:YES];
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self.viewMap selectAnnotation:aV.annotation animated:YES];
            });
        }
    }
}

-(void)deleteMapAnnotations
{
    for (id<MKAnnotation> annotation in _viewMap.annotations){
        [self.viewMap removeAnnotation:annotation];
    }
}


-(void)deleteMapOverlays
{
    for (id<MKOverlay> overlay in _viewMap.overlays){
        [self.viewMap removeOverlay:overlay];
    }
}

/*
 Metoda delagata MKMapViewDelegate
 */
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    SoundService* soundService = [SoundService getInstance];
    if([SLData isDistanceShorter]){
        if([self playProgressSound]){
            [soundService playCorrectDirectionSound];
        }
        polylineView.strokeColor = [UIColor greenColor];
    }else{
        if([self playProgressSound]){
            [soundService playIncorrectDirectionSound];
        }
        polylineView.strokeColor = [UIColor redColor];
    }
    polylineView.lineWidth = 4.0;
    NSArray* array = [NSArray arrayWithObjects:[NSNumber numberWithInt:10], [NSNumber numberWithInt:10], nil];
    polylineView.lineDashPattern = array;
    return polylineView;
}

/*
 Okresla czy ma ma byc wykonana sygnalizacja dzwiekowa
 */
-(bool) playProgressSound{
    NSDate *now = [NSDate date];
    if(lastSound !=nil){
            if( [now timeIntervalSinceDate:lastSound] > 5 ) {
                lastSound = now;
                return YES;
            }else{
                 return NO;
            }
    }else{
        lastSound = now;
        return YES;
    }
}



/*
 Obsługa update lokalizacji.
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"didUpdateLocations ");
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 15.0 && ([SLData getCurrentLocation]==nil || [location distanceFromLocation:[SLData getCurrentLocation]] >10)) {
        [self logLocation:location logString:@"Current location "];
        [SLData setCurrentLocation:location];
        _viewMap.showsUserLocation = YES;
        if([SLData getMateLocation] != nil){
            CLLocationDistance distance = [location distanceFromLocation:[SLData getMateLocation]];
            NSString *title = [self getDistanceString:distance];
            [self addPinFromCurrentLocation:[SLData getMateLocation] withTitle:title fromBaseLocation:location];
        }else{
            CLLocationCoordinate2D zoomLocation = location.coordinate;
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 600, 600);
            
            [_viewMap setRegion:viewRegion animated:NO];
            [_viewMap setCenterCoordinate:zoomLocation animated:YES];
        }
        NSLog(@"Location stored ");
    }
}


//###############################################
- (IBAction)goToMessage:(id)sender {
    NSLog(@"Go to Message");
    dispatch_async(dispatch_get_main_queue(), ^(void) {
         NSLog(@"ASYNC Go to Message");
        [self performSegueWithIdentifier: @"msg" sender: self];
    });
}

/*
 Akcja wyjścia z aplikacji.
 */
-(IBAction)doExit
{
    UIAlertController *alert = [SLAlertsFactory createExitAlert];
    [self presentViewController:alert animated:YES completion:nil];
}

//###############################################
@end
