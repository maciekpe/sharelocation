#import "LinkService.h"
#import "ContactsService.h"
#import "SLData.h"
#import "Consts.h"

@implementation LinkService

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
@end
