#import "SLShareLocationViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "SLData.h"
#import "SLAlertsFactory.h"

@interface SLShareLocationViewController ()<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,ABPeoplePickerNavigationControllerDelegate,UIAlertViewDelegate, UITextFieldDelegate>

// suwak typu wiadomosci
@property (weak, nonatomic) IBOutlet UISwitch *switchItem;
// labelka pola tekstowego
@property (weak, nonatomic) IBOutlet UITextView *messageDataField2;
@property (weak, nonatomic) IBOutlet UILabel *userDataLabel;
// pole tekstowe
@property (weak, nonatomic) IBOutlet UITextField *userDataField;
// pole widok wiadomosci
// uchwyt do obslugi tap-niecia ekranu
@property (strong, nonatomic) UITapGestureRecognizer *tap;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *mainView;

// obsluga ksoazki adresowej flaga przypisania danych do odbiorcy
@property Boolean isAddressBookForRecipient;

@end

@implementation SLShareLocationViewController

- (void)viewDidLoad
{
    NSLog(@"enter viewDidLoad start share");
    [super viewDidLoad];
    [self processViewData];
    //UIAlertController *alert = [SLAlertsFactory createErrorAlert:@"test komunikatu"];
    //[self presentViewController:alert animated:YES completion:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //_messageDataField.layer.borderColor = [UIColor whiteColor].CGColor;
    //_messageDataField.layer.borderWidth = 1;
    //_messageDataField.translatesAutoresizingMaskIntoConstraints = NO;
    _messageDataField2.attributedText = [self composeHtmlAttributedMessage];
    //_messageDataField.layer.cornerRadius=5.0f;
    if(_mainView != nil){
        _mainView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"multimedia/pics/see_ipad.png"]];
    }
    if(_scrollView != nil){
        _scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"multimedia/pics/see_iphone.png"]];
    }
    
    
    if([self getUserIdentification] == nil){
        [self showPrefsAlert];
    }
}

/*
 Obsluga przycisku preferencji
 */
- (IBAction)preferenceAction:(id)sender {
    [self showPrefs];
}


/*
 Obsluga przyciskow z alertu preferencji
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UITextField * alertTextField = [alertView textFieldAtIndex:0];
    if(buttonIndex == 1){
        [self processAddressBookOpenAction:NO];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:alertTextField.text forKey:@"SL_UID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

/*
 Otwiera alert z perferencjami.
 */
-(void)showPrefs{
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Identification" message:@"According to security issues please provide manualy your's identification data 'email,phone number' or 'email' or 'phone number'" delegate:self cancelButtonTitle:@"Save" otherButtonTitles:@"Address book",nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField* textField = [av textFieldAtIndex:0];
    
    if([self getUserIdentification] != nil){
        textField.text = [self getUserIdentification];
    }
    [av textFieldAtIndex:0].delegate = self;
    [av show];
}

/*
 Pobiera UID identyfikacji uzytkownika jesl istnieje.
 */
-(NSString *) getUserIdentification{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userIdentification = [defaults stringForKey:@"SL_UID"];
    return userIdentification;
}

/*
 Otwiera alert o braki preferencji.
 */
-(void)showPrefsAlert{
    UIAlertController *alert = [SLAlertsFactory createAlertWithMsg:@"According to security issues please provide manualy your's identification data . Please press \"Pref\" button." withTitle:@"Information" withConfirmBtnTitle:@"Contiune"];
    [self presentViewController:alert animated:YES completion:nil];
}

/*
 Otwiera ksiazke adresowa we wskazamym trybie zapisu danych.
 */
