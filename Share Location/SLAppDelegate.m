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
    [self processOpenUrl:url];
    return YES;
}

-(void)processOpenUrl:(NSURL *)url {
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
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSLog(@"application start");
    sleep(2);
    [self processEnvs];
    return YES;
}

-(void)processEnvs {
    NSDictionary<NSString*, NSString*> *environment = [[NSProcessInfo processInfo] environment];
    NSString* url = [environment objectForKey:@"url"];
    if(url != nil){
        NSURL* openUrl = [[NSURL alloc] initWithString:url];
        [self processOpenUrl:openUrl];
    }
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
