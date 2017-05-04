//
//  KtInputViewDemoVC.m
//  KTLibs
//
//  Created by KermitLiu on 2017/5/3.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import "KtInputViewDemoVC.h"
#import "KTInputView.h"

#import "KtAudioManager.h"

@interface KtInputViewDemoVC ()
<KtInputActionDelegate>
{
    int _second;
    NSTimer * _timer;
    
    NSString * _filePath;
}

@property (nonatomic, strong) KTInputView * ktInputView;

@end

@implementation KtInputViewDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _second = 0;
    
    [self ktInputView];
}

- (KTInputView *)ktInputView {
    if (!_ktInputView) {
        
        _ktInputView = [[KTInputView alloc] init];
        [_ktInputView setInputActionDelegate:self];
        // 监听键盘弹出
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [self.view addSubview:_ktInputView];
        [_ktInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(55);
        }];
        _ktInputView.backgroundColor = [UIColor whiteColor];
        WEAKSELF
        _ktInputView.inputTextStateHeightConfiBlock = ^(NSString *text, CGFloat inputViewHeigh) {
            
            [weakSelf.ktInputView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(inputViewHeigh);
            }];
        };
        
    }
    return _ktInputView;
}
// 键盘弹出会调用
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 获取键盘frame
    CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 获取键盘弹出时长
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    // 修改底部视图距离底部的间距
    [_ktInputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-(endFrame.origin.y != screenH?endFrame.size.height:0));
    }];
    
    // 约束动画
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

// MARK: KtInputActionDelegate
- (void)onSendText:(NSString *)text {
    
    [self addTimer];
    
    if (_filePath) {
        [[KtAudioManager shareManager] playAudioWithPath:_filePath completion:^(NSError *error) {
            
            KTLog(@"播放完成");
            [self closeTimer];
            
        }];
    }

}

- (void)onCancelRecording {
    _second = 0;
    [self closeTimer];
    _ktInputView.recording = NO;
    
    [[KtAudioManager shareManager] cancelRecording];
}

- (void)onStopRecording {

    
    [[KtAudioManager shareManager] stopRecordingWithCompletion:^(NSString *recordPath, NSInteger duration, NSError *error) {
        
        _second = 0;
        [self closeTimer];
        _ktInputView.recording = NO;
        
        _filePath = recordPath;
        KTLog(@"recordPath:%@\n duration:%.2ld",recordPath,(long)duration);
        
    }];
    
}

- (void)onStartRecording {
    
    _ktInputView.recording = YES;
    
    [self addTimer];
    
    NSString * fileName = [NSString stringWithFormat:@"%lld.acc",(long long)[[NSDate date] timeIntervalSince1970]];
    [[KtAudioManager shareManager] startRecordingWithFileName:fileName completion:^(NSError *error) {
        
    }];
    
}

- (void)recording {

//    [_ktInputView updateAudioRecordTime:++_second];
    KTLog(@"%d",++_second);

}

/**
 *  添加定时器
 */
-(void)addTimer
{
    _timer =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recording) userInfo:nil repeats:YES];
    //多线程 UI IOS程序默认只有一个主线程，处理UI的只有主线程。如果拖动第二个UI，则第一个UI事件则会失效。
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/**
 *  关闭定时器
 */
-(void)closeTimer
{
    [_timer invalidate];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
