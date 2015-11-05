#import "SLAppDelegate.h"
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "SLData.h"
#import <AddressBook/AddressBook.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ContactsService.h"
#import "LinkData.h"
#import "LinkService.h"

@implementation SLAppDelegate

extern NSString* CTSettingCopyMyPhoneNumber();

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
    NSLog(@"URL scheme:%@", [url scheme]);
    NSLog(@"URL query: %@", [url query]);
    
    IdentificationService* identificationService = [[IdentificationService alloc] initWithUserDefaults:[NSUserDefaults standardUserDefaults]];
    LinkService* linkService = [[LinkService alloc] initWithIdentificationService:identificationService];
    LinkData* linkData = [linkService decomposeLinkDataFromUrl:url];

    NSLog(@"primaryContactToken: %@", [linkData primaryContactToken]);
    NSLog(@"secondaryContactToken: %@", [linkData secondaryContactToken]);
    
    CNContactStore *contactStore = [[CNContactStore alloc]init];
    ContactsService *contactsService = [[ContactsService alloc] initWithContactStore:contactStore];
    NSArray *filteredContacts = [contactsService contactsByLinkData:linkData];
    
    if(filteredContacts != nil && filteredContacts.count > 0){
            NSLog(@"Setting contacts");
            [SLData setNameString: [contactsService getMateNameString:filteredContacts]];
            [SLData setImage: [contactsService getMateImage:filteredContacts]];
            NSLog(@"Setting end");
    }else{
            NSLog(@"no contacts");
    }
    
    CLLocation *locationMate = [[CLLocation alloc] initWithLatitude:[[linkData latitudeValue] floatValue] longitude:[[linkData longitudeValue] floatValue]];
    [SLData setMateLocation: locationMate];
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSLog(@"application start");
    sleep(2);
    //[ContactsService contactsContainingEmail:@"kate-bell@mac.com"];
    //[ContactsService contactsContainingPhoneNumber:@"5555648583"];
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
