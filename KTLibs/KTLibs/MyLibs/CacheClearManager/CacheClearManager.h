//
//  CacheClearManager.h
//  KTLibs
//
//  Created by KermitLiu on 2017/4/26.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^clearCacheWithPathBlock)(NSString * path);

@interface CacheClearManager : NSObject


+ (CacheClearManager *)shareManager;

/**
 *  清理内存的回调
 */
@property (nonatomic, copy) clearCacheWithPathBlock clearCacheBlock;

/**
 *  Library/Caches 文件夹大小的计算
 *
 *  @param path     路径
 *
 *  @return long long   /1024.0/1024.0 MB
 */
- (long long)folderSizeInNSCachesDirectoryAtPath:(NSString *)path;

/**
 *  Documents 文件夹大小的计算
 *
 *  @param path     路径
 *
 *  @return long long   /1024.0/1024.0 MB
 */
- (long long)folderSizeInNSDocumentDirectoryAtPath:(NSString *)path;

/**
 *  单个文件大小的计算
 *
 *  @param path     路径
 *
 *  @return longlong
 */
- (long long)fileSizeAtPath:(NSString *)path;

/**
 *  SDImageCache大小
 *
 *  @return longlong
 */
- (long long)getSDImageCacheSize;

/**
 *  Library/Caches 清除缓存
 */
- (void)clearCacheInNSCachesDirectoryAtPath:(NSString *)path;

/**
 *  Documents 清除缓存
 */
- (void)clearCacheInNSDocumentDirectoryAtPath:(NSString *)path;
/**
 *  清除 SDImageCache
 */
- (void)clearSDImageCache;


@end
