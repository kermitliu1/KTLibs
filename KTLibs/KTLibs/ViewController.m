//
//  ViewController.m
//  KTLibs
//
//  Created by KermitLiu on 2017/3/6.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import "ViewController.h"
#import "KTDatePickerView.h"

@interface ViewController ()
{
    KTDatePickerView * _picker;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _picker = [[KTDatePickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-240, SCREEN_WIDTH, 240)];
    _picker.showTimeType = MonthDayHour_12Minute;
    [self.view addSubview:_picker];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn tapWithEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        // func
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
