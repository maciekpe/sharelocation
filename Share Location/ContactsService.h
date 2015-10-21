#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>

@interface ContactsService : NSObject
+ (ContactsService*) getInstance;
+ (NSString *) getMateNameString:(NSArray<CNContact*> *)filteredContacts;
+ (NSArray *) contactsContainingEmail:(NSString *)email;
+ (NSArray *) contactsContainingPhoneNumber:(NSString *)phoneNumber;
+ (UIImage *) getMateImage:(NSArray<CNContact*> *)filteredContacts;
@end
