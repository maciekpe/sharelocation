#import <Foundation/Foundation.h>

@interface SoundService : NSObject
+ (SoundService*) getInstance ;
- (void) playCorrectDirectionSound;
- (void) playIncorrectDirectionSound;
@end