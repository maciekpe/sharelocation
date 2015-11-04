#import <XCTest/XCTest.h>
#import "LinkService.h"
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#import "Consts.h"

@interface LinkServiceUT : XCTestCase

@end

@implementation LinkServiceUT

LinkService *linkService ;

- (void)setUp {
    [super setUp];
    linkService = [LinkService getInstance];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThat_DecomposeLinkWhenAllDataPresent {
    //given
    NSURL* url = [[NSURL alloc] initWithString:@"iOSShareLocation://?latitude=12.11111&longitude=13.11111&tokens=500111222,test@test.pl"];
    
    //when
    LinkData* result = [linkService decomposeLinkDataFromUrl:url];
    
    //then
    assertThat([result latitudeValue], equalTo(@"12.11111"));
    assertThat([result longitudeValue], equalTo(@"13.11111"));
    assertThat([result primaryContactToken], equalTo(@"500111222"));
    assertThat([result secondaryContactToken], equalTo(@"test@test.pl"));
}

- (void)testThat_DecomposeLinkWhenOneContactTokenPresent {
    //given
    NSURL* url = [[NSURL alloc] initWithString:@"iOSShareLocation://?latitude=12.11111&longitude=13.11111&tokens=500111222"];
    
    //when
    LinkData* result = [linkService decomposeLinkDataFromUrl:url];
    
    //then
    assertThat([result latitudeValue], equalTo(@"12.11111"));
    assertThat([result longitudeValue], equalTo(@"13.11111"));
    assertThat([result primaryContactToken], equalTo(@"500111222"));
}

- (void)testThat_DecomposeLinkWhenNoContactTokenPresent {
    //given
    NSURL* url = [[NSURL alloc] initWithString:@"iOSShareLocation://?latitude=12.11111&longitude=13.11111"];
    
    //when
    LinkData* result = [linkService decomposeLinkDataFromUrl:url];
    
    //then
    assertThat([result latitudeValue], equalTo(@"12.11111"));
    assertThat([result longitudeValue], equalTo(@"13.11111"));
}

- (void)testThat_ThrowsExceptionDecomposeLinkWhenNoLatitudeParam {
    //given
    NSURL* url = [[NSURL alloc] initWithString:@"iOSShareLocation://?longitude=13.11111"];
    
    //expect
    XCTAssertThrows([linkService decomposeLinkDataFromUrl:url],@"Expect exception when no latitude");
}

- (void)testThat_ThrowsExceptionDecomposeLinkWhenNoLongitudeParam {
    //given
    NSURL* url = [[NSURL alloc] initWithString:@"iOSShareLocation://?latitude=12.11111"];
    
    //expect
    XCTAssertThrows([linkService decomposeLinkDataFromUrl:url],@"Expect exception when no longtude");
}

- (void)testThat_ThrowsExceptionDecomposeLinkWhenNoParams {
    //given
    NSURL* url = [[NSURL alloc] initWithString:@"iOSShareLocation://"];
    
    //expect
    XCTAssertThrows([linkService decomposeLinkDataFromUrl:url],@"Expect exception no params");
}
@end
