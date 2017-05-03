//
//  KtInputAudioRecordIndicatorView.m
//  KTLibs
//
//  Created by KermitLiu on 2017/5/3.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import "KtInputAudioRecordIndicatorView.h"

#define KtInput_ViewWidth 160
#define KtInput_ViewHeight 110

#define KtInput_TimeFontSize 30
#define KtInput_TipFontSize 15

@interface KtInputAudioRecordIndicatorView ()
{
    UIImageView *_backgrounView;
    UIImageView *_tipBackgroundView;
}

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *tipLabel;


@end

@implementation KtInputAudioRecordIndicatorView


- (instancetype)init {
    self = [super init];
    if(self) {
        
        self.frame = CGRectMake(0, 0, KtInput_ViewWidth, KtInput_ViewHeight);
        _backgrounView = [[UIImageView alloc] initWithImage:_IMG(@"record_indicator")];
        [self addSubview:_backgrounView];
        
        _tipBackgroundView = [[UIImageView alloc] initWithImage:_IMG(@"record_indicator_cancel")];
        _tipBackgroundView.hidden = YES;
        _tipBackgroundView.frame = CGRectMake(0, KtInput_ViewHeight - CGRectGetHeight(_tipBackgroundView.bounds), KtInput_ViewWidth, CGRectGetHeight(_tipBackgroundView.bounds));
        [self addSubview:_tipBackgroundView];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = [UIFont boldSystemFontOfSize:KtInput_TimeFontSize];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"00:00";
        [self addSubview:_timeLabel];
        
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.font = [UIFont systemFontOfSize:KtInput_TipFontSize];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = @"手指上滑，取消发送";
        [self addSubview:_tipLabel];
        
        self.phase = KtAudioRecordPhaseEnd;
    }
    return self;
}

- (void)setRecordTime:(NSTimeInterval)recordTime {
    NSInteger minutes = (NSInteger)recordTime / 60;
    NSInteger seconds = (NSInteger)recordTime % 60;
    _timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", minutes, seconds];
}

- (void)setPhase:(KtAudioRecordPhase)phase {
    
    if(phase == KtAudioRecordPhaseStart) {
        [self setRecordTime:0];
    } else if(phase == KtAudioRecordPhaseCancelling) {
        _tipLabel.text = @"松开手指，取消发送";
        _tipBackgroundView.hidden = NO;
    } else {
        _tipLabel.text = @"手指上滑，取消发送";
        _tipBackgroundView.hidden = YES;
    }
    
}

- (void)layoutSubviews {
    CGSize size = [_timeLabel sizeThatFits:CGSizeMake(KtInput_ViewWidth, MAXFLOAT)];
    _timeLabel.frame = CGRectMake(0, 36, KtInput_ViewWidth, size.height);
    size = [_tipLabel sizeThatFits:CGSizeMake(KtInput_ViewWidth, MAXFLOAT)];
    _tipLabel.frame = CGRectMake(0, KtInput_ViewHeight - 10 - size.height, KtInput_ViewWidth, size.height);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
