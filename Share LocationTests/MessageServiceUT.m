#import <XCTest/XCTest.h>
#import "LinkService.h"
#import "MessageService.h"
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#import <MapKit/MapKit.h>

@interface MessageServiceUT : XCTestCase

@end

@implementation MessageServiceUT

MessageService* messageService;
CLLocation* location;

- (void)setUp {
    [super setUp];
    LinkService* linkService = mock([LinkService class]);
    CLLocationDegrees longitude = 2.313224;
    CLLocationDegrees latitude = 2.313224;
    location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    [given([linkService composeLinkWithLocation:location])  willReturn:@"http://test.location"];
    messageService = [[MessageService alloc] initWithLinkService:linkService];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThat_composeHtmlAttributedMessageWithLocation {
    //when
    NSAttributedString *result = [messageService composeHtmlAttributedMessageWithLocation:location];
    
    //then
    assertThat([result string],equalTo(@"Hi,\nHere I am !!!\nPlease click this location link"));
    
}

- (void)testThat_composeHtmlStringMessageWithLocation {
    //when
    NSString *result = [messageService composeHtmlStringMessageWithLocation:location];
    
    //then
    assertThat(result,equalTo(@"<em>Hi,</em><br/><em>Here I am !!!</em><br/><em>Please click this <a href=\"https://maps.google.com/maps?q=2.313224,2.313224\">location link</a></em><br/><a href=\"http://test.location\">correlation link</a></em>\n"));
    
}

- (void)testThat_composeStringMessageWithLocation {
    //when
    NSString *result = [messageService composeStringMessageWithLocation:location];
    
    //then
    assertThat(result,equalTo(@"Hi,\nHere I am !!!\n Please click this link https://maps.google.com/maps?q=2.313224,2.313224\n correlation link http://test.location"));
    
}
@end
