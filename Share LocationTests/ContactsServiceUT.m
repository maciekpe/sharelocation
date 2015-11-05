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

//brakuje testu na szukanie po LinkData
//brakuej testu na mockach CNContactStore

CNContactStore *contactStore ;
ContactsService *contactsService ;

- (void)setUp {
    [super setUp];
    contactStore = mock([CNContactStore class]);
    contactsService = [[ContactsService alloc] initWithContactStore:contactStore];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testThat_GetMateImageReturnNilWhenArgumentIsNil {
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
    NSMutableArray<CNContact*>* filleredContacts  = [[NSMutableArray alloc] init];
    
    //when
    UIImage *result = [contactsService getMateImage:filleredContacts];
    
    //then
    assertThat(result, nilValue());
}

- (void)testThat_GetMateImage {
    //given
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
    //when
    NSString *result = [contactsService getMateNameString:nil];
    
    //then
    assertThat(result, nilValue());
}

- (void)testThat_GetMateNameStringReturnNilWhenArgumentIsEmptyArray {
    //given
    NSMutableArray<CNContact*>* filleredContacts  = [[NSMutableArray alloc] init];
    
    //when
    NSString *result = [contactsService getMateNameString:filleredContacts];
    
    //then
    assertThat(result, nilValue());
}

- (void)testThat_GetMateNameStringFull {
    //given
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

- (void)testThat_normalizePhoneNumberTrimWhiteSpaces {
    //given
    NSString* phoneNumber = @" 600 111 222    ";
    
    //when
    NSString *result = [contactsService normalizePhoneNumber:phoneNumber];
    
    //then
    assertThat(result,equalTo(@"600111222"));
}

- (void)testThat_normalizePhoneNumberRemoveNonNumericChars {
    //given
    NSString* phoneNumber = @" (+48) 600 111 222    ";
    
    //when
    NSString *result = [contactsService normalizePhoneNumber:phoneNumber];
    
    //then
    assertThat(result,equalTo(@"48600111222"));
}

- (void)testThat_ThrowsExceptionWhenNilPassedToNormalizePhoneNumber {
    //expect
    XCTAssertThrows([contactsService normalizePhoneNumber:nil],@"Expect exception for nil phone number");
}

- (void)testThat_normalizeEmailAddressTrimWhiteSpaces {
    //given
    NSString* emailAddress = @" test@wp.pl  ";
    
    //when
    NSString *result = [contactsService normalizeEmailAddress:emailAddress];
    
    //then
    assertThat(result,equalTo(@"test@wp.pl"));
}

- (void)testThat_ThrowsExceptionWhenNilPassedToNormalizeEmailAddress {
    //expect
    XCTAssertThrows([contactsService normalizeEmailAddress:nil],@"Expect exception for nil email address");
}

- (void)testThat_IsContactWithEmailAddress {
    //given
    CNContact *contact = mock([ CNContact class]);
    NSMutableArray<CNLabeledValue<NSString*>*> *addresses  = [[NSMutableArray alloc] init];
    CNLabeledValue<NSString*>* labeledvalueTrue = [[CNLabeledValue alloc] initWithLabel:@"addressTrue" value:@"true@wp.pl   "];
    CNLabeledValue<NSString*>* labeledvalueFalse = [[CNLabeledValue alloc] initWithLabel:@"addressFalse" value:@" false@wp.pl"];
    [addresses addObject:labeledvalueTrue];
    [addresses addObject:labeledvalueFalse];
    
    [given([contact emailAddresses]) willReturn:addresses];
    
    //when
    BOOL result = [contactsService isContact:contact withEmailAddress:@"  true@wp.pl"];
    
    //then
    assertThatBool(result, isTrue());
}

- (void)testThat_IsContactWithPhoneNumber {
    //given
    CNContact *contact = mock([ CNContact class]);
    NSMutableArray<CNLabeledValue<CNPhoneNumber*>*> *phoneNumbers  = [[NSMutableArray alloc] init];
    CNPhoneNumber *phoneNumberTrue = [[CNPhoneNumber alloc] initWithStringValue:@"(+48) 600 111 222     "];
    CNLabeledValue<CNPhoneNumber*>* labeledvalueTrue = [[CNLabeledValue alloc] initWithLabel:@"phoneNumberTrue" value:phoneNumberTrue];
    CNPhoneNumber *phoneNumberFalse = [[CNPhoneNumber alloc] initWithStringValue:@" (+48) 666666666    "];
    CNLabeledValue<CNPhoneNumber*>* labeledvalueFalse = [[CNLabeledValue alloc] initWithLabel:@"phoneNumberFalse" value:phoneNumberFalse];
    [phoneNumbers addObject:labeledvalueTrue];
    [phoneNumbers addObject:labeledvalueFalse];
    
    [given([contact phoneNumbers]) willReturn:phoneNumbers];
    
    //when
    BOOL result = [contactsService isContact:contact withPhoneNumber:@"  (+48) 600 111 222   "];
    
    //then
    assertThatBool(result, isTrue());
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
