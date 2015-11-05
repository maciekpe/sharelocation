#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#import "IdentificationService.h"
#import "Consts.h"

@interface IdentificationServiceUT : XCTestCase

@end

@implementation IdentificationServiceUT

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThat_getUserIdentificationIsNil {
    //given
    NSUserDefaults* userDefaults = mock([NSUserDefaults class]);
    [given([userDefaults stringForKey:SL_UID])  willReturn:nil];
    IdentificationService* identificationService = [[IdentificationService alloc] initWithUserDefaults:userDefaults];
    //when
    NSString* result = [identificationService getUserIdentification];
    
    //then
    assertThat(result,nilValue());
}

- (void)testThat_getUserIdentificationIsNotEmpty {
    //given
    NSUserDefaults* userDefaults = mock([NSUserDefaults class]);
    [given([userDefaults stringForKey:SL_UID])  willReturn:@"value"];
    IdentificationService* identificationService = [[IdentificationService alloc] initWithUserDefaults:userDefaults];
    //when
    NSString* result = [identificationService getUserIdentification];
    
    //then
    assertThat(result,equalTo(@"value"));
}

- (void)testThat_isUserIdentificationEmptyWhenNil {
    //given
    NSUserDefaults* userDefaults = mock([NSUserDefaults class]);
    [given([userDefaults stringForKey:SL_UID])  willReturn:nil];
    IdentificationService* identificationService = [[IdentificationService alloc] initWithUserDefaults:userDefaults];
    //when
    BOOL result = [identificationService isUserIdentificationEmpty];
    
    //then
    assert(result);
}

- (void)testThat_isUserIdentificationEmptyWhenEmptyString {
    //given
    NSUserDefaults* userDefaults = mock([NSUserDefaults class]);
    [given([userDefaults stringForKey:SL_UID])  willReturn:@" "];
    IdentificationService* identificationService = [[IdentificationService alloc] initWithUserDefaults:userDefaults];
    //when
    BOOL result = [identificationService isUserIdentificationEmpty];
    
    //then
    assert(result);
}

- (void)testThat_isUserIdentificationNotEmpty {
    //given
    NSUserDefaults* userDefaults = mock([NSUserDefaults class]);
    [given([userDefaults stringForKey:SL_UID])  willReturn:@"value"];
    IdentificationService* identificationService = [[IdentificationService alloc] initWithUserDefaults:userDefaults];
    //when
    BOOL result = [identificationService isUserIdentificationEmpty];
    
    //then
    assert(!result);
}

@end
