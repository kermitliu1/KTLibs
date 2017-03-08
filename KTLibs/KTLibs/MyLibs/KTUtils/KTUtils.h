//
//  KTUtils.h
//  KTLibs
//
//  Created by KermitLiu on 2017/3/8.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

#define _IS_EMPTY(_STR)     ([KTUtils isEmpty: _STR])
#define _EMPTY(_STR)        ([KTUtils empty: _STR])

#define _IMG(_IMGNAME)      ([KTUtils loadLocalImage:_IMGNAME ofType:@"png"])

#define _STORAGE_GET(_KEY)                  [KTUtils getValueFromUserDefaultsByKey: _KEY]
#define _STORAGE_SET_OBJECT(_KEY, _VALUE)   [KTUtils setUserDefaults:_KEY withValue:_VALUE]

#define _STORAGE_GET_ARRAY(_KEY)            [KTUtils retrieveArrayFromUserDefaults: _KEY]
#define _STORAGE_SET_ARRAY(_KEY, _VALUE)   [KTUtils setUserDefaults:_KEY withArray:_VALUE]

@interface KTUtils : NSObject

/**
 *  判断字符串或者字典是否为空
 *
 *  @param str  判断的字符串
 *
 *  @return     判断结果
 */
+ (BOOL)isEmpty:(id)str;

/**
 *  如果str == nil || str == null, 转化为空字符串
 *
 *  @param str  判断的字符串
 *
 *  @return     判断的结果
 */
+ (id)empty:(id)str;

/**
 *  判断两个字符串是否相等
 *
 *  @param str1     字符串1
 *  @param str2     字符串2
 *
 *  @return         结果
 */
+ (BOOL)equal:(NSString *)str1 to:(NSString *)str2;


/**
 *  保存信息到沙盒中
 *
 *  @param key          键
 *  @param value        值
 *
 *  @return             是否成功
 */
+ (BOOL)setUserDefaults:(NSString *)key withBoolValue:(BOOL)value;
+ (BOOL)setUserDefaults:(NSString *)key withDoubleValue:(double)value;
+ (BOOL)setUserDefaults:(NSString *)key withFloatValue:(float)value;
+ (BOOL)setUserDefaults:(NSString *)key withIntegerValue:(int)value;
+ (BOOL)setUserDefaults:(NSString *)key withURLValue:(NSURL *)value;
+ (BOOL)setUserDefaults:(NSString *)key withValue:(id)value;

// 数组存取
+ (BOOL)setUserDefaults:(NSString *)key withArray:(NSArray *)array;
+ (NSArray *)retrieveArrayFromUserDefaults:(NSString *)key;

/**
 *  从沙盒中取出信息
 *
 *  @param key      键
 *
 *  @return         值
 */
+ (id)getValueFromUserDefaultsByKey:(NSString *)key;





/**
 *  读取本地图片
 *
 *  @param imageName        文件名
 *  @param imageType        文件类型
 *
 *  @return                 图片
 */
+ (UIImage *)loadLocalImage:(NSString *)imageName ofType: (NSString *)imageType;


/**
 *  旋转图片，使上传的图片方向转正
 *
 *  @param image            图片
 *
 *  @return                 旋转后的图片
 */
+ (UIImage *)rotateImageOrientationUp:(UIImage *)image;

/**
 *  md5加密
 *
 *  @param input            待加密的字符串
 *
 *  @return                 加密的结果
 */
+ (NSString *) md5:(NSString *) input;

/**
 *  图片质量压缩
 *
 *  @param originImg        原图
 *  @param quality          比例（0-1）
 *
 *  @return                 结果
 */
+ (NSData *) compressImg:(UIImage *) originImg quality:(float) quality;

/**
 *  图片大小、质量压缩压缩
 *
 *  @param image            原图
 *  @param newSize          最后的大小
 *  @param isMax            isMax
 *
 *  @return                 压缩结果
 */
+ (UIImage *)resizeImg:(UIImage *) image toSize:(CGSize) newSize max:(BOOL)isMax;

/**
 *  随机字符串
 *
 *  @param len              长度
 *
 *  @return                 字符串
 */
+ (NSString *) randStr: (int) len;

/**
 *  指定文件名，获取tmp文件路径
 *
 *  @param fileName         指定文件名
 *
 *  @return                 文件路径
 */
+ (NSString *) getTmpDirFile:(NSString *) fileName;

/**
 *  获取tmp文件夹路径
 *
 *  @return     tmp文件夹路径
 */
+ (NSString *) getTmpDir;

/**
 *  获取Document文件夹路径
 *
 *  @return     Document文件夹路径
 */
+ (NSString *) getDocumentDir;

/**
 *  指定文件名，获取Document文件路径
 *
 *  @param fileName     文件名
 *
 *  @return             Document文件路径
 */
+ (NSString *) getDocumentDirFile: (NSString *)fileName;

/**
 *  从image url格式中提取图片的长宽。image url 的格式： xxx.jpg__width*height
 *
 *  @param formatImgUrl         imgUrl
 *
 *  @return                     CGSize
 */
+ (CGSize) imgSizeFromImgUrl: (NSString *) formatImgUrl;

/**
 *  通过颜色生成一个纯色的图片
 *
 *  @param color        颜色
 *  @param size         大小
 *
 *  @return             img
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;


@end
