//
//  KTBasicConfig.h
//  KTLibs
//
//  Created by KermitLiu on 2017/3/8.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#ifndef KTBasicConfig_h
#define KTBasicConfig_h

#define STORYBOARD          ([UIStoryboard storyboardWithName:@"MeiYeBang" bundle:nil])
#define PLATFORM            (@"iOS")
// app版本号
#define APP_STORE_VERSION   ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])


#define SYSTEM_VERSION  ([[UIDevice currentDevice] systemVersion])
#define IOS8            ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)
#define iOS10           ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0)

#define SET_UIStatusBarStyleDefault         ([[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES])
#define SET_UIStatusBarStyleLightContent    ([[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES])
#define SET_UIStatusBarHidden_YES           ([[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationSlide)])
#define SET_UIStatusBarHidden_NO            ([[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)])

#define SET_NavigationBarHidden_YES         ([self.navigationController setNavigationBarHidden:YES animated:YES])
#define SET_NavigationBarHidden_NO          ([self.navigationController setNavigationBarHidden:NO animated:YES])


#define NAVBAR_POP_OPEN     if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {\
self.navigationController.interactivePopGestureRecognizer.delegate = nil;\
}

// 设置背景色和导航栏阴影
#define SET_NavBGImg    ([self.navigationController.navigationBar setBackgroundImage:_IMG(@"NavBGImg") forBarMetrics:UIBarMetricsDefault])
#define SET_NavNoBlackLine if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])\
{\
NSArray *list=self.navigationController.navigationBar.subviews;\
for (id obj in list) {\
if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0){\
UIView *view =   (UIView*)obj;\
for (id obj2 in view.subviews) {\
if ([obj2 isKindOfClass:[UIImageView class]]) {\
UIImageView *image =  (UIImageView*)obj2;\
image.hidden = YES;\
}\
}\
} else {\
if ([obj isKindOfClass:[UIImageView class]]) {\
UIImageView *imageView=(UIImageView *)obj;\
NSArray *list2=imageView.subviews;\
for (id obj2 in list2) {\
if ([obj2 isKindOfClass:[UIImageView class]]) {\
UIImageView *imageView2=(UIImageView *)obj2;\
imageView2.hidden=YES;\
}\
}\
}\
}\
}\
}


// MARK:- Nav
#define STYLIST_APP_COLOR [UIColor colorWithHexString:@"ffffff"]
#define NAVBARITEM_COLOR  ([UIColor colorWithHexString:@"2195ed"])

#ifdef __IPHONE_6_0 // iOS6 and later
#   define UITextAlignmentCenter    NSTextAlignmentCenter
#   define UITextAlignmentLeft      NSTextAlignmentLeft
#   define UITextAlignmentRight     NSTextAlignmentRight
#   define UILineBreakModeHeadTruncation NSLineBreakByTruncatingHead
#   define UILineBreakModeTailTruncation     NSLineBreakByTruncatingTail
#   define UILineBreakModeMiddleTruncation   NSLineBreakByTruncatingMiddle
#   define UILineBreakModeWordWrap NSLineBreakByWordWrapping
#endif

#ifdef __IPHONE_7_0 // iOS6 and later
#   define UITextAttributeFont    NSFontAttributeName
#   define UITextAttributeTextColor    NSForegroundColorAttributeName
#endif


// MARK:-
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define FIT_750_HEIGHT (SCREEN_HEIGHT/667.0)
#define FIT_750_WIDTH (SCREEN_WIDTH/375.0)

#define iPhone6p ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define WEAKSELF    typeof(self) __weak weakSelf = self;
#define STRONGSELF  typeof(weakSelf) __strong strongSelf = weakSelf;


#define ToastTime           1.5
#define ToastNetErrorMsg    (@"网络请求超时")


// MARK:------ Log ------
#ifdef DEBUG    // 调试阶段
#define KTLog(xx, ...) NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else   // 发布阶段
#define KTLog(...)
#endif

#ifndef __OPTIMIZE__
#define NSLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#endif

#define __DEBUG YES
// MARK:------  ------


#define HUD_SHOW_NET_ERROR          [self.hud showErrorWithMessage:ToastNetErrorMsg duration:ToastTime complection:^{\
[self.hud hide];\
}];

#define HUD_SHOW_RESPONSEOBJECT_ERROR        [self.hud showErrorWithMessage:responseObject[@"msg"] duration:ToastTime complection:^{\
[self.hud hide];\
}];




#endif /* KTBasicConfig_h */
