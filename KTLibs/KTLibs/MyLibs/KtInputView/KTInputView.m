//
//  KTInputView.m
//  KTLibs
//
//  Created by KermitLiu on 2017/5/2.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import "KTInputView.h"
#import <AVFoundation/AVFoundation.h>


CGFloat topAndBottomSpace = 10;
CGFloat leftAndRightSpace = 10;

CGFloat leftBtnWidth = 35;
CGFloat rightBtnWidth = 45;
CGFloat rightBtnHeight = 35;

@interface KTInputView ()
{
    KtInputType  _inputType;
    BOOL _isInputTextState;
    CGFloat _lastInputTextHeight;
    NSString * _lastInputText;
}

@property (nonatomic, assign) KtAudioRecordPhase recordPhase;
@property (nonatomic, strong) KtInputAudioRecordIndicatorView *audioRecordIndicator;

@property (nonatomic, strong) UIButton * leftBtn;
@property (nonatomic, strong) UIButton * rightBtn;
@property (nonatomic, strong) UIButton * recordBtn;

@property (nonatomic, weak) id<KtInputActionDelegate> actionDelegate;

@end

@implementation KTInputView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initSubViews];
}

- (instancetype)init {
    if (self = [super init]) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}


// MARK: - 初始化
- (void)initSubViews {
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
    [self addSubview:line];
    
    _inputType = KtInputTypeText;
    _recordPhase = KtAudioRecordPhaseEnd;
    _isInputTextState = YES;
    
    _lastInputTextHeight = 55;
    _lastInputText = @"";
    
    [self leftBtn];
    [self rightBtn];
    [self inputView];
    [self recordBtn];
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_leftBtn];
        [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topAndBottomSpace);
            make.left.mas_equalTo(leftAndRightSpace);
            make.size.mas_equalTo(CGSizeMake(leftBtnWidth, leftBtnWidth));
        }];
        
        
        [_leftBtn setImage:_IMG(@"toolview_keyboard")
                  forState:UIControlStateNormal];
        [_leftBtn tapWithEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
            
            [self leftBtnClick:sender];
        }];
    }
    return _leftBtn;
}
- (void)leftBtnClick:(UIButton *)sender {
    
    _isInputTextState = !_isInputTextState;
    
    WEAKSELF
    if (_isInputTextState) {
        [self.inputView becomeFirstResponder];
        _inputView.hidden = NO;
        _recordBtn.hidden = YES;
        _inputType = KtInputTypeText;
        [_leftBtn setImage:_IMG(@"toolview_keyboard") forState:UIControlStateNormal];
        
        if (weakSelf.inputTextStateHeightConfiBlock) {
            weakSelf.inputTextStateHeightConfiBlock(_lastInputText, _lastInputTextHeight);
        }
        
    } else {
        [self.inputView resignFirstResponder];
        _inputView.hidden = YES;
        _recordBtn.hidden = NO;
        _inputType = KtInputTypeAudio;
        [_leftBtn setImage:_IMG(@"toolview_voice") forState:UIControlStateNormal];
        
        if (weakSelf.inputTextStateHeightConfiBlock) {
            weakSelf.inputTextStateHeightConfiBlock(@"", 55);
        }
    }
    
}

- (UIView *)inputView {
    if (!_inputView) {
        _inputView = [[YZInputView alloc] init];
        [self addSubview:_inputView];
        
        [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topAndBottomSpace);
            make.left.mas_equalTo(leftAndRightSpace*2+leftBtnWidth);
            make.bottom.mas_equalTo(-topAndBottomSpace);
            make.right.mas_equalTo(-(leftAndRightSpace*2+rightBtnWidth));
        }];
        
        _inputView.textColor = [UIColor colorWithHexString:@"333333"];
        _inputView.font = [UIFont systemFontOfSize:14.0];
        // 监听文本框文字高度改变
        WEAKSELF
        _inputView.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight){
            
            // 文本框文字高度改变会自动执行这个【block】，可以在这【修改底部View的高度】
            // 设置底部条的高度 = 文字高度 + textView距离上下间距约束
            // 为什么添加10 ？（20 = 底部View距离上（10）底部View距离下（10）间距总和）
            
//            self.bottomHeight.constant = MAX(textHeight, 35) + 20;
        
            if (weakSelf.inputTextStateHeightConfiBlock) {
                _lastInputText = text;
                _lastInputTextHeight = MAX(textHeight, 35) + 20;
                weakSelf.inputTextStateHeightConfiBlock(text, MAX(textHeight, 35) + 20);
            }
        };
        
        // 设置文本框最大行数
        _inputView.maxNumberOfLines = 4;
    }
    return _inputView;
}

