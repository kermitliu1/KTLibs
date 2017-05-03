//
//  ViewController.m
//  KTLibs
//
//  Created by KermitLiu on 2017/3/6.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import "ViewController.h"

#import "DatePickerShowVC.h"
#import "KtInputViewDemoVC.h"

@interface ViewController ()
<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * _demoFuncArray;
}

@property (nonatomic, strong) UITableView * tableView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _demoFuncArray = @[@"KTDatePickerView",@"KtInputViewDemoVC",@"CacheClearManager"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}
//- (void)viewDidLayoutSubviews {
//    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [_tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])  {
//        [_tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _demoFuncArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = _demoFuncArray[indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController * vc = nil;
    if (indexPath.row == 0) {
        vc = [[DatePickerShowVC alloc] init];
    } else if (indexPath.row == 1) {
        vc = [[KtInputViewDemoVC alloc] init];
    }
    
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
