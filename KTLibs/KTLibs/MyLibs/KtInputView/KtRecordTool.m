//
//  KtRecordTool.m
//  KTLibs
//
//  Created by KermitLiu on 2017/5/4.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import "KtRecordTool.h"
#import <AVFoundation/AVFoundation.h>

@interface KtRecordTool ()
<AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioRecorder * audioRecorder;
@property (nonatomic, strong) AVAudioPlayer * audioPlayer;

@end

@implementation KtRecordTool

- (BOOL)checkMicrophoneAvailability{
    __block BOOL ret = NO;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if ([session respondsToSelector:@selector(requestRecordPermission:)]) {
        [session performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            ret = granted;
        }];
    } else {
        ret = YES;
    }
    
    return ret;
}


- (void)playAudioWithAudioURL:(NSURL *)audioURL {
    
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
    
    NSError * error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:&error];
    self.audioPlayer.delegate = self;
    
    BOOL success = [self.audioPlayer play];
    if (success) {
        NSLog(@"播放成功");
    }else{
        NSLog(@"播放失败");
    }
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
    //关闭红外感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    [self.audioPlayer stop];
    
}
// MARK: - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"%s", __func__);
    self.audioPlayer.delegate = nil;
    self.audioPlayer = nil;
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error{
    NSLog(@"%@", error);
}

- (void)recorderAudio {
    if (![self checkMicrophoneAvailability]) {
        NSLog(@"麦克风不可用");
        return;
    }
    
    NSError * error;
    NSString * url = NSTemporaryDirectory();    // temp
    url = [url stringByAppendingString:[NSString stringWithFormat:@"%f.wav", [[NSDate date] timeIntervalSince1970]]];
    
    NSMutableDictionary * settings = [NSMutableDictionary dictionary];
    [settings setObject:[NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];//采样率，8000是电话采样率，对一般的录音已经足够了
    [settings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [settings setObject:@1 forKey:AVNumberOfChannelsKey];//设置成一个通道，iPnone只有一个麦克风，一个通道已经足够了
    [settings setObject:@16 forKey:AVLinearPCMBitDepthKey];//采样的位数 8、16、24、32
    
    self.audioRecorder = [[AVAudioRecorder  alloc] initWithURL:[NSURL fileURLWithPath:url] settings:settings error:&error];
    self.audioRecorder.meteringEnabled = YES;
    self.audioRecorder.delegate = self;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
    BOOL success = [self.audioRecorder record];
    
    if (success) {
        NSLog(@"录音开始成功");
    }else{
        NSLog(@"录音开始失败");
    }
}


// MARK: - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    
    self.audioRecorder.delegate = nil;
    [self.audioRecorder stop];
    self.audioRecorder = nil;
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error{
    NSLog(@"%@", error);
}




@end
