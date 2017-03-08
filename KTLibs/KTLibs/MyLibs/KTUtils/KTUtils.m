//
//  KTUtils.m
//  KTLibs
//
//  Created by KermitLiu on 2017/3/8.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import "KTUtils.h"

@implementation KTUtils

#pragma mark - 判断字符串或者字典是否为空
+ (BOOL)isEmpty:(id)str {
    return str == nil || str == [NSNull null] ||
    ([str isKindOfClass:[NSString class]] && ((NSString *)str).length == 0) ||
    ([str isKindOfClass:[NSDictionary class]] && ((NSDictionary *)str).allKeys.count == 0);
}

#pragma mark - 如果str == nil || str == null, 转化为空字符串
+ (id)empty:(id)str {
    return (str == nil || str == [NSNull null]) ? @"" : str;
}

#pragma mark - 判断两个字符串是否相等
+ (BOOL)equal:(NSString *)str1 to:(NSString *)str2 {
    if(_IS_EMPTY(str2)){
        return [str2 isEqualToString: str1];
    }
    return [str1 isEqualToString: str2];
}

#pragma mark - 保存信息到沙盒中
+ (BOOL)setUserDefaults:(NSString *)key withBoolValue:(BOOL)value {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    if(userDefaults){
        [userDefaults setBool:value forKey:key];
        [userDefaults synchronize];
        return YES;
    }
    return NO;
}

+ (BOOL)setUserDefaults:(NSString *)key withDoubleValue:(double)value {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    if(userDefaults){
        [userDefaults setDouble:value forKey:key];
        [userDefaults synchronize];
        return YES;
    }
    return NO;
}

+ (BOOL)setUserDefaults:(NSString *)key withFloatValue:(float)value {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    if(userDefaults){
        [userDefaults setFloat:value forKey:key];
        [userDefaults synchronize];
        return YES;
    }
    return NO;
}

+ (BOOL)setUserDefaults:(NSString *)key withIntegerValue:(int)value {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    if(userDefaults){
        [userDefaults setInteger:value forKey:key];
        [userDefaults synchronize];
        return YES;
    }
    return NO;
}

// 数组存取
+ (BOOL)setUserDefaults:(NSString *)key withURLValue:(NSURL *)value {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    if(userDefaults){
        [userDefaults setURL:value forKey:key];
        [userDefaults synchronize];
        return YES;
    }
    return NO;
}

+ (BOOL)setUserDefaults:(NSString *)key withValue:(id)value {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    if(userDefaults){
        [userDefaults setObject:value forKey:key];
        [userDefaults synchronize];
        return YES;
    }
    return NO;
}
// 数组存取
+ (BOOL)setUserDefaults:(NSString *)key withArray:(NSArray *)array {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    if (userDef) {
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:array];
        [userDef setObject:data forKey:key];
        [userDef synchronize];
        return YES;
    }
    return NO;
}

+ (NSArray *)retrieveArrayFromUserDefaults:(NSString *)key {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    return [NSKeyedUnarchiver unarchiveObjectWithData:[userDef objectForKey:key]];
}

#pragma mark - 从沙盒中取信息
+ (id)getValueFromUserDefaultsByKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

#pragma mark - 图片问题
#pragma mark 读取本地图片
+ (UIImage *)loadLocalImage:(NSString *)imageName ofType:(NSString *)imageType {
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@.%@",imageName,imageType]];
}

