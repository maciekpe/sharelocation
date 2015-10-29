#import <XCTest/XCTest.h>
#import "ContactsService.h"
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface ContactsServiceUT : XCTestCase

@end

@implementation ContactsServiceUT

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testThat_GetMateImageReturnNilWhenArgumentIsNil {
    //given
    CNContactStore *contactStore = mock([CNContactStore class]);
    ContactsService *contactsService = [[ContactsService alloc] initWithContactStore:contactStore];
    //when
    UIImage *result = [contactsService getMateImage:nil];
    //then
    assertThat(result, nilValue());
}

- (void)testThat_ThrowsExceptionWhenNilPassedToInit {
    //expect
    XCTAssertThrows([[ContactsService alloc] initWithContactStore:nil],@"Expect exception for nil contact store");
}

- (void)testThat_GetMateImageReturnNilWhenArgumentIsEmptyArray {
    //given
    CNContactStore *contactStore = mock([CNContactStore class]);
    ContactsService *contactsService = [[ContactsService alloc] initWithContactStore:contactStore];
    NSMutableArray<CNContact*>* filleredContacts  = [[NSMutableArray alloc] init];
    //when
    UIImage *result = [contactsService getMateImage:filleredContacts];
    //then
    assertThat(result, nilValue());
}

@end
