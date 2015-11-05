#import "MessageService.h"
#import "SLData.h"
#import "Consts.h"
#import "LinkService.h"

@implementation MessageService

//brakuje buildera dla message

- (instancetype) initWithLinkService:(LinkService*) linkService {
    self = [super init];
    if (self) {
        if(linkService == nil){
            NSException* myException = [NSException
                                        exceptionWithName:@"linkService"
                                        reason:@"linkService is nil"
                                        userInfo:nil];
            @throw myException;
        }
        _linkService = linkService;
    }
    return self;
}


/*
 Tworzy wiadomość jako HTML.
 */
-(NSAttributedString *) composeHtmlAttributedMessage {
    NSString *messageBody = @"<em>Hi,</em><br/><em>Here I am !!!</em><br/><em>Please click this ";
    NSString *mapQuery = @"<a href=\"https://maps.google.com/maps?q=";
    NSNumber *longtitude = [NSNumber numberWithDouble:[SLData getCurrentLocation].coordinate.longitude];
    NSNumber *latitude = [NSNumber numberWithDouble:[SLData getCurrentLocation].coordinate.latitude];
    mapQuery = [mapQuery stringByAppendingString: [latitude stringValue] ];
    mapQuery = [mapQuery stringByAppendingString: SEMICOLON_SEPARATOR];
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
-(NSString *) composeHtmlStringMessage {
    NSString *messageBody = @"<em>Hi,</em><br/><em>Here I am !!!</em><br/><em>Please click this ";
    NSString *mapQuery = @"<a href=\"https://maps.google.com/maps?q=";
    NSNumber *longtitude = [NSNumber numberWithDouble:[SLData getCurrentLocation].coordinate.longitude];
    NSNumber *latitude = [NSNumber numberWithDouble:[SLData getCurrentLocation].coordinate.latitude];
    mapQuery = [mapQuery stringByAppendingString: [latitude stringValue] ];
    mapQuery = [mapQuery stringByAppendingString: SEMICOLON_SEPARATOR];
    mapQuery = [mapQuery stringByAppendingString: [longtitude stringValue] ];
    mapQuery = [mapQuery stringByAppendingString: @"\">location link</a></em><br/>"];
    mapQuery = [mapQuery stringByAppendingString: @"<a href=\""];
    mapQuery = [mapQuery stringByAppendingString: [self.linkService composeLink] ];
    mapQuery = [mapQuery stringByAppendingString: @"\">correlation link</a></em>\n"];
    messageBody = [messageBody stringByAppendingString: mapQuery];
    return messageBody;
}

/*
 Tworzy wiadomość jako string.
 */
-(NSString *) composeStringMessage {
    NSString *messageBody = @"Hi,\nHere I am !!!\n Please click this link ";
    NSString *mapQuery = @"https://maps.google.com/maps?q=";
    NSNumber *longtitude = [NSNumber numberWithDouble:[SLData getCurrentLocation].coordinate.longitude];
    NSNumber *latitude = [NSNumber numberWithDouble:[SLData getCurrentLocation].coordinate.latitude];
    mapQuery = [mapQuery stringByAppendingString: [latitude stringValue] ];
    mapQuery = [mapQuery stringByAppendingString: SEMICOLON_SEPARATOR];
    mapQuery = [mapQuery stringByAppendingString: [longtitude stringValue] ];
    mapQuery = [mapQuery stringByAppendingString: @"\n correlation link " ];
    mapQuery = [mapQuery stringByAppendingString: [self.linkService composeLink] ];
    messageBody = [messageBody stringByAppendingString: mapQuery];
    return messageBody;
}

@end
