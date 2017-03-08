//
//  GetCGFloatManager.m
//  KTLibs
//
//  Created by KermitLiu on 2017/3/8.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import "GetCGFloatManager.h"

@implementation GetCGFloatManager

+ (GetCGFloatManager *)sharedManager {
    
    static GetCGFloatManager * manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[GetCGFloatManager alloc] init];
        }
    });
    return manager;
}

- (CGFloat)getWidthWithStr:(NSString *)text textFont:(float)font Height:(float)length {
    
    UIFont * textFont = [UIFont systemFontOfSize:font];
    // MAXFLOAT 为可设置的最大值
    CGSize size = CGSizeMake(MAXFLOAT,length);
    
    //获取当前那本属性
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:textFont,NSFontAttributeName, nil];
    //实际尺寸（需要自动调整什么，就取width或者height）
    CGSize actualSize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return actualSize.width+3;
    
}

- (CGFloat)getHeightWithStr:(NSString *)text textFont:(float)font Width:(float)length {
    
    UIFont * textFont = [UIFont systemFontOfSize:font];
    // MAXFLOAT 为可设置的最大值
    CGSize size = CGSizeMake(length, MAXFLOAT);
    //获取当前那本属性
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:textFont,NSFontAttributeName, nil];
    //实际尺寸（需要自动调整什么，就取width或者height）
    CGSize actualSize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return actualSize.height+3;
    
}



@end
