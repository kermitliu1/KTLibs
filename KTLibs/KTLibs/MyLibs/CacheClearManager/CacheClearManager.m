//
//  CacheClearManager.m
//  KTLibs
//
//  Created by KermitLiu on 2017/4/26.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import "CacheClearManager.h"
#import <SDImageCache.h>

@interface CacheClearManager ()
<NSFileManagerDelegate>
{
    NSFileManager * _fileManager;
}

@end

@implementation CacheClearManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _fileManager = [NSFileManager defaultManager];
        _fileManager.delegate = self;
    }
    return self;
}

+ (CacheClearManager *)shareManager {
    static CacheClearManager * manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[CacheClearManager alloc] init];
        }
    });
    
    return manager;
}

// 根据文件路径 计算文件大小
- (long long)folderSizeInNSCachesDirectoryAtPath:(NSString *)path {
    
    // library - cache路径
    NSString * libraryCachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString * getSizePath  = [libraryCachePath stringByAppendingPathComponent:path];
    
    long long folderSize = 0;
    
    if ([_fileManager fileExistsAtPath:getSizePath]) {
        
        NSArray * childerFiles = [_fileManager subpathsAtPath:getSizePath];
        
        for (NSString * fileName in childerFiles) {
            NSString * fileAbsolutePath = [getSizePath stringByAppendingPathComponent:fileName];
            long long size = [self fileSizeAtPath:fileAbsolutePath];
            folderSize += size;
            KTLog(@"fileAbsolutePath=%@",fileAbsolutePath);
        }
        return folderSize;
    }
    return 0;
}
// 根据文件路径 计算文件大小
- (long long)folderSizeInNSDocumentDirectoryAtPath:(NSString *)path {
    
    // library - cache路径
    NSString * documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * getSizePath  = [documentsDirectory stringByAppendingPathComponent:path];
    
    long long folderSize = 0;
    
    if ([_fileManager fileExistsAtPath:getSizePath]) {
        
        NSArray * childerFiles = [_fileManager subpathsAtPath:getSizePath];
        
        for (NSString * fileName in childerFiles) {
            NSString * fileAbsolutePath = [getSizePath stringByAppendingPathComponent:fileName];
            long long size = [self fileSizeAtPath:fileAbsolutePath];
            folderSize += size;
            KTLog(@"fileAbsolutePath=%@",fileAbsolutePath);
        }
        return folderSize;
    }
    return 0;
}

- (long long)fileSizeAtPath:(NSString *)path {
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    return 0;
}

- (long long)getSDImageCacheSize {
    return [[SDImageCache sharedImageCache] getSize];
}


//同样也是利用NSFileManager API进行文件操作。
- (void)clearCacheInNSCachesDirectoryAtPath:(NSString *)path {
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    cachePath = [cachePath stringByAppendingPathComponent:path];
    
    if ([_fileManager fileExistsAtPath:cachePath]) {
        NSArray * childerFiles = [_fileManager subpathsAtPath:cachePath];
        for (NSString * fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString * fileAbsolutePath = [cachePath stringByAppendingPathComponent:fileName];
            [_fileManager removeItemAtPath:fileAbsolutePath error:nil];
        }
    }
}

- (void)clearCacheInNSDocumentDirectoryAtPath:(NSString *)path {
    
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    cachePath = [cachePath stringByAppendingPathComponent:path];
    
    if ([_fileManager fileExistsAtPath:cachePath]) {
        NSArray * childerFiles = [_fileManager subpathsAtPath:cachePath];
        for (NSString * fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString * fileAbsolutePath = [cachePath stringByAppendingPathComponent:fileName];
            [_fileManager removeItemAtPath:fileAbsolutePath error:nil];
        }
    }
}

- (void)clearSDImageCache {
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
}


// MARK:- NSFileManagerDelegate
- (BOOL)fileManager:(NSFileManager *)fileManager shouldRemoveItemAtPath:(NSString *)path {
    
    if (self.clearCacheBlock) {
        self.clearCacheBlock(path);
    }
    return YES;
}

- (void)dealloc {
    _fileManager.delegate = nil;
}


@end
