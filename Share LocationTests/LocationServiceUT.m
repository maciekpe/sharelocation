#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#import "LocationService.h"
#import <XCTest/XCTest.h>

@interface LocationServiceUT : XCTestCase

@end

@implementation LocationServiceUT

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThat_calculateRegionForCurrentAndMateLocations {
    LocationService* locationService = [LocationService getInstance];
    CLLocationDegrees latitude = 53.275034;
    CLLocationDegrees longitude = 20.795628;
    CLLocation* locationOne = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLLocation* locationTwo = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude + 0.01];
    [locationService.locationData setMateLocation:locationTwo];
    [locationService.locationData setCurrentLocation:locationOne];
    
    MKCoordinateRegion viewRegion = [locationService calculateRegionForCurrentAndMateLocations];
    XCTAssert(viewRegion.center.latitude == latitude);
    XCTAssert(viewRegion.center.longitude == longitude);
    XCTAssert(viewRegion.span.latitudeDelta > 0);
    XCTAssert(viewRegion.span.latitudeDelta > 0);
}

- (void)testThat_calculateRegionForCurrentLocation {
    LocationService* locationService = [LocationService getInstance];
    CLLocationDegrees latitude = 53.275034;
    CLLocationDegrees longitude = 20.795628;
    CLLocation* locationOne = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    [locationService.locationData setCurrentLocation:locationOne];
    
    MKCoordinateRegion viewRegion = [locationService calculateRegionForCurrentLocation];
    XCTAssert(viewRegion.center.latitude == latitude);
    XCTAssert(viewRegion.center.longitude == longitude);
    XCTAssert(viewRegion.span.latitudeDelta > 0);
    XCTAssert(viewRegion.span.latitudeDelta > 0);
}

- (void)testThat_isRegionNotAdjusted {
    LocationService* locationService = [LocationService getInstance];
    CLLocationDegrees latitude = 53.275034;
    CLLocationDegrees longitude = 20.795628;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude,longitude);
    MKCoordinateRegion viewRegion = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(NAN, NAN));
    
    XCTAssert([locationService isRegionNotAdjusted:viewRegion]);
}

- (void)testThat_isRegionAdjusted {
    //given
    LocationService* locationService = [LocationService getInstance];
    CLLocationDegrees latitude = 53.275034;
    CLLocationDegrees longitude = 20.795628;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude,longitude);
    MKCoordinateRegion viewRegion = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.01, 0.01));
    
    //when
    BOOL result = [locationService isRegionNotAdjusted:viewRegion];
    
    //then
    assertThatBool(result, isFalse());
}

- (void)testThat_createMapAnnotationForMate {
    //given
    LocationService* locationService = [LocationService getInstance];
    CLLocationDegrees latitude = 53.275034;
    CLLocationDegrees longitude = 20.795628;
    CLLocation* locationOne = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLLocation* locationTwo = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude + 0.01];
    [locationService.locationData setMateLocation:locationTwo];
    [locationService.locationData setCurrentLocation:locationOne];
    
    //when
    SLMapAnnotation* mapAnnotation = [locationService createMapAnnotationForMate];
    
    //then
    assertThat(mapAnnotation, notNilValue());
    assertThat(mapAnnotation.title, equalTo(@"Destination"));
    assertThat(mapAnnotation.subtitle, equalTo(@"667 meters"));
    XCTAssert(mapAnnotation.coordinate.latitude == latitude);
    XCTAssert(mapAnnotation.coordinate.longitude == longitude + 0.01);
}

- (void)testThat_createLineBetweenCurrentAndMateLocation {
    //given
    LocationService* locationService = [LocationService getInstance];
    CLLocationDegrees latitude = 53.275034;
    CLLocationDegrees longitude = 20.795628;
    CLLocation* locationOne = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLLocation* locationTwo = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude + 0.01];
    [locationService.locationData setMateLocation:locationTwo];
    [locationService.locationData setCurrentLocation:locationOne];
    
    //when
    MKPolyline* polyLine = [locationService createLineBetweenCurrentAndMateLocation];
    
    //then
    assertThat(polyLine, notNilValue());
    XCTAssert(polyLine.pointCount == 2);
}

- (void)testThat_createAnnotationView {
    //given
    LocationService* locationService = [LocationService getInstance];
    MKPinAnnotationView* annotationView = mock([MKPinAnnotationView class]);
    id <MKAnnotation> annotation = mockProtocol(@protocol(MKAnnotation));
    
    //when
    MKPinAnnotationView* pinAnnotationView = [locationService createAnnotationView:annotationView forAnnotation:annotation];
    
    //then
    assertThat(pinAnnotationView, notNilValue());
    assertThat(pinAnnotationView.image, notNilValue());
    assertThat(pinAnnotationView.reuseIdentifier, equalTo(@"annotationIdentifier"));
}

- (void)testThat_createLocationManager {
    //given
    LocationService* locationService = [LocationService getInstance];
    
    //when
    CLLocationManager* locationManager = [locationService createLocationManager];
    
    //then
    assertThat(locationManager, notNilValue());
    XCTAssert(locationManager.desiredAccuracy == kCLLocationAccuracyNearestTenMeters);
    XCTAssert(locationManager.distanceFilter == 10);
}

- (void)testThat_createLineViewWithDistanceShorter {
    //given
    LocationService* locationService = [LocationService getInstance];
    MKPolyline* polyLine = mock([MKPolyline class]);
    CLLocationDegrees latitude = 53.275034;
    CLLocationDegrees longitude = 20.795628;
    CLLocation* locationOne = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLLocation* locationTwo = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude + 0.02];
    CLLocation* locationThree = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude + 0.01];
    [locationService.locationData setMateLocation:locationTwo];
    [locationService.locationData setCurrentLocation:locationOne];
    [locationService.locationData setCurrentLocation:locationThree];
    
    //when
    MKPolylineRenderer* overlay = [locationService createLineViewWith:polyLine];
    
    //then
    assertThat(overlay, notNilValue());
    XCTAssert(overlay.strokeColor == [UIColor greenColor]);
    XCTAssert(overlay.lineWidth == 4.0);
    XCTAssert(overlay.lineDashPattern.count == 2);
}

- (void)testThat_createLineViewWithDistanceFurther {
    //given
    LocationService* locationService = [LocationService getInstance];
    MKPolyline* polyLine = mock([MKPolyline class]);
    CLLocationDegrees latitude = 53.275034;
    CLLocationDegrees longitude = 20.795628;
    CLLocation* locationOne = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLLocation* locationTwo = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude - 0.01];
    CLLocation* locationThree = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude + 0.02];
    [locationService.locationData setMateLocation:locationThree];
    [locationService.locationData setCurrentLocation:locationOne];
    [locationService.locationData setCurrentLocation:locationTwo];
    
    //when
    MKPolylineRenderer* overlay = [locationService createLineViewWith:polyLine];
    
    //then
    assertThat(overlay, notNilValue());
    assertThat(overlay.strokeColor, equalTo([UIColor redColor]));
    XCTAssertTrue(overlay.lineWidth == 4.0);
    XCTAssertTrue(overlay.lineDashPattern.count == 2);
}

@end
