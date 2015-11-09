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
    _locationService = [[LocationService alloc] init];
    NSLog(@"enter initLocationManager start");
    if([SLData getCurrentLocation] == nil){
        _locationMgr = [self.locationService createLocationManager];
        self.locationMgr.delegate = self;
        [self.locationMgr startUpdatingLocation];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//##############################################


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
 Obsługa update lokalizacji.
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"didUpdateLocations ");
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 15.0 && ([SLData getCurrentLocation]==nil || [location distanceFromLocation:[SLData getCurrentLocation]] >10)) {
        [self.locationService logLocation:location logString:@"Current location "];
        [SLData setCurrentLocation:location];
        _viewMap.showsUserLocation = YES;
        if([SLData getMateLocation] != nil){
            CLLocationDistance distance = [location distanceFromLocation:[SLData getMateLocation]];
            NSString *title = [self.locationService getDistanceString:distance];
            
            //
            [self addPinFromCurrentLocation:[SLData getMateLocation] withTitle:title fromBaseLocation:location];
            //
            
        }else{
            CLLocationCoordinate2D zoomLocation = location.coordinate;
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 600, 600);
            
            [_viewMap setRegion:viewRegion animated:NO];
            [_viewMap setCenterCoordinate:zoomLocation animated:YES];
        }
        NSLog(@"Location stored ");
    }
}

/*
 Dodaje PINa do mapy.
 */
-(void) addPinFromCurrentLocation:(CLLocation *) location withTitle:(NSString *) title fromBaseLocation: (CLLocation *) baseLocation{
    if(location != nil){
        
        //
        [self deleteMapOverlays];
        //
        
        //
        [self deleteMapAnnotations];        
        //
        
        //
        MKCoordinateRegion viewRegion = [self.locationService calculateRegionWithBase:location withRemote:baseLocation];
        if([self.locationService isRegionNotAdjusted:[_viewMap regionThatFits:viewRegion]]){
            viewRegion.span.latitudeDelta = 90;
            viewRegion.span.longitudeDelta = 180;
        }
        [_viewMap setRegion:viewRegion animated:NO];
        [_viewMap setCenterCoordinate:baseLocation.coordinate animated:YES];
        //
        
        //
        SLMapAnnotation *annotation = [self.locationService createMapAnnotationWith:location.coordinate withTitle:title];
        [_viewMap addAnnotation:annotation];
        [_viewMap selectAnnotation:annotation animated:YES];
        //
        
        //
        [_viewMap addOverlay:[self.locationService createLineWithBase:location withRemote:baseLocation]];
        //
    }
}

/*
 Metoda delagata MKMapViewDelegate
 */
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    SoundService* soundService = [SoundService getInstance];
    if([SLData isDistanceShorter]){
        [soundService playCorrectDirectionSound];
        polylineView.strokeColor = [UIColor greenColor];
    }else{
        [soundService playIncorrectDirectionSound];
        polylineView.strokeColor = [UIColor redColor];
    }
    polylineView.lineWidth = 4.0;
    NSArray* array = [NSArray arrayWithObjects:[NSNumber numberWithInt:10], [NSNumber numberWithInt:10], nil];
    polylineView.lineDashPattern = array;
    return polylineView;
}

/*
 Akcja powrotu do mapy.
 */
- (IBAction)unwindToMap:(UIStoryboardSegue *)segue {}

// po dodaniu anotacji
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
