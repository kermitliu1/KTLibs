//
//  KtAudioPlayerTool.m
//  KTLibs
//
//  Created by KermitLiu on 2017/5/4.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import "KtAudioPlayerTool.h"

@interface KtAudioPlayerTool ()
<AVAudioPlayerDelegate>

@property (nonatomic, copy) void(^playFinish)(NSError * error);
@property (nonatomic, strong) AVAudioPlayer * audioPlayer;

@end

@implementation KtAudioPlayerTool

+ (KtAudioPlayerTool *)shareManager {
    
    static KtAudioPlayerTool * tool = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (tool == nil) {
            tool = [[KtAudioPlayerTool alloc] init];
        }
    });
    return tool;
}

+ (void)playAudioWithFilePath:(NSString *)filePath playErrorCompletion:(PlayFinishCompletion)completion {
    [[KtAudioPlayerTool shareManager] playAudioWithFilePath:filePath playErrorCompletion:completion];
}
+ (void)stopPlay {
    [[KtAudioPlayerTool shareManager] stopPlay];
}

+ (AVAudioPlayer *)audioPlayer {
    return [KtAudioPlayerTool shareManager].audioPlayer;
}


- (void)playAudioWithFilePath:(NSString *)filePath playErrorCompletion:(PlayFinishCompletion)completion {
    
    NSFileManager * fm = [NSFileManager defaultManager];
    self.playFinish = completion;
    NSError *error = nil;
    if (![fm fileExistsAtPath:filePath]) {
        error = [NSError errorWithDomain:@"file path not exist" code:0 userInfo:nil];
        if (self.playFinish) {
            self.playFinish(error);
        }
        
        return;
    }
    
    NSURL * wavUrl = [[NSURL alloc] initFileURLWithPath:filePath];
    
    //默认情况下扬声器播放
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    //建议播放之前设置yes，播放结束设置no，这个功能是开启红外感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    //添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sensorStateChange:)
                                                 name:@"UIDeviceProximityStateDidChangeNotification"
                                               object:nil];
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:wavUrl error:&error];
    if (error || !self.audioPlayer) {
        error = [NSError errorWithDomain:NSLocalizedString(@"error.initPlayerFail", @"Failed to initialize AVAudioPlayer")
                                    code:0
                                userInfo:nil];
        if (self.playFinish) {
            self.playFinish(error);
        }
        self.playFinish = nil;
        return;
    }
    self.audioPlayer.delegate = self;
    [self.audioPlayer prepareToPlay];
    
    [self.audioPlayer play];
    
}
-(void)sensorStateChange:(NSNotificationCenter *)notification {
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗
    if ([[UIDevice currentDevice] proximityState] == YES) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    } else {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

- (void)stopPlay {
    
    if(self.audioPlayer){
        //关闭红外感应
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        self.audioPlayer.delegate = nil;
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
    if (self.playFinish) {
        self.playFinish = nil;
    }
    
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    if (self.playFinish) {
        self.playFinish(nil);
    }
    if (self.audioPlayer) {
        self.audioPlayer.delegate = nil;
        self.audioPlayer = nil;
    }
    self.playFinish = nil;
    
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    if (self.playFinish) {
        NSError *error = [NSError errorWithDomain:NSLocalizedString(@"error.palyFail", @"Play failure")
                                             code:0
                                         userInfo:nil];
        self.playFinish(error);
    }
    if (self.audioPlayer) {
        self.audioPlayer.delegate = nil;
        self.audioPlayer = nil;
    }
}




@end
