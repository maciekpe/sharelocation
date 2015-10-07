#import <Foundation/Foundation.h>
#import "ContactsService.h"
#import <AddressBook/AddressBook.h>
@implementation ContactsService

+ (instancetype) getInstance {
    static ContactsService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[self alloc] init];
    });
    return service;
    }

+ (NSString *) getMateNameString:(NSArray *)filteredContacts{
    NSString * result = nil;
    if(filteredContacts != nil && filteredContacts.count > 0){
        ABRecordRef aABRecordRef = (__bridge ABRecordRef)[filteredContacts objectAtIndex:0];
        
        NSString *firstName = (__bridge NSString *)ABRecordCopyValue(aABRecordRef, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge NSString *)ABRecordCopyValue(aABRecordRef, kABPersonLastNameProperty);
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

+ (UIImage *) getMateImage:(NSArray *)filteredContacts{
    UIImage * result = nil;
    if(filteredContacts != nil && filteredContacts.count > 0){
        ABRecordRef aABRecordRef = (__bridge ABRecordRef)[filteredContacts objectAtIndex:0];
        // can't get image from a ABRecordRef copy
        ABRecordID contactID = ABRecordGetRecordID(aABRecordRef);
        ABAddressBookRef addressBook = ABAddressBookCreate();
        
        ABRecordRef origContactRef = ABAddressBookGetPersonWithRecordID(addressBook, contactID);
        
        if (ABPersonHasImageData(origContactRef)) {
            NSData *imgData = (__bridge NSData*)ABPersonCopyImageDataWithFormat(origContactRef, kABPersonImageFormatOriginalSize);
            result = [UIImage imageWithData: imgData];
        }
        
        CFRelease(addressBook);
    }
    return result;
}

+ (NSArray *)contactsContainingEmail:(NSString *)email {
    if(email == nil){
        return nil;
    }
    
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // Create a new address book object with data from the Address Book database
    CFErrorRef error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    if (!addressBook) {
        return [NSArray array];
    } else if (error) {
        CFRelease(addressBook);
        return [NSArray array];
    }
    
    // Requests access to address book data from the user
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {});
    
    // Build a predicate that searches for contacts that contain the email
    NSPredicate *predicate = [NSPredicate predicateWithBlock: ^(id record, NSDictionary *bindings) {
        ABMultiValueRef emails = ABRecordCopyValue( (__bridge ABRecordRef)record, kABPersonEmailProperty);
        BOOL result = NO;
        for (CFIndex i = 0; i < ABMultiValueGetCount(emails); i++) {
            NSString *contactEmail = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(emails, i);
            contactEmail = [contactEmail stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([contactEmail rangeOfString:email].location != NSNotFound) {
                result = YES;
                break;
            }
        }
        CFRelease(emails);
        return result;
    }];
    
    // Search the users contacts for contacts that contain the phone number
    NSArray *allPeople = (NSArray *)CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    NSArray *filteredContacts = [allPeople filteredArrayUsingPredicate:predicate];
    CFRelease(addressBook);
    
    return filteredContacts;
}


+ (NSArray *)contactsContainingPhoneNumber:(NSString *)phoneNumber {
    if(phoneNumber == nil){
        return nil;
    }
    // Remove non numeric characters from the phone number
    phoneNumber = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] componentsJoinedByString:@""];
    phoneNumber = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // Create a new address book object with data from the Address Book database
    CFErrorRef error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    if (!addressBook) {
        return [NSArray array];
    } else if (error) {
        CFRelease(addressBook);
        return [NSArray array];
    }
    
    // Requests access to address book data from the user
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {});
    
    // Build a predicate that searches for contacts that contain the phone number
    NSPredicate *predicate = [NSPredicate predicateWithBlock: ^(id record, NSDictionary *bindings) {
        ABMultiValueRef phoneNumbers = ABRecordCopyValue( (__bridge ABRecordRef)record, kABPersonPhoneProperty);
        BOOL result = NO;
        for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
            NSString *contactPhoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
            NSLog(@"contactPhoneNumber: %@", contactPhoneNumber);
            contactPhoneNumber = [contactPhoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            contactPhoneNumber = [[contactPhoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] componentsJoinedByString:@""];
            if ([contactPhoneNumber rangeOfString:phoneNumber].location != NSNotFound) {
                result = YES;
                break;
            }
        }
        CFRelease(phoneNumbers);
        return result;
    }];
    
    // Search the users contacts for contacts that contain the phone number
    NSArray *allPeople = (NSArray *)CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    NSArray *filteredContacts = [allPeople filteredArrayUsingPredicate:predicate];
    CFRelease(addressBook);
    
    return filteredContacts;
}

@end
