#import <XCTest/XCTest.h>
#import "Consts.h"
#import "SLData.h"

@interface GuidanceUITests : XCTestCase

@end

@implementation GuidanceUITests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    // In UI tests it is usually best to stop immediately when a failure occurs. lat="52.216070" lon="20.961180"
    self.continueAfterFailure = NO;
    XCUIApplication *app = [[XCUIApplication alloc] init];
    NSDictionary<NSString* , NSString*>* envs =@{@"url":@"iOSShareLocation://?latitude=52.216070&longitude=20.961180&tokens=500111222,test@test.pl"};
    [app setLaunchEnvironment:envs];
    [app launch];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testStory1_ShareLocationWindowShouldPresentLocationPoint {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *label =  app.staticTexts[@"aprox 10 meters"];
    NSPredicate *exists = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:exists evaluatedWithObject:label handler:nil];
    [self waitForExpectationsWithTimeout:48 handler:nil];
}

- (void)testStory2_LocationWindowNaviAlterWithActionWalk {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.toolbars.buttons[@"Play"] tap];
    [app.alerts[@"Navigation"].collectionViews.buttons[@"Walk"] tap];

}

- (void)testStory3_LocationWindowNaviAlterWithActionDrive {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.toolbars.buttons[@"Play"] tap];
    [app.alerts[@"Navigation"].collectionViews.buttons[@"Drive"] tap];
}

- (void)testStory4_LocationWindowNaviAlterWithActionDrive {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.toolbars.buttons[@"Play"] tap];
    [app.alerts[@"Navigation"].collectionViews.buttons[@"Transit"] tap];
}

@end
