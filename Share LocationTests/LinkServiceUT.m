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

- (void)testThat_DecomposeLinkWhenDataPresent {
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


@end