- (UIButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordBtn.layer.borderWidth = 1;
        _recordBtn.layer.cornerRadius = 5;
        _recordBtn.layer.masksToBounds = YES;
        _recordBtn.layer.borderColor = [UIColor colorWithHexString:@"d7d7d7"].CGColor;
        [self addSubview:_recordBtn];
        _recordBtn.hidden = YES;
        [_recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topAndBottomSpace);
            make.left.mas_equalTo(leftAndRightSpace*2+leftBtnWidth);
            make.bottom.mas_equalTo(-topAndBottomSpace);
            make.right.mas_equalTo(-(leftAndRightSpace*2+rightBtnWidth));
        }];
        
        [_recordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
        [_recordBtn setTitle:@"松开结束" forState:UIControlStateHighlighted];
        [_recordBtn setBackgroundImage:_IMG(@"voice_record_heighted") forState:UIControlStateHighlighted];
        [_recordBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        _recordBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];

        
        [_recordBtn addTarget:self action:@selector(onTouchVoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_recordBtn addTarget:self action:@selector(onTouchRecordBtnDown:) forControlEvents:UIControlEventTouchDown];
        [_recordBtn addTarget:self action:@selector(onTouchRecordBtnDragInside:) forControlEvents:UIControlEventTouchDragInside];
        [_recordBtn addTarget:self action:@selector(onTouchRecordBtnDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
        [_recordBtn addTarget:self action:@selector(onTouchRecordBtnUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_recordBtn addTarget:self action:@selector(onTouchRecordBtnUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _recordBtn;
}
- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_rightBtn];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topAndBottomSpace);
            make.right.mas_equalTo(-leftAndRightSpace);
            make.size.mas_equalTo(CGSizeMake(rightBtnWidth, rightBtnHeight));
        }];
        
        [_rightBtn setTitle:@"发送" forState:UIControlStateNormal];
        _rightBtn.titleLabel.textColor = [UIColor whiteColor];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_rightBtn setBackgroundImage:[_IMG(@"toolview_send") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                             forState:UIControlStateNormal];
        [_rightBtn tapWithEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
            
            if ([_actionDelegate respondsToSelector:@selector(onSendText:)]) {
                [_actionDelegate onSendText:self.inputView.text];
            }
            
        }];
    }
    return _rightBtn;
}

- (KtInputAudioRecordIndicatorView *)audioRecordIndicator {
    if(!_audioRecordIndicator) {
        _audioRecordIndicator = [[KtInputAudioRecordIndicatorView alloc] init];
    }
    return _audioRecordIndicator;
}

// MARK: -
- (void)setRecording:(BOOL)recording {
    
    if(recording) {
        
        self.audioRecordIndicator.center = self.superview.center;
        [self.superview addSubview:self.audioRecordIndicator];
        self.recordPhase = KtAudioRecordPhaseRecording;
        
    } else {
        
        [self.audioRecordIndicator removeFromSuperview];
        self.recordPhase = KtAudioRecordPhaseEnd;
        
    }
    _recording = recording;
}
- (void)setInputActionDelegate:(id<KtInputActionDelegate>)actionDelegate {
    self.actionDelegate = actionDelegate;
}
- (void)setInputTextPlaceHolder:(NSString *)placeHolder {
    self.inputView.placeholder = placeHolder;
}
- (void)updateAudioRecordTime:(NSTimeInterval)time {
    self.audioRecordIndicator.recordTime = time;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.actionDelegate = nil;
}




- (void)setRecordPhase:(KtAudioRecordPhase)recordPhase {
    
    KtAudioRecordPhase prevPhase = _recordPhase;
    _recordPhase = recordPhase;
    
    self.audioRecordIndicator.phase = _recordPhase;
    
    if(prevPhase == KtAudioRecordPhaseEnd) {
        
        if(KtAudioRecordPhaseStart == _recordPhase) {
            
            KTLog(@"onStartRecording");
            if ([_actionDelegate respondsToSelector:@selector(onStartRecording)]) {
                [_actionDelegate onStartRecording];
            }
            
        }
        
    } else if (prevPhase == KtAudioRecordPhaseStart || prevPhase == KtAudioRecordPhaseRecording) {
        
        if (KtAudioRecordPhaseEnd == _recordPhase) {
            
            KTLog(@"onStopRecording");
            if ([_actionDelegate respondsToSelector:@selector(onStopRecording)]) {
                [_actionDelegate onStopRecording];
            }
        }
        
    } else if (prevPhase == KtAudioRecordPhaseCancelling) {
        
        if(KtAudioRecordPhaseEnd == _recordPhase) {
            
            KTLog(@"onCancelRecording");
            if ([_actionDelegate respondsToSelector:@selector(onCancelRecording)]) {
                [_actionDelegate onCancelRecording];
            }
            
        }
        
    }
}

#pragma mark - button actions
- (void)onTouchVoiceBtn:(id)sender {
    
    // image change
    if (_inputType!= KtInputTypeAudio) {
        
        
        if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
            [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _inputType = KtInputTypeAudio;
                        
//                        if ([self.toolBar.inputTextView isFirstResponder]) {
//                            _inputBottomViewHeight = 0;
//                            [self.toolBar.inputTextView resignFirstResponder];
//                        } else if (_inputBottomViewHeight > 0)
//                        {
//                            _inputBottomViewHeight = 0;
//                            [self willShowBottomHeight:_inputBottomViewHeight];
//                        }
//                        [self inputTextViewToHeight:[[[NIMKitUIConfig sharedConfig] globalConfig] topInputViewHeight]];;
//                        [self updateAllButtonImages];
                    });
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:nil
                                                    message:@"没有麦克风权限"
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil] show];
                    });
                }
            }];
        }
    } else
    {
//        if (self.toolBar.inputTextView.superview) {
//            _inputType = InputTypeText;
//            [self inputTextViewToHeight:[self getTextViewContentH:self.toolBar.inputTextView]];;
//            [self.toolBar.inputTextView becomeFirstResponder];
//            [self updateAllButtonImages];
//        }
    }
}
- (void)onTouchRecordBtnDown:(id)sender {
    self.recordPhase = KtAudioRecordPhaseStart;
}
- (void)onTouchRecordBtnUpInside:(id)sender {
    // finish Recording
    self.recordPhase = KtAudioRecordPhaseEnd;
}
- (void)onTouchRecordBtnUpOutside:(id)sender {
    //TODO cancel Recording
    self.recordPhase = KtAudioRecordPhaseEnd;
}

- (void)onTouchRecordBtnDragInside:(id)sender {
    //TODO @"手指上滑，取消发送"
    self.recordPhase = KtAudioRecordPhaseRecording;
}
- (void)onTouchRecordBtnDragOutside:(id)sender {
    //TODO @"松开手指，取消发送"
    self.recordPhase = KtAudioRecordPhaseCancelling;
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
