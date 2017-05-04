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
#import <MJRefresh.h>

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
    
    MJRefreshGifHeader * header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
    }];
    header.mj_h = 40;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    NSMutableArray * imgsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<20; i++) {
        NSString * imgName = [NSString stringWithFormat:@"loading_%d",i];
        UIImage * img = _IMG(imgName);
//        img = [self scaleToSize:img size:CGSizeMake(30, 26)];
        [imgsArray addObject:img];
    }
    
    UIImage * img1 = _IMG(@"toolview_voice");
    [header setImages:@[img1] forState:MJRefreshStateIdle];
    [header setImages:@[img1] forState:MJRefreshStatePulling];
    [header setImages:imgsArray forState:MJRefreshStateRefreshing];

    self.tableView.mj_header = header;
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
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