-(void)processAddressBookOpenAction:(Boolean) aIsForRecipient{
    if(aIsForRecipient){
        self.isAddressBookForRecipient = YES;
    }else{
        self.isAddressBookForRecipient = NO;
    }
    ABPeoplePickerNavigationController *picker =[[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//##################### 

/*
 akcja dodania kontaktu z książki adresowej.
 */
- (IBAction)actionBookButton:(id)sender {
    [self processAddressBookOpenAction:YES];
}

/*
 obsługa anulowania wyboru kontaktu
 */
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [self dismissViewControllerAnimated:YES completion:nil];
    CFRetain((__bridge CFTypeRef)(peoplePicker));
}

/*
 obsługa wybrania kontaktu
 */
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    [self processPersonData:person];
    [self dismissViewControllerAnimated:YES completion:nil];
    CFRetain((__bridge CFTypeRef)(peoplePicker));
    return NO;
}
/*
 pokazanie danych osoby w polach tekstowych - przekopiowanie ze struktury
 */
- (void)processPersonData:(ABRecordRef)person {
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString* phoneNumer = @"";
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phoneNumer = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    }
    CFRelease(phoneNumbers);
    NSString* email = @"";
    ABMultiValueRef emailAddress = ABRecordCopyValue(person, kABPersonEmailProperty);
    if (ABMultiValueGetCount(emailAddress) > 0) {
        email = (__bridge_transfer NSString*)
        
        ABMultiValueCopyValueAtIndex(emailAddress, 0);
        
    }
    CFRelease(emailAddress);
    if(self.isAddressBookForRecipient){
        BOOL isEmail = [_switchItem isOn];
        if(isEmail){
            _userDataField.text = email;
        }else{
            _userDataField.text = phoneNumer;
        }
    }else{
        NSString *aUid = nil;
        if(email != nil){
            email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (![email isEqualToString:@""]){
                    aUid = [@"" stringByAppendingString:email];
            }
        }
        if(phoneNumer != nil){
            phoneNumer = [[phoneNumer componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] componentsJoinedByString:@""];
            phoneNumer = [phoneNumer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (aUid != nil && ![phoneNumer isEqualToString:@""]){
                aUid = [aUid stringByAppendingString:@","];
                aUid = [aUid stringByAppendingString:phoneNumer];

            }else{
                aUid = [aUid stringByAppendingString:phoneNumer];
            }
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:aUid forKey:@"SL_UID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self showPrefs];
    }
    self.isAddressBookForRecipient = YES;

}

/*
 obsługa wybrania kontaktu
 */
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

//#####################

/*
 Obsługa wyjścia klawiatury na przycisku.
*/
- (IBAction)actionEndOnExit:(id)sender {
    [_userDataField resignFirstResponder];
}

/*
 Obsługa wyjścia klawiatury akcja na selektorze.
 */
-(void)dismissKeyboard {
    
    [_userDataField resignFirstResponder];
}

/*
 Obsługa wyjścia tap-nięcia.
 */
- (IBAction)actionBeginEditTextField:(id)sender {
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:_tap];
}

/*
 Obsługa wyjścia tap-nięcia.
 */
- (IBAction)actionEndEditTextField:(id)sender {
    [self.view removeGestureRecognizer:_tap];
}


/*
 Akcja wysłania widomości.
 */
- (IBAction)actionSendButton:(id)sender {
    BOOL isEmail = [_switchItem isOn];
    if(isEmail){
        [self sendViaEmail];
    }else{
        [self sendViaSms];
    }
}

/*
 Akcja przełączenia suwaka typu widomości.
 */
- (IBAction)actionSwitchValueChange:(id)sender {
    [self processViewData];
    [self.view setNeedsLayout];
}

/*
 Obsługa zmiany stanu widoku.
 */
- (void)processViewData{
    [_userDataField resignFirstResponder];
    [_messageDataField2 resignFirstResponder];
    _userDataField.text = @"";
    BOOL isEmail = [_switchItem isOn];
    if(isEmail){
        _userDataLabel.text = @"Email address:";
        _userDataField.placeholder = @"address here";
        [_userDataField setKeyboardType:UIKeyboardTypeEmailAddress];
        NSLog(@"Email");
    }else{
        _userDataLabel.text = @"Phone numer:";
        _userDataField.placeholder = @"phone number here";
        [_userDataField setKeyboardType:UIKeyboardTypePhonePad];
        NSLog(@"Phone");
    }
}

/*
 Wysyłka za pomocą SMS.
 */
- (void)sendViaSms{
    
    if(![MFMessageComposeViewController canSendText]) {
        
        UIAlertController *alert = [SLAlertsFactory createErrorAlert:@"Your device doesn't support SMS!"];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    MFMessageComposeViewController *smsComposer = [[MFMessageComposeViewController alloc] init];
    smsComposer.messageComposeDelegate = self;
    [smsComposer setBody:  [self composeStringMessage]];
    [smsComposer setRecipients:@[_userDataField.text]];
    [self presentViewController:smsComposer animated:YES completion:nil];
}

/*
 Wysyłka za pomocą E-MAIL.
 */
- (void)sendViaEmail{
    if(![MFMailComposeViewController canSendMail]) {
        UIAlertController *alert = [SLAlertsFactory createErrorAlert:@"Your device doesn't support E-mail!"];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setSubject:@"Loaction"];
    [mailComposer setMessageBody: [self composeHtmlStringMessage] isHTML:YES];
    [mailComposer setToRecipients:@[_userDataField.text]];
    [self presentViewController:mailComposer animated:YES completion:nil];
}

/*
 Tworzy wiadomość jako HTML.
 */
-(NSAttributedString *) composeHtmlAttributedMessage{
    NSString *messageBody = @"<em>Hi,</em><br/><em>Here I am !!!</em><br/><em>Please click this ";
    NSString *mapQuery = @"<a href=\"https://maps.google.com/maps?q=";
    NSNumber *longtitude = [NSNumber numberWithDouble:[SLData getCurrentLocation].coordinate.longitude];
    NSNumber *latitude = [NSNumber numberWithDouble:[SLData getCurrentLocation].coordinate.latitude];
    mapQuery = [mapQuery stringByAppendingString: [latitude stringValue] ];
    mapQuery = [mapQuery stringByAppendingString: @","];
    mapQuery = [mapQuery stringByAppendingString: [longtitude stringValue] ];
    mapQuery = [mapQuery stringByAppendingString: @"\">location link</a></em>"];
    messageBody = [messageBody stringByAppendingString: mapQuery];
    //NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[messageBody dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    NSStringEncoding encoding = NSUnicodeStringEncoding;
    NSData *data = [messageBody dataUsingEncoding:encoding];
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                              NSCharacterEncodingDocumentAttribute: @(encoding)};
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:data
                                                                options:options
                                                     documentAttributes:nil
                                                                  error:nil];
    
    return attributedString;
}
/*
 Tworzy wiadomość jako HTML string.
 iOSShareLocation
 */
