//
//  KtAudioManager.m
//  KTLibs
//
//  Created by KermitLiu on 2017/5/4.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import "KtAudioManager.h"
#import "KtAudioRecorderTool.h"
#import "KtAudioPlayerTool.h"

typedef NS_ENUM(NSUInteger, KtAudioSession) {
    Kt_DEFAULT = 0,
    Kt_AUDIOPLAYER,
    Kt_AUDIORECORDER,
};

@interface KtAudioManager ()
{
    // recorder
    NSDate              * _recorderStartDate;
    NSDate              * _recorderEndDate;
    NSString            * _currCategory;
    BOOL                _currActive;
    
    // proximitySensor
    BOOL _isSupportProximitySensor;
    BOOL _isCloseToUser;
}


@end

@implementation KtAudioManager

+ (KtAudioManager *)shareManager {
    
    static KtAudioManager * manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[KtAudioManager alloc] init];
    });
    return manager;
}


// MARK: - audio record
+ (NSTimeInterval)recordMinDuration{
    return 1.0;
}
- (BOOL)checkMicrophoneAvailability {
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
- (void)startRecordingWithFileName:(NSString *)fileName completion:(ManagerStartRecordCompletion)completion {
    
    NSError * error = nil;
    if (![[KtAudioManager shareManager] checkMicrophoneAvailability]) {
        NSLog(@"麦克风不可用");
        return;
    }
    
    // 判断当前是否是录音状态
    if ([self isRecording]) {
        if (completion) {
            error = [NSError errorWithDomain:@"Record voice is not over yet"
                                        code:0
                                    userInfo:nil];
            completion(error);
        }
        return ;
    }
    
    // 文件名不存在
    if (!fileName || [fileName length] == 0) {
        error = [NSError errorWithDomain:@"File path not exist"
                                    code:0
                                userInfo:nil];
        completion(error);
        return ;
    }
    
    BOOL isNeedSetActive = YES;
    if ([self isRecording]) {
        [[KtAudioManager shareManager] cancelRecording];
        isNeedSetActive = NO;
    }
    [self setupAudioSessionCategory:Kt_AUDIORECORDER isActive:YES];
    
    _recorderStartDate = [NSDate date];
    
    NSString * recordPath = NSHomeDirectory();
    recordPath = [NSString stringWithFormat:@"%@/Library/AudioFiles/%@",recordPath,fileName];
    NSFileManager * fm = [NSFileManager defaultManager];
    
    if(![fm fileExistsAtPath:[recordPath stringByDeletingLastPathComponent]]){
        [fm createDirectoryAtPath:[recordPath stringByDeletingLastPathComponent]
      withIntermediateDirectories:YES
                       attributes:nil
                            error:nil];
    }
    [[KtAudioRecorderTool shareManager] startRecordingWithSavedPath:recordPath completion:completion];
    
}
- (void)stopRecordingWithCompletion:(ManagerStopRecordCompletion)completion {
    
    NSError *error = nil;
    // 当前是否在录音
    if(![self isRecording]){
        if (completion) {
            error = [NSError errorWithDomain:@"Recording has not yet begun"
                                        code:0
                                    userInfo:nil];
            completion(nil,0,error);
            return;
        }
    }
    
    __weak typeof(self) weakSelf = self;
    _recorderEndDate = [NSDate date];
    
    if([_recorderEndDate timeIntervalSinceDate:_recorderStartDate] < [KtAudioManager recordMinDuration]){
        if (completion) {
            error = [NSError errorWithDomain:@"Recording time is too short"
                                        code:0
                                    userInfo:nil];
            completion(nil,0,error);
        }
        
        // 如果录音时间较短，延迟1秒停止录音（iOS中，如果快速开始，停止录音，UI上会出现红条,为了防止用户又迅速按下，UI上需要也加一个延迟，长度大于此处的延迟时间，不允许用户循序重新录音。PS:研究了QQ和微信，就这么玩的,聪明）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([KtAudioManager recordMinDuration] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            KtAudioRecorderTool * recordTool = [KtAudioRecorderTool shareManager];
            [recordTool stopRecordingWithBackRecordPath:^(NSString *filePath) {
                [weakSelf setupAudioSessionCategory:Kt_DEFAULT isActive:NO];
            }];

            
        });
        return ;
    }
    
    [[KtAudioRecorderTool shareManager] stopRecordingWithBackRecordPath:^(NSString *filePath) {
        if (completion) {
            if (filePath) {
                completion(filePath,(int)[self->_recorderEndDate timeIntervalSinceDate:self->_recorderStartDate],nil);
            }
            [weakSelf setupAudioSessionCategory:Kt_DEFAULT isActive:NO];
        }
    }];
    
}
- (void)cancelRecording {
    [[KtAudioRecorderTool shareManager] cancelRecording];
}

