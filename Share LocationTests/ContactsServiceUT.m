#import <XCTest/XCTest.h>
#import "ContactsService.h"
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#import "Consts.h"

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

- (void)testThat_GetMateImage {
    //given
    CNContactStore *contactStore = mock([CNContactStore class]);
    ContactsService *contactsService = [[ContactsService alloc] initWithContactStore:contactStore];
    NSMutableArray<CNContact*>* filleredContacts  = mock([NSMutableArray class]);
    CNContact *contact = mock([ CNContact class]);
    NSData *inputData = [self getPictureData];
    
    [given([contact imageDataAvailable]) willReturnBool:TRUE];
    [given([contact imageData]) willReturn:inputData];
    [given([filleredContacts count]) willReturnUnsignedInt:1];
    [given([filleredContacts objectAtIndex:0]) willReturn:contact];
    
    //when
    UIImage *result = [contactsService getMateImage:filleredContacts];
    
    //then
    assertThat(result,notNilValue());
    assertThat(([self getPictureDataWithUIImage:result]),equalTo(inputData));
}

- (void)testThat_GetMateNameStringReturnNilWhenArgumentIsNil {
    //given
    CNContactStore *contactStore = mock([CNContactStore class]);
    ContactsService *contactsService = [[ContactsService alloc] initWithContactStore:contactStore];
    
    //when
    NSString *result = [contactsService getMateNameString:nil];
    
    //then
    assertThat(result, nilValue());
}

- (void)testThat_GetMateNameStringReturnNilWhenArgumentIsEmptyArray {
    //given
    CNContactStore *contactStore = mock([CNContactStore class]);
    ContactsService *contactsService = [[ContactsService alloc] initWithContactStore:contactStore];
    NSMutableArray<CNContact*>* filleredContacts  = [[NSMutableArray alloc] init];
    
    //when
    NSString *result = [contactsService getMateNameString:filleredContacts];
    
    //then
    assertThat(result, nilValue());
}

- (void)testThat_GetMateNameStringFull {
    //given
    CNContactStore *contactStore = mock([CNContactStore class]);
    ContactsService *contactsService = [[ContactsService alloc] initWithContactStore:contactStore];
    NSMutableArray<CNContact*>* filleredContacts  = mock([NSMutableArray class]);
    CNContact *contact = mock([ CNContact class]);
    [given([contact givenName]) willReturn:@"givenName"];
    [given([contact familyName]) willReturn:@"familyName"];
    [given([filleredContacts count]) willReturnUnsignedInt:1];
    [given([filleredContacts objectAtIndex:0]) willReturn:contact];
    
    //when
    NSString *result = [contactsService getMateNameString:filleredContacts];
    
    //then
    assertThat(result,equalTo(@"givenName familyName"));
}

- (void)testThat_GetMateNameStringOnlyGivenName {
    //given
    CNContactStore *contactStore = mock([CNContactStore class]);
    ContactsService *contactsService = [[ContactsService alloc] initWithContactStore:contactStore];
    NSMutableArray<CNContact*>* filleredContacts  = mock([NSMutableArray class]);
    CNContact *contact = mock([ CNContact class]);
    [given([contact givenName]) willReturn:@"givenName"];
    [given([filleredContacts count]) willReturnUnsignedInt:1];
    [given([filleredContacts objectAtIndex:0]) willReturn:contact];
    
    //when
    NSString *result = [contactsService getMateNameString:filleredContacts];
    
    //then
    assertThat(result,equalTo(@"givenName"));
}

- (void)testThat_GetMateNameStringOnlyFamilyName {
    //given
    CNContactStore *contactStore = mock([CNContactStore class]);
    ContactsService *contactsService = [[ContactsService alloc] initWithContactStore:contactStore];
    NSMutableArray<CNContact*>* filleredContacts  = mock([NSMutableArray class]);
    CNContact *contact = mock([ CNContact class]);
    [given([contact givenName]) willReturn:@"familyName"];
    [given([filleredContacts count]) willReturnUnsignedInt:1];
    [given([filleredContacts objectAtIndex:0]) willReturn:contact];
    
    //when
    NSString *result = [contactsService getMateNameString:filleredContacts];
    
    //then
    assertThat(result,equalTo(@"familyName"));
}



- (NSData*) getPictureData {
    UIImage *img = [UIImage imageNamed:PIC_PERSON_PATH];
    NSData *data = UIImagePNGRepresentation(img);
    return data;
}

- (NSData*) getPictureDataWithUIImage: (UIImage *) image{
    NSData *data = UIImagePNGRepresentation(image);
    return data;
}

@end
