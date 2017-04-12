//
//  UIButton+Block.h
//  KTLibs
//
//  Created by KermitLiu on 2017/4/12.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <objc/runtime.h>

typedef void(^clickBlock)(UIButton * sender);

@interface UIButton (Block)

- (void)tapWithEvent:(UIControlEvents)controlEvent withBlock:(clickBlock)click;

@end
