#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#import "SoundService.h"

#import <XCTest/XCTest.h>

@interface SoundServiceUT : XCTestCase

@end

@implementation SoundServiceUT

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThat_playDirectionSoundDirectionForYES {
    //given
    SoundService* soundService = [SoundService getInstance];
    soundService.lastSoundDate = nil;
    //then
    BOOL result = [soundService playDirectionSoundWith:YES];
    //then
    assertThatBool(result, isTrue());
}

- (void)testThat_playDirectionSoundDirectionForNO {
    //given
    SoundService* soundService = [SoundService getInstance];
    soundService.lastSoundDate = nil;
    //then
    BOOL result = [soundService playDirectionSoundWith:NO];
    //then
    assertThatBool(result, isTrue());
}

- (void)testThat_willNotPlayDirectionSoundDirection_NONO_Before5SecondDelay {
    //given
    SoundService* soundService = [SoundService getInstance];
    soundService.lastSoundDate = nil;
    //given
    BOOL result = [soundService playDirectionSoundWith:NO];
    //then
    result = [soundService playDirectionSoundWith:NO];
    //then
    assertThatBool(result, isFalse());
}

- (void)testThat_willPlayDirectionSoundDirection_NONO_After5SecondDelay {
    //given
    //given
    SoundService* soundService = [SoundService getInstance];
    soundService.lastSoundDate = nil;
    BOOL result = [soundService playDirectionSoundWith:NO];
    sleep(5);
    //then
    result = [soundService playDirectionSoundWith:NO];
    //then
    assertThatBool(result, isTrue());
}
@end
