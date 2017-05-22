//
//  UIButton+ImgAndTitleSet.h
//  KTLibs
//
//  Created by KermitLiu on 2017/5/22.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ImgAndTitleStyle) {
    ImgDown_TitleUp,
    ImgUp_TitleDown,
    ImgLeft_TitleRight,
    ImgRight_TitleLeft
};

@interface UIButton (ImgAndTitleSet)

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(ImgAndTitleStyle)style
                        imageTitleSpace:(CGFloat)space;

@end
