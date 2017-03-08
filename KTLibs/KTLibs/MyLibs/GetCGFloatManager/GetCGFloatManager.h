//
//  GetCGFloatManager.h
//  KTLibs
//
//  Created by KermitLiu on 2017/3/8.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GetCGFloatManager : NSObject

+ (GetCGFloatManager *)sharedManager;

/**
 * 获取宽度
 * @param text          要获取的字符串
 * @param font          字符大小
 * @param length        固定高度的尺寸
 *
 * @return WidthValue
 */
- (CGFloat)getWidthWithStr:(NSString *)text textFont:(float)font Height:(float)length;
/**
 * 获取高度
 * @param text          要获取的字符串
 * @param font          字符大小
 * @param length        固定长度的尺寸
 *
 * @return HeightValue
 */
- (CGFloat)getHeightWithStr:(NSString *)text textFont:(float)font Width:(float)length;

@end
