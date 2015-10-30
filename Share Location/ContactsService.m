#import <Foundation/Foundation.h>
#import "ContactsService.h"
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
@implementation ContactsService


/*
+ (instancetype) getInstance {
    static ContactsService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[self alloc] init];
    });
    return service;
}*/

- (instancetype) initWithContactStore:(CNContactStore *) store
{
    self = [super init];
    if (self) {
        if(store == nil){
            NSException* myException = [NSException
                                        exceptionWithName:@"CNContactStoreNotFoundException"
                                        reason:@"CNContactStore is nil"
                                        userInfo:nil];
            @throw myException;
        }
        _contactStore = store;
    }
    return self;
}

- (NSString *) getMateNameString:(NSArray<CNContact*> *)filteredContacts{
    NSString * result = nil;
    if(filteredContacts != nil && filteredContacts.count > 0){
        CNContact* contact = [filteredContacts objectAtIndex:0];
        NSString *firstName = contact.givenName;
        NSString *lastName = contact.familyName;
        result = nil;
        if(firstName !=nil){
            result = [@"" stringByAppendingString:firstName];
        }
        if(lastName != nil){
            if(result == nil){
                result = [@"" stringByAppendingString:lastName];
            }else{
                result = [result stringByAppendingString:@" "];
                result = [result stringByAppendingString:lastName];
            }
        }
    }
    return result;
}

- (UIImage *) getMateImage:(NSArray<CNContact*> *)filteredContacts{
    UIImage * result = nil;
    if(filteredContacts != nil && filteredContacts.count > 0){
        CNContact* contact = [filteredContacts objectAtIndex:0];
        if(contact.imageDataAvailable){
            NSData *imgData = contact.imageData;
            result = [UIImage imageWithData: imgData];
        }
    }
    return result;
}

-  (NSArray<CNContact*> *) contactsContainingEmail:(NSString *)email {
    if(email == nil){
        return nil;
    }
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSMutableArray<CNContact*>* result  = [[NSMutableArray alloc] init];
    //CNContactStore* addressBook = [[CNContactStore alloc]init];
    NSError* contactError;
    [self.contactStore containersMatchingPredicate:[CNContainer predicateForContainersWithIdentifiers: @[self.contactStore.defaultContainerIdentifier]] error:&contactError];
    NSArray * keysToFetch =@[CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactGivenNameKey];
    CNContactFetchRequest * request = [[CNContactFetchRequest alloc]initWithKeysToFetch:keysToFetch];
    [self.contactStore enumerateContactsWithFetchRequest:request error:&contactError usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop){
        NSArray * addresses = (NSArray*)[contact.emailAddresses valueForKey:@"value"];
        if (addresses.count > 0) {
            for (NSString* address in addresses) {
                NSLog(@"address: %@", address);
                NSString* addressEmail = [address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if ([addressEmail rangeOfString:email].location != NSNotFound) {
                    [result addObject: contact];
                }
            }
        }
    }];
    NSLog(@"contactsContainingEmailNEW search result size: %lu", (unsigned long)[result count]);
    return result;
}

-  (NSArray<CNContact*> *) contactsContainingPhoneNumber:(NSString *)phoneNumber {
    if(phoneNumber == nil){
        return nil;
    }
    // Remove non numeric characters from the phone number
    phoneNumber = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] componentsJoinedByString:@""];
    phoneNumber = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSMutableArray<CNContact*>* result  = [[NSMutableArray alloc] init];
    //CNContactStore* addressBook = [[CNContactStore alloc]init];
    NSError* contactError;
    [self.contactStore containersMatchingPredicate:[CNContainer predicateForContainersWithIdentifiers: @[self.contactStore.defaultContainerIdentifier]] error:&contactError];
    NSArray * keysToFetch =@[CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactGivenNameKey];
    CNContactFetchRequest * request = [[CNContactFetchRequest alloc]initWithKeysToFetch:keysToFetch];
    [self.contactStore enumerateContactsWithFetchRequest:request error:&contactError usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop){
        NSArray * phoneNumbers = (NSArray*)[contact.phoneNumbers valueForKey:@"value"];
        if (phoneNumbers.count > 0) {
            for (CNPhoneNumber* cnPhoneNumber in phoneNumbers) {
                NSString *contactPhoneNumber = [[cnPhoneNumber stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                contactPhoneNumber = [[contactPhoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] componentsJoinedByString:@""];
                NSLog(@"contactPhoneNumber: %@", contactPhoneNumber);
                if ([contactPhoneNumber rangeOfString:phoneNumber].location != NSNotFound) {
                    [result addObject: contact];
                    break;
                }
            }
        }
    }];
    NSLog(@"contactsContainingPhoneNumberNEW search result size: %lu", (unsigned long)[result count]);
    return result;
}
@end
