#import <Foundation/Foundation.h>
#import "LinkData.h"

@interface LinkService : NSObject
+ (instancetype) getInstance;
- (LinkData *) decomposeLinkDataFromUrl :(NSURL *)url;
@end
