//
//  DatePickerShowVC.m
//  KTLibs
//
//  Created by KermitLiu on 2017/5/3.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import "DatePickerShowVC.h"
#import "KTDatePickerView.h"

@interface DatePickerShowVC ()
<KTDatePickerViewDelegate>
{
    KTDatePickerView * _picker;
}

@property (nonatomic, strong) UIButton * timeBtn;

@end

@implementation DatePickerShowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _timeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _timeBtn.layer.cornerRadius = 3;
    _timeBtn.layer.borderWidth = 1;
    _timeBtn.layer.borderColor = [UIColor colorWithHexString:@"333333"].CGColor;
    [self.view addSubview:_timeBtn];
    [_timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(100);
        make.centerX.equalTo(self.view);
        make.size.mas_offset(CGSizeMake(100, 40));
    }];
    [_timeBtn setTitle:@"选择时间" forState:UIControlStateNormal];
    [_timeBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    _timeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_timeBtn tapWithEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [self showDatePicker];
    }];
    
    _picker = [[KTDatePickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 240)];
    _picker.delegate = self;
    _picker.showTimeType = MonthDayHour_12Minute;
    [self.view addSubview:_picker];
}
- (void)datePickerCancelBtnClicked {
    [self hiddenDatePicker];
    [_timeBtn setTitle:@"选择时间" forState:UIControlStateNormal];
}
- (void)datePickerOKBtnClicked {
     [self hiddenDatePicker];
    [_timeBtn setTitle:[_picker getSelectedDateStr] forState:UIControlStateNormal];
}

- (void)showDatePicker {
    [UIView animateWithDuration:0.5 animations:^{
        _picker.frame = CGRectMake(0, SCREEN_HEIGHT-240, SCREEN_WIDTH, 240);
    }];
}
- (void)hiddenDatePicker {
    [UIView animateWithDuration:0.5 animations:^{
        _picker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 240);
    }];
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
