#import "SLAppDelegate.h"
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "SLData.h"
#import <AddressBook/AddressBook.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ContactsService.h"

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
    NSArray *filteredContacts = [ContactsService contactsContainingEmail:token_1_Value];
    if(filteredContacts == nil || filteredContacts.count == 0){
        filteredContacts = [ContactsService contactsContainingPhoneNumber:token_2_Value];
        if(filteredContacts == nil || filteredContacts.count == 0){
            filteredContacts = [ContactsService contactsContainingEmail:token_2_Value];
            if(filteredContacts == nil || filteredContacts.count == 0){
                filteredContacts = [ContactsService contactsContainingPhoneNumber:token_1_Value];
            }
        }
    }
    
    if(filteredContacts != nil && filteredContacts.count > 0){
            NSLog(@"Setting contacts");
            [SLData setNameString: [ContactsService getMateNameString:filteredContacts]];
            [SLData setImage: [ContactsService getMateImage:filteredContacts]];
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
