#import "SoundService.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SLData.h"
#import "LocationService.h"

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

- (BOOL) playDirectionSoundWith:(BOOL) isDistanceShorter {
    BOOL result = NO;
    if([self isSoundNeeded]){
        if(isDistanceShorter){
            result = [self playCorrectDirectionSound];
        }else{
            result = [self playIncorrectDirectionSound];
        }
    }
    return result;
}

- (BOOL) playCorrectDirectionSound {
    BOOL result = NO;
    __block SystemSoundID correctDirection;
    [self initSound:@"multimedia/audio/sonar" sound: &correctDirection];
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        AudioServicesPlaySystemSound(correctDirection);
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        AudioServicesDisposeSystemSoundID(correctDirection);
    });
    result = YES;
    return result;
}

- (BOOL) playIncorrectDirectionSound{
    BOOL result = NO;
    __block SystemSoundID incorrectDirection;
    [self initSound:@"multimedia/audio/error" sound: &incorrectDirection];
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        AudioServicesPlaySystemSound(incorrectDirection);
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        AudioServicesDisposeSystemSoundID(incorrectDirection);
    });
    /*
    new approache
    AudioServicesPlaySystemSoundWithCompletion(incorrectDirection,^(void){
        NSLog(@"played");
    });*/
    result = YES;
    return result;
}

- (void)initSound:(NSString *) pathToFile sound: (SystemSoundID *) soundID {
    NSString* path = [[NSBundle mainBundle] pathForResource:pathToFile ofType:@"wav"];
    NSURL* url = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, soundID);
}

-(BOOL) isSoundNeeded { 
    NSDate *now = [NSDate date];
    if(self.lastSoundDate !=nil){
        if( [now timeIntervalSinceDate:self.lastSoundDate] > 5 ) {
            [self setLastSoundDate:now];
            return YES;
        }else{
            return NO;
        }
    }else{
        [self setLastSoundDate:now];
        return YES;
    }
}

@end
