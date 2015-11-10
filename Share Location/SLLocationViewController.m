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
        _viewMap.showsUserLocation = YES;
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

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) deleteMapAnnotations {
    for (id<MKAnnotation> annotation in _viewMap.annotations){
        [self.viewMap removeAnnotation:annotation];
    }
}


-(void) deleteMapOverlays {
    for (id<MKOverlay> overlay in _viewMap.overlays){
        [self.viewMap removeOverlay:overlay];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"didUpdateLocations ");
    CLLocation* location = [locations lastObject];
    if ([SLData isLocationChangeRevelant:location]) {
        [self.locationService logLocation:location logString:@"Current location "];
        [SLData setCurrentLocation:location];
        MKCoordinateRegion viewRegion;
        if([SLData getMateLocation] != nil){
            viewRegion = [self createViewRegionWithMate];
            [self addPinAndLineFromMateToCurrentLocation];
            [[SoundService getInstance] playDirectionSound];
            
        }else{
            viewRegion = [self createViewRegionWithoutMate];
        }
        [_viewMap setRegion:viewRegion animated:NO];
        [_viewMap setCenterCoordinate:location.coordinate animated:YES];
        NSLog(@"Location stored ");
    }
}

-(MKCoordinateRegion) createViewRegionWithMate {
    MKCoordinateRegion viewRegion = [self.locationService calculateRegionForCurrentAndMateLocations];
    if([self.locationService isRegionNotAdjusted:[_viewMap regionThatFits:viewRegion]]){
        viewRegion.span.latitudeDelta = 90;
        viewRegion.span.longitudeDelta = 180;
    }
    return viewRegion;
}

-(MKCoordinateRegion) createViewRegionWithoutMate {
    MKCoordinateRegion viewRegion = [self.locationService calculateRegionForCurrentLocation];
    return viewRegion;
}

-(void) addPinAndLineFromMateToCurrentLocation {
    [self clearMapAnnotationAndLine];
    SLMapAnnotation *annotation = [self.locationService createMapAnnotationForMate];
    [_viewMap addAnnotation:annotation];
    [_viewMap selectAnnotation:annotation animated:YES];
    [_viewMap addOverlay:[self.locationService createLineBetweenCurrentAndMateLocation]];
}

-(void) clearMapAnnotationAndLine {
    [self deleteMapOverlays];
    [self deleteMapAnnotations];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    return [self.locationService createLineViewWith:overlay];
}

- (IBAction)unwindToMap:(UIStoryboardSegue *)segue {}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if(![annotation isKindOfClass:[SLMapAnnotation class]]){
        return nil;
    }
    MKPinAnnotationView *pinView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier: @"annotationIdentifier"];
    return [self.locationService createAnnotationView:pinView forAnnotation:annotation];
}

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

- (IBAction)goToMessage:(id)sender {
    NSLog(@"Go to Message");
    dispatch_async(dispatch_get_main_queue(), ^(void) {
         NSLog(@"ASYNC Go to Message");
        [self performSegueWithIdentifier: @"msg" sender: self];
    });
}

- (IBAction)doExit {
    UIAlertController *alert = [SLAlertsFactory createExitAlert];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
