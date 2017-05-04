//
//  KtAudioRecorderTool.m
//  KTLibs
//
//  Created by KermitLiu on 2017/5/4.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import "KtAudioRecorderTool.h"

@interface KtAudioRecorderTool ()
<AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder * audioRecorder;
@property (nonatomic, copy) void(^recoredFinish)(NSString * recoredPath);

@end

@implementation KtAudioRecorderTool

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (KtAudioRecorderTool *)shareManager {
    static KtAudioRecorderTool * tool = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (tool == nil) {
            tool = [[KtAudioRecorderTool alloc] init];
        }
    });
    
    return tool;
}
+ (void)startRecordingWithSavedPath:(NSString *)filePath completion:(StartRecordCompletion)startCompletion {
    [[KtAudioRecorderTool shareManager] startRecordingWithSavedPath:filePath completion:startCompletion];
}
+ (void)stopRecordingWithBackRecordPath:(StopRecordCompletion)stopCompletion {
    [[KtAudioRecorderTool shareManager] stopRecordingWithBackRecordPath:stopCompletion];
}
+ (void)cancelRecording {
    [[KtAudioRecorderTool shareManager] cancelRecording];
}

+ (AVAudioRecorder *)audioRecorder {
    return [KtAudioRecorderTool shareManager].audioRecorder;
}

- (NSDictionary *)recoredSettings {
    if (!_recoredSettings) {
        _recoredSettings = @{AVSampleRateKey:[NSNumber numberWithFloat:8000],
                             AVFormatIDKey:[NSNumber numberWithInt: kAudioFormatMPEG4AAC],
                             AVLinearPCMBitDepthKey:[NSNumber numberWithInt:16],
                             AVNumberOfChannelsKey:[NSNumber numberWithInt:1],
                             };
    }
    return _recoredSettings;
}


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


- (void)startRecordingWithSavedPath:(NSString *)filePath completion:(StartRecordCompletion)startCompletion {
    
    if (![self checkMicrophoneAvailability]) {
        NSLog(@"麦克风不可用");
        return;
    }
    
    
    NSError *error = nil;
    NSString *wavFilePath = [[filePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"acc"];
    NSURL * accUrl = [[NSURL alloc] initFileURLWithPath:wavFilePath];

    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:accUrl settings:self.recoredSettings
                                                    error:&error];
    self.audioRecorder.meteringEnabled = YES;
    self.audioRecorder.delegate = self;
    
    if (!self.audioRecorder || error ) {
        self.audioRecorder = nil;
        NSLog(@"录音开始失败");
        if (startCompletion) {
            startCompletion(error);
        }
        return;
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
    BOOL success = [self.audioRecorder record];
    if (success) {
        NSLog(@"录音开始成功");
        if (startCompletion) {
            startCompletion(nil);
        }
    } else {
        NSLog(@"录音开始失败");
    }

    
}
- (void)stopRecordingWithBackRecordPath:(StopRecordCompletion)stopCompletion {
    self.recoredFinish = stopCompletion;
    [self.audioRecorder stop];
}
- (void)cancelRecording {
    self.audioRecorder.delegate = nil;
    if (self.audioRecorder.recording) {
        [self.audioRecorder stop];
    }
    self.audioRecorder = nil;
    _recoredFinish = nil;
}

// MARK: - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    
    NSString *recordPath = [[recorder url] path];
    if (self.recoredFinish) {
        if (!flag) {
            recordPath = nil;
        }
        self.recoredFinish(recordPath);
    }
    self.audioRecorder = nil;
    self.recoredFinish = nil;
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    NSLog(@"%@",error);
}




@end
