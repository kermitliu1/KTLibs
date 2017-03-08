//
//  KTDatePickerView.m
//  KTLibs
//
//  Created by KermitLiu on 2017/3/8.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import "KTDatePickerView.h"

@interface KTDatePickerView ()

@property (nonatomic, strong) UIView * topBGView;
@property (nonatomic, strong) UIButton * cancelBtn;
@property (nonatomic, strong) UILabel * showDateLabel;
@property (nonatomic, strong) UIButton * okBtn;
@property (nonatomic, strong) UIDatePicker * datePicker;

@end

@implementation KTDatePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _topBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _topBGView.backgroundColor = [UIColor grayColor];
        [self addSubview:_topBGView];
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancelBtn.frame = CGRectMake(7, 0, 44, 44);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_topBGView addSubview:_cancelBtn];
        
        _okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _okBtn.frame = CGRectMake(SCREEN_WIDTH - 7 - 44, 0, 44, 44);
        [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
        _okBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_okBtn addTarget:self action:@selector(okBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_topBGView addSubview:_okBtn];
        
        _showDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, SCREEN_WIDTH-110, 44)];
        _showDateLabel.backgroundColor = [UIColor clearColor];
        _showDateLabel.textColor = [UIColor whiteColor];
        _showDateLabel.font = [UIFont systemFontOfSize:14];
        _showDateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_showDateLabel];
        
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, frame.size.height-44)];
        _datePicker.date = [NSDate date];
        [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_datePicker];
        
        _showDateLabel.text = [self dealWithDate:[NSDate date]];
        
    }
    return self;
}

- (void)setShowTimeType:(ShowTimeType)showTimeType {
    _showTimeType = showTimeType;
    switch (showTimeType) {
        case 0:
            _datePicker.datePickerMode = UIDatePickerModeDate;
            break;
        default:
            _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            break;
    }
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode {
    _datePicker.datePickerMode = datePickerMode;
}
- (void)setMinimumDate:(NSDate *)minimumDate {
    _datePicker.minimumDate = minimumDate;
}
- (void)setMaximumDate:(NSDate *)maximumDate {
    _datePicker.maximumDate = maximumDate;
}
- (void)setTopBGColor:(UIColor *)topBGColor {
    _topBGView.backgroundColor = topBGColor;
}
- (void)setTopTimeLabelColor:(UIColor *)topTimeLabelColor {
    _showDateLabel.textColor = topTimeLabelColor;
}
- (void)setCancelBtnTitleColor:(UIColor *)cancelBtnTitleColor {
    [_cancelBtn setTitleColor:cancelBtnTitleColor forState:UIControlStateNormal];
}
- (void)setOkBtnTitleColor:(UIColor *)okBtnTitleColor {
    [_okBtn setTitleColor:okBtnTitleColor forState:UIControlStateNormal];
}

- (void)datePickerValueChanged:(UIDatePicker *)sender {
    
    _showDateLabel.text = [self dealWithDate:[sender date]];
    
}

- (NSString *)dealWithDate:(NSDate *)date {
    
    NSDateFormatter * selectedDateFormatter = [[NSDateFormatter alloc] init];
    switch (self.showTimeType) {
        case 0:
            selectedDateFormatter.dateFormat = @"YYYY-MM-dd";
            break;
        case 1:
            selectedDateFormatter.dateFormat = @"YYYY-MM-dd hh:mm";
            break;
        case 2:
            selectedDateFormatter.dateFormat = @"YYYY-MM-dd HH:mm";
            break;
        case 3:
            selectedDateFormatter.dateFormat = @"MM-dd hh:mm";
            break;
        case 4:
            selectedDateFormatter.dateFormat = @"MM-dd HH:mm";
            break;
            
        default:
            break;
    }
    KTLog(@"%@",[selectedDateFormatter stringFromDate:date]);
    return [selectedDateFormatter stringFromDate:date];
}

- (void)cancelBtnClicked {
    if (_delegate && [_delegate respondsToSelector:@selector(datePickerCancelBtnClicked)]) {
        [_delegate datePickerCancelBtnClicked];
    }
}

- (void)okBtnClicked {
    if (_delegate && [_delegate respondsToSelector:@selector(datePickerOKBtnClicked)]) {
        [_delegate datePickerOKBtnClicked];
    }
}

- (NSString *)getSelectedDateStr {
    return _showDateLabel.text;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
