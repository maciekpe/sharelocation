//
//  Share_LocationUITests.m
//  Share LocationUITests
//
//  Created by mpe-station on 22.10.2015.
//  Copyright © 2015 outbox. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Consts.h"

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

/*
 
 
 [app.alerts[@"Allow \U201cShare Location\U201d to access your location even when you are not using the app?"].collectionViews.buttons[@"Allow"] tap];
 [app.toolbars.buttons[@"Compose"] tap];
 */

- (void)testStory1_LocationWindowExitAlterWithActionOk {
    // Use recording to get started writing UI tests.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [self goFromLocationWindowToExitAlert:app];
    [app.alerts[LABEL_CONFIRMATION].collectionViews.buttons[LABEL_OK] tap];
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testStory2_LocationWindowExitAlterWithActionChancel {
    // Use recording to get started writing UI tests.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [self goFromLocationWindowToExitAlert: app];
    [app.alerts[LABEL_CONFIRMATION].collectionViews.buttons[LABEL_CANCEL] tap];
    XCTAssertEqualObjects(app.navigationBars.element.identifier, LABEL_LOCATION);
}

- (void)testStory3_ShareLocationWindowActionsOnSwitchShouldGenerateUserDataChenges {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [self goFromLocationWindowToMessageWindow: app];
    
    XCUIElementQuery *elementsQuery = app.scrollViews.otherElements;
    
    XCUIElement *modeSwitch = elementsQuery.switches[@"modeSwitch"];
    XCUIElement *userdatafieldTextField = elementsQuery.textFields[@"userDataField"];
    
    XCTAssertEqual(elementsQuery.staticTexts[LABEL_ADDRESS].exists, TRUE, @"Address label not found");
    XCTAssertEqual(elementsQuery.textFields[LABEL_PH_ADDRESS].exists, TRUE, @"Address placeholder not found");
    [userdatafieldTextField tap];
    [userdatafieldTextField typeText:@"test@email.com"];
    [modeSwitch tap];
    XCTAssertEqual(elementsQuery.staticTexts[LABEL_PHONE_NUMBER].exists, TRUE, @"Phone label not found");
    XCTAssertEqual(elementsQuery.textFields[LABEL_PH_PHONE_NUMBER].exists, TRUE, @"Phone placeholder not found");
    [userdatafieldTextField tap];
    [userdatafieldTextField typeText:@"600111222"];
    [modeSwitch tap];
    XCTAssertEqual(elementsQuery.staticTexts[LABEL_ADDRESS].exists, TRUE, @"Address label not found");
    XCTAssertEqual(elementsQuery.textFields[LABEL_PH_ADDRESS].exists, TRUE, @"Address placeholder not found");
}

- (void)testStory4_ShareLocationWindowPrefsAlertShouldAppearOptinally {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    //clear identification
    [self goFromLocationWindowToMessageWindow: app];
    [self atShareLocationWindowClearIdentification: app];
    [self goFromShareLocationWindowToLocationWindow: app];
    // test Information  Alert with idetification info must be visible
    [self goFromLocationWindowToMessageWindow: app withRequiredPrefs: TRUE];
    // test Information  Alert with idetification info must not be visible
    [self atShareLocationWindowAtAlertPrefsSetIdentification: app withValue:@"any"];
    [self goFromShareLocationWindowToLocationWindow: app];
    [self goFromLocationWindowToMessageWindow: app withRequiredPrefs: FALSE];
}

- (void)atShareLocationWindowClearIdentification:(XCUIApplication *) app {
    XCTAssertEqualObjects(app.navigationBars.element.identifier, LABEL_MESSAGE);
    [self atShareLocationWindowAtAlertPrefsSetIdentification: app withValue:nil];
}

- (void)atShareLocationWindowAtAlertPrefsSetIdentification:(XCUIApplication *) app withValue: (NSString *) value {
    XCTAssertEqualObjects(app.navigationBars.element.identifier, LABEL_MESSAGE);
    XCUIElementQuery *toolbarsQuery = app.toolbars;
    [toolbarsQuery.buttons[LABEL_PREF] tap];
    XCTAssertEqual(app.alerts[LABEL_IDENTIFICATION].exists, TRUE, @"Information alert not found");
    XCTAssertEqual(app.alerts[LABEL_IDENTIFICATION].collectionViews.buttons[LABEL_SAVE].exists, TRUE, @"Information alert, save button not found");
    XCUIElementQuery *collectionViewsQuery = app.alerts[LABEL_IDENTIFICATION].collectionViews;
    XCTAssertEqual(collectionViewsQuery.textFields[@"identification"].exists, TRUE, @"Information text field not found");
    XCUIElement *identificationTextField = collectionViewsQuery.textFields[@"identification"];
    [identificationTextField tap];
    [identificationTextField typeText:@"any"];
    [identificationTextField pressForDuration:1.1];
    [app.menuItems[@"Select All"] tap];
    [app.menuItems[@"Cut"] tap];
    if(value != nil){
        [identificationTextField typeText : value];
    }
    XCUIElement *saveButton = collectionViewsQuery.buttons[LABEL_SAVE];
    [saveButton tap];
}

- (void)goFromShareLocationWindowToLocationWindow:(XCUIApplication *) app {
    XCTAssertEqualObjects(app.navigationBars.element.identifier, LABEL_MESSAGE);
    [app.navigationBars[LABEL_MESSAGE].buttons[LABEL_LOCATION] tap];
    XCTAssertEqualObjects(app.navigationBars.element.identifier, LABEL_LOCATION);
}

- (void)goFromLocationWindowToExitAlert:(XCUIApplication *) app {
    XCTAssertEqualObjects(app.navigationBars.element.identifier, LABEL_LOCATION);
    [app.toolbars.buttons[LABEL_STOP] tap];
    XCTAssertEqual(app.alerts[LABEL_CONFIRMATION].exists, TRUE, @"Confirmation alert not found");
}

- (void)goFromLocationWindowToMessageWindow:(XCUIApplication *) app withRequiredPrefs: (BOOL) isRequiredPrefs {
    XCTAssertEqualObjects(app.navigationBars.element.identifier, LABEL_LOCATION);
    [app.toolbars.buttons[LABEL_COMPOSE] tap];
    if(isRequiredPrefs){
        XCTAssertEqual(app.alerts[LABEL_INFORMATION].exists, TRUE, @"Information alert not found when required");
    }else{
        XCTAssertEqual(app.alerts[LABEL_INFORMATION].exists, FALSE, @"Information alert found when not required");
    }
    if(app.alerts[LABEL_INFORMATION].exists){
        [app.alerts[LABEL_INFORMATION].collectionViews.buttons[LABEL_CONTINUE] tap];
    }
    XCTAssertEqualObjects(app.navigationBars.element.identifier, LABEL_MESSAGE, @"Message window not found");
    XCUIElementQuery *elementsQuery = app.scrollViews.otherElements;
    XCTAssertEqual(elementsQuery.switches[@"modeSwitch"].exists, TRUE, @"Mode switch not found");
    XCTAssertEqual(elementsQuery.textFields[@"userDataField"].exists, TRUE, @"User data filed not found");
    XCTAssertEqual(elementsQuery.staticTexts[@"userDataLabel"].exists, TRUE, @"User data lable not found");
    XCTAssertEqual(elementsQuery.staticTexts[LABEL_ADDRESS].exists, TRUE, @"Address label not found");
    XCTAssertEqual(elementsQuery.textFields[LABEL_PH_ADDRESS].exists, TRUE, @"Address placeholder not found");
}

- (void)goFromLocationWindowToMessageWindow:(XCUIApplication *) app{
    XCTAssertEqualObjects(app.navigationBars.element.identifier, LABEL_LOCATION);
    [app.toolbars.buttons[LABEL_COMPOSE] tap];
    if(app.alerts[LABEL_INFORMATION].exists){
        [app.alerts[LABEL_INFORMATION].collectionViews.buttons[LABEL_CONTINUE] tap];
    }
    XCTAssertEqualObjects(app.navigationBars.element.identifier, LABEL_MESSAGE, @"Message window not found");
    XCUIElementQuery *elementsQuery = app.scrollViews.otherElements;
    XCTAssertEqual(elementsQuery.switches[@"modeSwitch"].exists, TRUE, @"Mode switch not found");
    XCTAssertEqual(elementsQuery.textFields[@"userDataField"].exists, TRUE, @"User data filed not found");
    XCTAssertEqual(elementsQuery.staticTexts[@"userDataLabel"].exists, TRUE, @"User data lable not found");
    XCTAssertEqual(elementsQuery.staticTexts[LABEL_ADDRESS].exists, TRUE, @"Address label not found");
    XCTAssertEqual(elementsQuery.textFields[LABEL_PH_ADDRESS].exists, TRUE, @"Address placeholder not found");
}

@end
