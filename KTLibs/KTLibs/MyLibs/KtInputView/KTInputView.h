//
//  KTInputView.h
//  KTLibs
//
//  Created by KermitLiu on 2017/5/2.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZInputView.h"
#import "KtInputProtocol.h"
#import "KtInputAudioRecordIndicatorView.h"

@interface KTInputView : UIView

@property (nonatomic, strong) YZInputView * inputView;

/**
 *  是否正在录制，显示显示 KtInputAudioRecordIndicatorView 的判断
 *  开始录制的时候设置为 YES
 */
@property (assign, nonatomic, getter=isRecording) BOOL recording;

/**
 *  更新inputView高度的回调
 */
@property (nonatomic, copy) void(^inputTextStateHeightConfiBlock)(NSString *text,CGFloat inputViewHeigh);


/**
 *  设置代理
 */
- (void)setInputActionDelegate:(id<KtInputActionDelegate>)actionDelegate;
/**
 *  设置占位符 
 *  initWithFrame 初始化可行
 */
- (void)setInputTextPlaceHolder:(NSString*)placeHolder;
/**
 *  更新录制的时间
 */
- (void)updateAudioRecordTime:(NSTimeInterval)time;

@end
