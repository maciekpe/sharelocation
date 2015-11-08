#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>
#import "LinkData.h"

@interface ContactsService : NSObject
- (instancetype) initWithContactStore:(CNContactStore *) store;
- (NSString *) getMateNameString:(NSArray<CNContact*> *)filteredContacts;
- (NSString *) getMateUidFromContact:(CNContact *)contact;
- (NSString *) getMatePhoneFromContact:(CNContact *)contact;
- (NSString *) getMateEmailFromContact:(CNContact *)contact;
- (NSArray *) contactsContainingEmail:(NSString *)email;
- (NSArray *) contactsContainingPhoneNumber:(NSString *)phoneNumber;
- (NSArray *) contactsByLinkData:(LinkData *)linkData;
- (UIImage *) getMateImage:(NSArray<CNContact*> *)filteredContacts;
- (BOOL) isContact:(CNContact *)contact withPhoneNumber: (NSString *)phoneNumber;
- (BOOL) isContact:(CNContact *)contact withEmailAddress: (NSString *)emailAdress;
- (NSString *) normalizePhoneNumber: (NSString *) phoneNumber;
- (NSString *) normalizeEmailAddress: (NSString *) emailAddress;
@property (nonatomic, strong, readonly) CNContactStore *contactStore;
@property (nonatomic, strong, readonly) NSArray *keysToFetch;
@end
