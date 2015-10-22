//
//  Share_LocationUITests.m
//  Share LocationUITests
//
//  Created by mpe-station on 22.10.2015.
//  Copyright © 2015 outbox. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Share_LocationUITests : XCTestCase

@end

@implementation Share_LocationUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExitOk {
    // Use recording to get started writing UI tests.
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    NSLog(@"XXX log: '%@'", app.navigationBars.element.identifier );
    XCTAssertEqualObjects(app.navigationBars.element.identifier, @"Location");
    //XCTAssertEqual([app title], @"Location", @"Location not found");
    [app.toolbars.buttons[@"Stop"] tap];
    [app.alerts[@"Confirmation"].collectionViews.buttons[@"OK"] tap];
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testExitChancel {
    // Use recording to get started writing UI tests.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCTAssertEqualObjects(app.navigationBars.element.identifier, @"Location");
    [app.toolbars.buttons[@"Stop"] tap];
    XCTAssertEqual(app.alerts[@"Confirmation"].exists, TRUE, @"found Confirmation alert");
    [app.alerts[@"Confirmation"].collectionViews.buttons[@"Cancel"] tap];
    XCTAssertTrue([app exists], @"App do not exit");

}

@end
