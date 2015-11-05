#import "LinkService.h"
#import "ContactsService.h"
#import "SLData.h"
#import "Consts.h"

@implementation LinkService
//usunac odwolania do string utils jak powstana

- (instancetype) initWithIdentificationService:(IdentificationService *) identificationService {
    self = [super init];
    if (self) {
        if(identificationService == nil){
            NSException* myException = [NSException
                                        exceptionWithName:@"IdentificationService"
                                        reason:@"CNContactStore is nil"
                                        userInfo:nil];
            @throw myException;
        }
        _identificationService = identificationService;
    }
    return self;
}


 + (instancetype) getInstance {
     static LinkService *service = nil;
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
         service = [[self alloc] init];
     });
     return service;
 }

- (LinkData *) decomposeLinkDataFromUrl :(NSURL *)url {
    NSDictionary* parameterDictionary = [self prepareParametersDictionary:url];
    NSString* latitudeValue = [parameterDictionary objectForKey:URL_LATI_PARAM];
    NSString* longitudeValue = [parameterDictionary objectForKey:URL_LONG_PARAM];
    NSString* tokenSegment = [parameterDictionary objectForKey:URL_TOKENS_PARAM];
    NSString* primaryContactToken;
    NSString* secondaryContactToken;
    if(latitudeValue == nil || longitudeValue == nil){
        NSException* myException = [NSException
                                    exceptionWithName:@"decomposeLinkDataFromUrl"
                                    reason:@"required param is nil"
                                    userInfo:nil];
        @throw myException;
    }
    
    if(tokenSegment != nil){
        NSArray* tokens = [self decomposeTokenSegment:tokenSegment];
        primaryContactToken = [tokens objectAtIndex:0];
        if([tokens count] > 1){
            secondaryContactToken = [tokens objectAtIndex:1];
        }
    }
    LinkData* result = [[LinkData alloc] initWithLatitude:latitudeValue withLongitude:longitudeValue withPrimaryContactToken:primaryContactToken withSecondaryContactToken:secondaryContactToken];
    return result;
}

- (NSDictionary *) prepareParametersDictionary :(NSURL *)url {
    NSMutableDictionary* parameterDictionary = [[NSMutableDictionary alloc] init];
    NSArray* parameterSegments = [self decomposeParameterSegments:[url query]];
    for(NSString* parameterSegement in parameterSegments){
        NSDictionary* parameterDefinition = [self decomposeParameter: parameterSegement];
        [parameterDictionary addEntriesFromDictionary:parameterDefinition];
    }
    return parameterDictionary;
}

- (NSArray *) decomposeTokenSegment :(NSString *) tokenSegment {
    NSArray* tokens = [tokenSegment componentsSeparatedByString: @","];
    return tokens;
}

- (NSArray *) decomposeParameterSegments :(NSString *) query {
    NSArray* parameterSegments = [query componentsSeparatedByString: @"&"];
    return parameterSegments;
}

- (NSDictionary *) decomposeParameter :(NSString *) parameterSegment {
    NSArray* parameters = [parameterSegment componentsSeparatedByString: @"="];
    return @{[parameters objectAtIndex:0] : [parameters objectAtIndex:1]};
}

-(NSString *) composeLink {
    NSNumber *longtitude = [NSNumber numberWithDouble:[SLData getCurrentLocation].coordinate.longitude];
    NSNumber *latitude = [NSNumber numberWithDouble:[SLData getCurrentLocation].coordinate.latitude];
    NSString *url = @"iOSShareLocation://?latitude=";
    url = [url stringByAppendingString: [latitude stringValue] ];
    url = [url stringByAppendingString: @"&longitude=" ];
    url = [url stringByAppendingString: [longtitude stringValue] ];
    
    if(![self.identificationService isUserIdentificationEmpty]){
        NSString* userIdentificationString = [self.identificationService getUserIdentification];
        NSString* userIdentification = [userIdentificationString stringByTrimmingCharactersInSet:
                                        [NSCharacterSet whitespaceCharacterSet]];
        if(userIdentification != nil ){
            NSArray* queryElements = [userIdentification componentsSeparatedByString: SEMICOLON_SEPARATOR];
            if(queryElements.count == 2){
                url = [url stringByAppendingString: @"&tokens=" ];
                NSString* tokenString = [queryElements objectAtIndex: 0];
                tokenString = [tokenString stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
                url = [url stringByAppendingString:tokenString];
                url = [url stringByAppendingString:@","];
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
@end
