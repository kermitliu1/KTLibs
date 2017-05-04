//
//  KtAudioPlayerTool.h
//  KTLibs
//
//  Created by KermitLiu on 2017/5/4.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^PlayFinishCompletion)(NSError * error);

@interface KtAudioPlayerTool : NSObject

+ (KtAudioPlayerTool *)shareManager;
+ (void)playAudioWithFilePath:(NSString *)filePath playErrorCompletion:(PlayFinishCompletion)completion;
+ (void)stopPlay;

+ (AVAudioPlayer *)audioPlayer;

/**
 *  播放指定路径的语音文件
 *
 *  @param filePath 录制语音文件的路径
 *
 *  @param completion  播放完成的回调
 */
- (void)playAudioWithFilePath:(NSString *)filePath playErrorCompletion:(PlayFinishCompletion)completion;
/**
 *  停止播放
 */
- (void)stopPlay;


@end
