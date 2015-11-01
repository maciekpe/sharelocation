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
        _keysToFetch = @[CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactGivenNameKey];
    }
    return self;
}

- (NSString *) getMateNameString:(NSArray<CNContact*> *)filteredContacts{
    NSString * result = nil;
    if(filteredContacts != nil && filteredContacts.count > 0){
        CNContact* contact = [filteredContacts objectAtIndex:0];
        NSString *givenName = contact.givenName;
        NSString *familyName = contact.familyName;
        result = nil;
        if(givenName !=nil){
            result = [@"" stringByAppendingString:givenName];
        }
        if(familyName != nil){
            if(result == nil){
                result = [@"" stringByAppendingString:familyName];
            }else{
                result = [result stringByAppendingString:@" "];
                result = [result stringByAppendingString:familyName];
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
    email = [self normalizeEmailAddress: email];
    NSMutableArray<CNContact*>* result  = [[NSMutableArray alloc] init];
    NSError* contactError;
    [self.contactStore containersMatchingPredicate:[CNContainer predicateForContainersWithIdentifiers: @[self.contactStore.defaultContainerIdentifier]] error:&contactError];
    CNContactFetchRequest * request = [[CNContactFetchRequest alloc]initWithKeysToFetch:self.keysToFetch];
    [self.contactStore enumerateContactsWithFetchRequest:request error:&contactError usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop){
        if([self isContact:contact withEmailAddress:email]){
            [result addObject: contact];
        }
    }];
    NSLog(@"contactsContainingEmail search result size: %lu", (unsigned long)[result count]);
    return result;
}

-  (NSArray<CNContact*> *) contactsContainingPhoneNumber:(NSString *)phoneNumber {
    if(phoneNumber == nil){
        return nil;
    }
    phoneNumber = [self normalizePhoneNumber:phoneNumber];
    NSMutableArray<CNContact*>* result  = [[NSMutableArray alloc] init];
    NSError* contactError;
    [self.contactStore containersMatchingPredicate:[CNContainer predicateForContainersWithIdentifiers: @[self.contactStore.defaultContainerIdentifier]] error:&contactError];
    CNContactFetchRequest * request = [[CNContactFetchRequest alloc]initWithKeysToFetch:self.keysToFetch];
    [self.contactStore enumerateContactsWithFetchRequest:request error:&contactError usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop){
        if([self isContact:contact withPhoneNumber:phoneNumber]){
            [result addObject: contact];
        }
    }];
    NSLog(@"contactsContainingPhoneNumber search result size: %lu", (unsigned long)[result count]);
    return result;
}

- (BOOL) isContact:(CNContact *)contact withPhoneNumber: (NSString *)phoneNumber {
    NSArray * phoneNumbers = (NSArray*)[contact.phoneNumbers valueForKey:@"value"];
    if (phoneNumbers.count > 0) {
        for (CNPhoneNumber* cnPhoneNumber in phoneNumbers) {
            NSString *contactPhoneNumber = [cnPhoneNumber stringValue];
            NSLog(@"contactPhoneNumber: %@", contactPhoneNumber);
            contactPhoneNumber = [self normalizePhoneNumber:contactPhoneNumber];
            if ([contactPhoneNumber rangeOfString:phoneNumber].location != NSNotFound) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL) isContact:(CNContact *)contact withEmailAddress: (NSString *)emailAdress {
    NSArray * emialAddresses = (NSArray*)[contact.emailAddresses valueForKey:@"value"];
    if (emialAddresses.count > 0) {
        for (NSString* contactEmailAddress in emialAddresses) {
            NSLog(@"address: %@", contactEmailAddress);
            NSString * normalizedContactEmailAddress = [self normalizeEmailAddress:contactEmailAddress];
            if ([normalizedContactEmailAddress rangeOfString:emailAdress].location != NSNotFound) {
                return YES;
            }
        }
    }
    return NO;
}

- (NSString *) normalizePhoneNumber: (NSString *) phoneNumber {
    if(phoneNumber == nil){
        NSException* myException = [NSException
                                    exceptionWithName:@"phoneNumber"
                                    reason:@"phoneNumber is nil"
                                    userInfo:nil];
        @throw myException;
    }
    // Remove non numeric characters from the phone number
    phoneNumber = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] componentsJoinedByString:@""];
    phoneNumber = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return phoneNumber;
}

- (NSString *) normalizeEmailAddress: (NSString *) emailAddress {
    if(emailAddress == nil){
        NSException* myException = [NSException
                                    exceptionWithName:@"emailAddress"
                                    reason:@"emailAddress is nil"
                                    userInfo:nil];
        @throw myException;
    }
    emailAddress = [emailAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return emailAddress;
}


@end