-(NSString *) composeHtmlStringMessage{
    NSString *messageBody = @"<em>Hi,</em><br/><em>Here I am !!!</em><br/><em>Please click this ";
    NSString *mapQuery = @"<a href=\"https://maps.google.com/maps?q=";
    NSNumber *longtitude = [NSNumber numberWithDouble:[SLData getCurrentLocation].coordinate.longitude];
    NSNumber *latitude = [NSNumber numberWithDouble:[SLData getCurrentLocation].coordinate.latitude];
    mapQuery = [mapQuery stringByAppendingString: [latitude stringValue] ];
    mapQuery = [mapQuery stringByAppendingString: @","];
    mapQuery = [mapQuery stringByAppendingString: [longtitude stringValue] ];
    mapQuery = [mapQuery stringByAppendingString: @"\">location link</a></em><br/>"];
    mapQuery = [mapQuery stringByAppendingString: @"<a href=\""];
    mapQuery = [mapQuery stringByAppendingString: [self composeiOSShareLocation] ];
    mapQuery = [mapQuery stringByAppendingString: @"\">correlation link</a></em>\n"];
    messageBody = [messageBody stringByAppendingString: mapQuery];
    return messageBody;
}

/*
 Tworzy wiadomość jako string.
 */
-(NSString *) composeStringMessage{
    NSString *messageBody = @"Hi,\nHere I am !!!\n Please click this link ";
    NSString *mapQuery = @"https://maps.google.com/maps?q=";
    NSNumber *longtitude = [NSNumber numberWithDouble:[SLData getCurrentLocation].coordinate.longitude];
    NSNumber *latitude = [NSNumber numberWithDouble:[SLData getCurrentLocation].coordinate.latitude];
    mapQuery = [mapQuery stringByAppendingString: [latitude stringValue] ];
    mapQuery = [mapQuery stringByAppendingString: @","];
    mapQuery = [mapQuery stringByAppendingString: [longtitude stringValue] ];
    mapQuery = [mapQuery stringByAppendingString: @"\n correlation link " ];
    mapQuery = [mapQuery stringByAppendingString: [self composeiOSShareLocation] ];
    messageBody = [messageBody stringByAppendingString: mapQuery];
    return messageBody;
}

-(NSString *) composeiOSShareLocation{
    NSNumber *longtitude = [NSNumber numberWithDouble:[SLData getCurrentLocation].coordinate.longitude];
    NSNumber *latitude = [NSNumber numberWithDouble:[SLData getCurrentLocation].coordinate.latitude];
    NSString *url = @"iOSShareLocation://?latitude=";
    url = [url stringByAppendingString: [latitude stringValue] ];
    url = [url stringByAppendingString: @"&longitude=" ];
    url = [url stringByAppendingString: [longtitude stringValue] ];
    NSString* userIdentificationString = [self getUserIdentification];
    if(userIdentificationString != nil){
        NSString* userIdentification = [userIdentificationString stringByTrimmingCharactersInSet:
                                        [NSCharacterSet whitespaceCharacterSet]];
        if(userIdentification != nil ){
            NSArray* queryElements = [userIdentification componentsSeparatedByString: @","];
            if(queryElements.count == 2){
                url = [url stringByAppendingString: @"&tokens=" ];
                NSString* tokenString = [queryElements objectAtIndex: 0];
                tokenString = [tokenString stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
                url = [url stringByAppendingString:tokenString];
                url = [url stringByAppendingString:@"#"];
                tokenString = [queryElements objectAtIndex: 1];
                tokenString = [tokenString stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
                url = [url stringByAppendingString:tokenString];
            }
            if(queryElements.count == 1){
                url = [url stringByAppendingString: @"&tokens=" ];
                NSString* tokenString = [queryElements objectAtIndex: 0];
                tokenString = [tokenString stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
                url = [url stringByAppendingString:tokenString];
            }
        }
    }
    NSLog(@"url %@", url);
    //NSLog(@"esc url %@", [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    return url;
}

/*
 Wyjście z tworzenia widmości.
 */
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult: (MFMailComposeResult)result error:(NSError*)error {
    NSLog(@"enter mailComposeController start");
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"enter mailComposeController end");
    
}

/*
 Wyjście z tworzenia widmości.
 */
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    NSLog(@"enter messageComposeViewController start");
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"enter messageComposeViewController end");
    
}
@end
