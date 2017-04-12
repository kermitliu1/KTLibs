//
//  UIButton+Block.m
//  KTLibs
//
//  Created by KermitLiu on 2017/4/12.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import "UIButton+Block.h"

static const void *buttonKey = &buttonKey;

@implementation UIButton (Block)

- (void)tapWithEvent:(UIControlEvents)controlEvent withBlock:(clickBlock)click {
    
    objc_setAssociatedObject(self, buttonKey, click,  OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self addTarget:self action:@selector(btnClick:) forControlEvents:controlEvent];
}


- (void)btnClick:(UIButton *)sender {
    clickBlock btnClickBlock = objc_getAssociatedObject(sender, buttonKey);
    if (btnClickBlock) {
        btnClickBlock(sender);
    }
}

@end
