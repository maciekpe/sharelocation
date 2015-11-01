#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>

@interface ContactsService : NSObject
- (instancetype) initWithContactStore:(CNContactStore *) store;
- (NSString *) getMateNameString:(NSArray<CNContact*> *)filteredContacts;
- (NSArray *) contactsContainingEmail:(NSString *)email;
- (NSArray *) contactsContainingPhoneNumber:(NSString *)phoneNumber;
- (UIImage *) getMateImage:(NSArray<CNContact*> *)filteredContacts;
- (BOOL) isContact:(CNContact *)contact withPhoneNumber: (NSString *)phoneNumber;
- (BOOL) isContact:(CNContact *)contact withEmailAddress: (NSString *)emailAdress;
- (NSString *) normalizePhoneNumber: (NSString *) phoneNumber;
- (NSString *) normalizeEmailAddress: (NSString *) emailAddress;
@property (nonatomic, strong, readonly) CNContactStore *contactStore;
@property (nonatomic, strong, readonly) NSArray *keysToFetch;
@end
