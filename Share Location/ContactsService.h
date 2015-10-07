#import <Foundation/Foundation.h>

@interface ContactsService : NSObject
+ (ContactsService*) getInstance;
+ (NSString *) getMateNameString:(NSArray *)filteredContacts;
+ (NSArray *) contactsContainingEmail:(NSString *)email;
+ (NSArray *) contactsContainingPhoneNumber:(NSString *)phoneNumber;
+ (UIImage *) getMateImage:(NSArray *)filteredContacts;
@end
