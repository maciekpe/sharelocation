#import "SLAppDelegate.h"
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "SLData.h"
#import <AddressBook/AddressBook.h>
#import <AudioToolbox/AudioToolbox.h>

@implementation SLAppDelegate

extern NSString* CTSettingCopyMyPhoneNumber();

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
    NSLog(@"URL scheme:%@", [url scheme]);
    NSLog(@"URL query: %@", [url query]);
    //URL query: token=123abct&registered=1
    NSString* latitudeValue = @"0";
    NSString* longitudeValue = @"0";
    NSString* token_1_Value = nil;
    NSString* token_2_Value = nil;
    
    NSArray* queryElements = [[url query] componentsSeparatedByString: @"&"];
    if(queryElements.count == 2){
        NSString* latitudeString = [queryElements objectAtIndex: 0];
        NSArray* latitudeElements = [latitudeString componentsSeparatedByString: @"="];
        if(latitudeElements.count == 2){
            latitudeValue = [latitudeElements objectAtIndex: 1];
        }
        
        NSString* longitudeString = [queryElements objectAtIndex: 1];
        NSArray* longitudeElements = [longitudeString componentsSeparatedByString: @"="];
        if(longitudeElements.count == 2){
            longitudeValue = [longitudeElements objectAtIndex: 1];
        }
        
    }
    
    if(queryElements.count == 3){
        NSString* latitudeString = [queryElements objectAtIndex: 0];
        NSArray* latitudeElements = [latitudeString componentsSeparatedByString: @"="];
        if(latitudeElements.count == 2){
            latitudeValue = [latitudeElements objectAtIndex: 1];
        }
        
        NSString* longitudeString = [queryElements objectAtIndex: 1];
        NSArray* longitudeElements = [longitudeString componentsSeparatedByString: @"="];
        if(longitudeElements.count == 2){
            longitudeValue = [longitudeElements objectAtIndex: 1];
        }
        NSString* tokenString = [queryElements objectAtIndex: 2];
        NSArray* tokenElements = [tokenString componentsSeparatedByString: @"="];
        if(tokenElements.count == 2){
            NSString *token = [tokenElements objectAtIndex: 1];
            NSArray* tokenSubElements = [tokenString componentsSeparatedByString: @"#"];
            if(tokenSubElements.count == 2){
                token_1_Value = [tokenSubElements objectAtIndex: 0];
                token_2_Value = [tokenSubElements objectAtIndex: 1];
            }
            if(tokenSubElements.count == 1){
                token_1_Value = token;
            }
        }
    }

    NSLog(@"token1: %@", token_1_Value);
    NSLog(@"token2: %@", token_2_Value);
    NSArray *filteredContacts = [self contactsContainingEmail:token_1_Value];
    if(filteredContacts == nil || filteredContacts.count == 0){
        filteredContacts = [self contactsContainingPhoneNumber:token_2_Value];
        if(filteredContacts == nil || filteredContacts.count == 0){
            filteredContacts = [self contactsContainingEmail:token_2_Value];
            if(filteredContacts == nil || filteredContacts.count == 0){
                filteredContacts = [self contactsContainingPhoneNumber:token_1_Value];
            }
        }
    }
    
    if(filteredContacts != nil && filteredContacts.count > 0){
            NSLog(@"Setting contacts");
            [SLData setNameString: [self getMateNameString:filteredContacts]];
            [SLData setImage: [self getMateImage:filteredContacts]];
            NSLog(@"Setting end");
    }else{
            NSLog(@"no contacts");
    }
    

    
    CLLocation *locationMate = [[CLLocation alloc] initWithLatitude:[latitudeValue floatValue] longitude:[longitudeValue floatValue]];
    [SLData setMateLocation: locationMate];

    
    
    
    /*
    NSString* data = latitudeValue; 
    data = [data stringByAppendingString: @" " ];
    data = [data stringByAppendingString: longitudeValue];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Mate location"
                                                    message:data
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
    */
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    sleep(2);
    
    //for debug 37.33170303 longitude=-122.03024001
    //37.7873589 longitude=-122.408227
    
    /*
    CLLocation *locationMate = [[CLLocation alloc] initWithLatitude:[@"37.33045275" floatValue] longitude:[@"-122.02953296" floatValue]];
    [SLData setMateLocation: locationMate];
    
    
    SystemSoundID mBeep;
    
    // Create the sound ID
    NSString* path = [[NSBundle mainBundle]
                      pathForResource:@"sonar" ofType:@"wav"];
    NSURL* url = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &mBeep);
    
    // Play the sound
    AudioServicesPlaySystemSound(mBeep);
    
    // Dispose of the sound
    AudioServicesDisposeSystemSoundID(mBeep);

    
    
    NSString* token_1_Value = @"test@wp.pl";
    NSString* token_2_Value = @"48500111222";
    
    NSArray *filteredContacts = [self contactsContainingEmail:token_1_Value];
    if(filteredContacts == nil || filteredContacts.count == 0){
        filteredContacts = [self contactsContainingPhoneNumber:token_2_Value];
        if(filteredContacts == nil || filteredContacts.count == 0){
            filteredContacts = [self contactsContainingEmail:token_2_Value];
            if(filteredContacts == nil || filteredContacts.count == 0){
                filteredContacts = [self contactsContainingPhoneNumber:token_1_Value];
            }
        }
    }
    
    if(filteredContacts != nil && filteredContacts.count > 0){
        [SLData setNameString: [self getMateNameString:filteredContacts]];
        [SLData setImage: [self getMateImage:filteredContacts]];
    }
    
    
    //NSArray *filteredContacts = [self contactsContainingPhoneNumber:@"500 111 222"];
    NSString * token_1_Value = nil;
    NSString * token_2_Value = nil;
    NSString * tokenString  = @"tokens=mac@wp.pl#48500111223";
    NSArray* tokenElements = [tokenString componentsSeparatedByString: @"="];
    if(tokenElements.count == 2){
        NSString *token = [tokenElements objectAtIndex: 1];
        NSArray* tokenSubElements = [tokenString componentsSeparatedByString: @"#"];
        if(tokenSubElements.count == 2){
            token_1_Value = [tokenSubElements objectAtIndex: 0];
            token_2_Value = [tokenSubElements objectAtIndex: 1];
        }
        if(tokenSubElements.count == 1){
            token_1_Value = token;
        }
    }*/
    return YES;
}

-(NSString *) getMateNameString:(NSArray *)filteredContacts{
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

-(UIImage *) getMateImage:(NSArray *)filteredContacts{
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

-(NSArray *)contactsContainingEmail:(NSString *)email {
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


-(NSArray *)contactsContainingPhoneNumber:(NSString *)phoneNumber {
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
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