// 旋转图片。（上传的图片方向转正）
+ (UIImage *)rotateImageOrientationUp:(UIImage *)image{
    
    int width = image.size.width;
    int height = image.size.height;
    CGSize size = CGSizeMake(width, height);
    
    CGRect imageRect;
    
    if(image.imageOrientation == UIImageOrientationUp
       || image.imageOrientation == UIImageOrientationDown)
    {
        imageRect = CGRectMake(0, 0, width, height);
    }
    else
    {
        imageRect = CGRectMake(0, 0, height, width);
    }
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if(image.imageOrientation==UIImageOrientationLeft)
    {
        CGContextRotateCTM(context, M_PI / 2);
        CGContextTranslateCTM(context, 0, -width);
    }
    else if(image.imageOrientation==UIImageOrientationRight)
    {
        CGContextRotateCTM(context, - M_PI / 2);
        CGContextTranslateCTM(context, -height, 0);
    }
    else if(image.imageOrientation==UIImageOrientationUp)
    {
        //DO NOTHING
    }
    else if(image.imageOrientation==UIImageOrientationDown)
    {
        CGContextTranslateCTM(context, width, height);
        CGContextRotateCTM(context, M_PI);
    }
    
    CGContextDrawImage(context, imageRect, image.CGImage);
    CGContextRestoreGState(context);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return (img);
}


+ (NSString*) sha1:(NSString*)input{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}

+ (NSString *) md5:(NSString *) input{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return  output;
    
}

//  图片质量压缩
+ (NSData *)compressImg:(UIImage *) originImg quality:(float) quality{
    assert(quality <= 1.0 && quality >= 0);
    return UIImageJPEGRepresentation(originImg, quality);
}

//  图片压缩
+ (UIImage *)resizeImg:(UIImage *) image toSize:(CGSize) newSize max:(BOOL)isMax{
    
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    if (width <= newSize.width && height <= newSize.height){
        return image;
    }
    
    if (width == 0 || height == 0){
        return image;
    }
    
    CGFloat widthFactor = newSize.width / width;
    CGFloat heightFactor = newSize.height / height;
    CGFloat scaleFactor = 0;
    if(isMax){
        scaleFactor = widthFactor < heightFactor?widthFactor:heightFactor;
    }else{
        scaleFactor = (widthFactor < heightFactor?heightFactor:widthFactor);
    }
    
    CGFloat scaledWidth = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize targetSize = CGSizeMake(scaledWidth,scaledHeight);
    
    UIGraphicsBeginImageContext(targetSize);
    [image drawInRect:CGRectMake(0, 0, scaledWidth, scaledHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+ (NSString *) randStr: (int) len{
    char data[len];
    for (int x=0; x < len; data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:len encoding:NSUTF8StringEncoding];
}

+ (NSString *) getDocumentDir{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex: 0];
}

+ (NSString *) getDocumentDirFile: (NSString *)fileName{
    return [[KTUtils getDocumentDir] stringByAppendingPathComponent: fileName];
}

+ (NSString *) getTmpDir{
    return NSTemporaryDirectory();
}

+ (NSString *) getTmpDirFile:(NSString *)fileName{
    return [[KTUtils getTmpDir] stringByAppendingPathComponent: fileName];
}

//  从image url格式中提取图片的长宽（单位：dpi）
//  image url 的格式： xxx.jpg__width@height
+ (CGSize) imgSizeFromImgUrl: (NSString *) formatImgUrl{
    NSRange range = [formatImgUrl rangeOfString:@"__" options:NSBackwardsSearch];
    if(range.location == NSNotFound || range.length == 0){
        return CGSizeMake(0, 0);
    }
    NSString *subString = [formatImgUrl substringFromIndex: range.location + 2];
    range = [subString rangeOfString:@"*"];
    if(range.location == NSNotFound || range.length == 0){
        range = [subString rangeOfString: @"x"];
        if(range.location == NSNotFound || range.length == 0){
            range = [subString rangeOfString: @"@"];
            if(range.location == NSNotFound || range.length == 0){
                return CGSizeMake(0, 0);
            }
        }
    }
    
    NSString *widthStr = [[subString substringToIndex: range.location] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *heightStr = [[subString substringFromIndex: range.location + 1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    float scale = [UIScreen mainScreen].scale;
    return CGSizeMake([widthStr floatValue]/scale, [heightStr floatValue]/scale);
}

// 通过颜色生成一个纯色的图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