- (BOOL)isRecording {
    return [KtAudioRecorderTool audioRecorder].recording;
}
#pragma mark - Private
-(NSError *)setupAudioSessionCategory:(KtAudioSession)session isActive:(BOOL)isActive {
    BOOL isNeedActive = NO;
    if (isActive != _currActive) {
        isNeedActive = YES;
        _currActive = isActive;
    }
    NSError *error = nil;
    NSString *audioSessionCategory = nil;
    switch (session) {
        case Kt_AUDIOPLAYER:
            // 设置播放category
            audioSessionCategory = AVAudioSessionCategoryPlayback;
            break;
        case Kt_AUDIORECORDER:
            // 设置录音category
            audioSessionCategory = AVAudioSessionCategoryRecord;
            break;
        default:
            // 还原category
            audioSessionCategory = AVAudioSessionCategoryAmbient;
            break;
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    // 如果当前category等于要设置的，不需要再设置
    if (![_currCategory isEqualToString:audioSessionCategory]) {
        [audioSession setCategory:audioSessionCategory error:nil];
    }
    if (isNeedActive) {
        BOOL success = [audioSession setActive:isActive
                                   withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                                         error:&error];
        if(!success || error){
            error = [NSError errorWithDomain:@"Failed to initialize AVAudioPlayer"
                                        code:0
                                    userInfo:nil];
            return error;
        }
    }
    _currCategory = audioSessionCategory;
    
    return error;
}

- (float)recordPeakPower {
    float ret = 0.0;
    if ([KtAudioRecorderTool audioRecorder].isRecording) {
        [[KtAudioRecorderTool audioRecorder] updateMeters];
        //获取音量的平均值  [recorder averagePowerForChannel:0];
        //音量的最大值  [recorder peakPowerForChannel:0];
        double lowPassResults = pow(10, (0.05 * [[KtAudioRecorderTool audioRecorder] peakPowerForChannel:0]));
        ret = lowPassResults;
    }
    return ret;
}
- (NSDictionary *)getVideoInfoWithSourcePath:(NSString *)path {
    
    AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    CMTime time = [asset duration];
    int seconds = ceil(time.value/time.timescale);
    
    NSInteger fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    
    return @{@"size" : @(fileSize),
             @"duration" : @(seconds)};
}

// MARK: - audio play
- (void)playAudioWithPath:(NSString *)filePath completion:(ManagerPlayFinishCompletion)completion {
    
    BOOL isNeedSetActive = YES;
    // 如果正在播放音频，停止当前播放。
    if([KtAudioPlayerTool audioPlayer].isPlaying){
        [[KtAudioPlayerTool shareManager] stopPlay];
        isNeedSetActive = NO;
    }
    
    if (isNeedSetActive) {
        // 设置播放时需要的category
        [self setupAudioSessionCategory:Kt_AUDIOPLAYER
                               isActive:YES];
    }
    NSString * accfilePath = [[filePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"acc"];
    //如果转换后的acc文件不存在, 则去转换一下
    [KtAudioPlayerTool playAudioWithFilePath:accfilePath playErrorCompletion:^(NSError *error) {
        [self setupAudioSessionCategory:Kt_DEFAULT
                               isActive:NO];
        if (completion) {
            completion(error);
        }
    }];

}
- (void)stopPlay {
    [KtAudioPlayerTool stopPlay];
    [self setupAudioSessionCategory:Kt_DEFAULT isActive:NO];
}
- (BOOL)isPlaying {
    return [KtAudioPlayerTool audioPlayer].isPlaying;
}




@end
