#import "SoundService.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SLData.h"

@implementation SoundService

//brak testow UT

+ (instancetype) getInstance {
     static SoundService *service = nil;
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
         service = [[self alloc] init];
     });
     return service;
}

- (void) playCorrectDirectionSound {
    if([self isSoundNeeded]){
        __block SystemSoundID correctDirection;
        [self initSound:@"multimedia/audio/sonar" sound: &correctDirection];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            AudioServicesPlaySystemSound(correctDirection);
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            AudioServicesDisposeSystemSoundID(correctDirection);
        });
    }
}
- (void) playIncorrectDirectionSound{
    if([self isSoundNeeded]){
        __block SystemSoundID incorrectDirection;
        [self initSound:@"multimedia/audio/error" sound: &incorrectDirection];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            AudioServicesPlaySystemSound(incorrectDirection);
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            AudioServicesDisposeSystemSoundID(incorrectDirection);
        });
    }
}

- (void)initSound:(NSString *) pathToFile sound: (SystemSoundID *) soundID {
    NSString* path = [[NSBundle mainBundle] pathForResource:pathToFile ofType:@"wav"];
    NSURL* url = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, soundID);
}

-(BOOL) isSoundNeeded { 
    NSDate *now = [NSDate date];
    if([SLData getLastSound] !=nil){
        if( [now timeIntervalSinceDate:[SLData getLastSound]] > 5 ) {
            [SLData setLastSound:now];
            return YES;
        }else{
            return NO;
        }
    }else{
        [SLData setLastSound:now];
        return YES;
    }
}

@end
