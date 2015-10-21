#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>

@interface ContactsService : NSObject
+ (ContactsService*) getInstance;
+ (NSString *) getMateNameString:(NSArray *)filteredContacts;
+ (NSArray *) contactsContainingEmail:(NSString *)email;
+ (NSArray *) contactsContainingPhoneNumber:(NSString *)phoneNumber;
+ (UIImage *) getMateImage:(NSArray *)filteredContacts;

+  (NSArray<CNContact*> *) contactsContainingEmailNEW:(NSString *)email;
+  (NSArray<CNContact*> *) contactsContainingPhoneNumberNEW:(NSString *)phoneNumber;
@end
