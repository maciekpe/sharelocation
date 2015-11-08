#import <XCTest/XCTest.h>

@interface GuidanceUITests : XCTestCase

@end

@implementation GuidanceUITests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    XCUIApplication *app = [[XCUIApplication alloc] init];
    NSDictionary<NSString* , NSString*>* envs =@{@"url":@"iOSShareLocation://?latitude=53.275034&longitude=20.795628&tokens=500111222,test@test.pl"};
    [app setLaunchEnvironment:envs];
    [app launch];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testStory1_ShareLocationWindowShouldPresentLocationPoint {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *element = app.otherElements[@"PopoverDismissRegion"];
    sleep(10);
    XCTAssertEqual(element.exists, TRUE, @"point not found");
}

@end
