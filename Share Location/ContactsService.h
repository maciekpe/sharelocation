#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>

@interface ContactsService : NSObject
- (instancetype) initWithContactStore:(CNContactStore *) store;
- (NSString *) getMateNameString:(NSArray<CNContact*> *)filteredContacts;
- (NSArray *) contactsContainingEmail:(NSString *)email;
- (NSArray *) contactsContainingPhoneNumber:(NSString *)phoneNumber;
- (UIImage *) getMateImage:(NSArray<CNContact*> *)filteredContacts;
@property (nonatomic, strong, readonly) CNContactStore *contactStore;
@end
