//
//  KtInputAudioRecordIndicatorView.h
//  KTLibs
//
//  Created by KermitLiu on 2017/5/3.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KtInputType){
    KtInputTypeText = 1,
    KtInputTypeAudio = 2,
};

typedef NS_ENUM(NSInteger, KtAudioRecordPhase) {
    KtAudioRecordPhaseStart,
    KtAudioRecordPhaseRecording,
    KtAudioRecordPhaseCancelling,
    KtAudioRecordPhaseEnd
};

@interface KtInputAudioRecordIndicatorView : UIView


@property (nonatomic, assign) KtAudioRecordPhase phase;

@property (nonatomic, assign) NSTimeInterval recordTime;

@end
