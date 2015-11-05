#import "MessageService.h"
#import "Consts.h"
#import "LinkService.h"
#import <MapKit/MapKit.h>

@implementation MessageService

//brakuje buildera dla message
//usunac SLData

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
-(NSAttributedString *) composeHtmlAttributedMessageWithLocation:(CLLocation*) location {
    NSString *messageBody = @"<em>Hi,</em><br/><em>Here I am !!!</em><br/><em>Please click this ";
    NSString *mapQuery = @"<a href=\"https://maps.google.com/maps?q=";
    NSNumber *longtitude = [NSNumber numberWithDouble:location.coordinate.longitude];
    NSNumber *latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
    mapQuery = [mapQuery stringByAppendingString: [latitude stringValue] ];
    mapQuery = [mapQuery stringByAppendingString: SEMICOLON_SEPARATOR];
    mapQuery = [mapQuery stringByAppendingString: [longtitude stringValue] ];
    mapQuery = [mapQuery stringByAppendingString: @"\">location link</a></em>"];
    messageBody = [messageBody stringByAppendingString: mapQuery];
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
-(NSString *) composeHtmlStringMessageWithLocation:(CLLocation*) location {
    NSString *messageBody = @"<em>Hi,</em><br/><em>Here I am !!!</em><br/><em>Please click this ";
    NSString *mapQuery = @"<a href=\"https://maps.google.com/maps?q=";
    NSNumber *longtitude = [NSNumber numberWithDouble:location.coordinate.longitude];
    NSNumber *latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
    mapQuery = [mapQuery stringByAppendingString: [latitude stringValue] ];
    mapQuery = [mapQuery stringByAppendingString: SEMICOLON_SEPARATOR];
    mapQuery = [mapQuery stringByAppendingString: [longtitude stringValue] ];
    mapQuery = [mapQuery stringByAppendingString: @"\">location link</a></em><br/>"];
    mapQuery = [mapQuery stringByAppendingString: @"<a href=\""];
    mapQuery = [mapQuery stringByAppendingString: [self.linkService composeLinkWithLocation:location] ];
    mapQuery = [mapQuery stringByAppendingString: @"\">correlation link</a></em>\n"];
    messageBody = [messageBody stringByAppendingString: mapQuery];
    return messageBody;
}

/*
 Tworzy wiadomość jako string.
 */
-(NSString *) composeStringMessageWithLocation:(CLLocation*) location {
    NSString *messageBody = @"Hi,\nHere I am !!!\n Please click this link ";
    NSString *mapQuery = @"https://maps.google.com/maps?q=";
    NSNumber *longtitude = [NSNumber numberWithDouble:location.coordinate.longitude];
    NSNumber *latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
    mapQuery = [mapQuery stringByAppendingString: [latitude stringValue] ];
    mapQuery = [mapQuery stringByAppendingString: SEMICOLON_SEPARATOR];
    mapQuery = [mapQuery stringByAppendingString: [longtitude stringValue] ];
    mapQuery = [mapQuery stringByAppendingString: @"\n correlation link " ];
    mapQuery = [mapQuery stringByAppendingString: [self.linkService composeLinkWithLocation:location] ];
    messageBody = [messageBody stringByAppendingString: mapQuery];
    return messageBody;
}

@end
