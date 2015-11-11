#import <Foundation/Foundation.h>

@interface SoundService : NSObject
+ (SoundService*) getInstance ;
- (BOOL) playDirectionSoundWith:(BOOL) isDistanceShorter;
@property (nonatomic, strong, readwrite) NSDate* lastSoundDate;
@end
