//
//  KtAudioManager.h
//  KTLibs
//
//  Created by KermitLiu on 2017/5/4.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ManagerStartRecordCompletion)(NSError * error);
/**
 *  停止录制 block
 *
 *  @param  recordPath  录制完成的文件路径
 *  @param  duration    录制时长
 *  @param  error       error
 */
typedef void(^ManagerStopRecordCompletion)(NSString * recordPath, NSInteger duration, NSError * error);

typedef void(^ManagerPlayFinishCompletion)(NSError * error);



/**
 *  audio record and play manager
 */
@interface KtAudioManager : NSObject

+ (KtAudioManager *)shareManager;

/**
 *  开始录制语音
 *
 *  @param  fileName 文件名
 *
 *  @param  completion 开始录制的回调
 */
- (void)startRecordingWithFileName:(NSString *)fileName completion:(ManagerStartRecordCompletion)completion;
/**
 *  停止录制语音
 *
 *  @param  completion 结束录制的回调
 */
- (void)stopRecordingWithCompletion:(ManagerStopRecordCompletion)completion;
/**
 *  取消录制
 *
 */
- (void)cancelRecording;
/**
 *  是否正在录制
 *
 */
- (BOOL)isRecording;
/**
 *  判断麦克风是否可用
 *
 */
- (BOOL)checkMicrophoneAvailability;
/**
 *  获取录音分贝
 *
 */
- (float)recordPeakPower;
/**
 *  获取音频文件的 时长和大小
 *
 *  @param  path 路径
 *  @return @{@"size":@(int),@"duration":@(int)}
 *
 */
- (NSDictionary *)getVideoInfoWithSourcePath:(NSString *)path;

/**
 *  播放录音
 *
 *  @param  filePath    文件路径
 *
 *  @param  completion  播放完成的回调
 */
- (void)playAudioWithPath:(NSString *)filePath completion:(ManagerPlayFinishCompletion)completion;
/**
 *  停止播放
 *
 */
- (void)stopPlay;
/**
 *  是否正在播放
 *
 */
- (BOOL)isPlaying;

@end
