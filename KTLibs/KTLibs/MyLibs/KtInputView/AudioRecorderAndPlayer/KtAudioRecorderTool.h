//
//  KtAudioRecorderTool.h
//  KTLibs
//
//  Created by KermitLiu on 2017/5/4.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^StartRecordCompletion)(NSError * error);
typedef void(^StopRecordCompletion)(NSString * filePath);

@interface KtAudioRecorderTool : NSObject

@property (nonatomic, copy) NSDictionary * recoredSettings;

+ (KtAudioRecorderTool *)shareManager;
+ (void)startRecordingWithSavedPath:(NSString *)filePath completion:(StartRecordCompletion)startCompletion;
+ (void)stopRecordingWithBackRecordPath:(StopRecordCompletion)stopCompletion;
+ (void)cancelRecording;

+ (AVAudioRecorder *)audioRecorder;

/**
 *  开始录制语音
 *
 *  @param filePath 录制语音文件的路径
 *
 *  @param startCompletion  是否成功开始录制的回调
 */
- (void)startRecordingWithSavedPath:(NSString *)filePath completion:(StartRecordCompletion)startCompletion;
/**
 *  停止录制语音
 *
 *  @param stopCompletion  停止录制的文件路径回调
 */
- (void)stopRecordingWithBackRecordPath:(StopRecordCompletion)stopCompletion;
/**
 *  取消录制
 *
 */
- (void)cancelRecording;


@end
