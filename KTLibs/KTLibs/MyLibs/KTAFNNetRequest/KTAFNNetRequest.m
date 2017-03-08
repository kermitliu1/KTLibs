//
//  KTAFNNetRequest.m
//  KTLibs
//
//  Created by KermitLiu on 2017/3/8.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import "KTAFNNetRequest.h"

@implementation KTAFNNetRequest

#pragma mark - Private
+(AFHTTPSessionManager *)managerWithBaseURL:(NSString *)baseURL  sessionConfiguration:(BOOL)isconfiguration{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager * manager = nil;
    
    NSURL *url = [NSURL URLWithString:baseURL];
    
    if (isconfiguration) {
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url sessionConfiguration:configuration];
    }else{
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    return manager;
}

/**
 
 */
+(id)responseConfiguration:(id)responseObject{
    
    //    NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    //    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    return dic;
}

#pragma mark -

+ (void)GET:(NSString *)url parameters:(NSDictionary *)parameters successBlock:(ResponseSuccess)success failureBlock:(ResponseFailure)failure {
    
    AFHTTPSessionManager *manager = [KTAFNNetRequest managerWithBaseURL:nil sessionConfiguration:NO];
    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id dic = [KTAFNNetRequest responseConfiguration:responseObject];
        success(task,dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
}

+ (void)GET:(NSString *)url baseURL:(NSString *)baseUrl parameters:(NSDictionary *)parameters successBlock:(ResponseSuccess)success failureBlock:(ResponseFailure)failure {
    
    AFHTTPSessionManager * manager = [KTAFNNetRequest managerWithBaseURL:baseUrl sessionConfiguration:NO];
    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id dic = [KTAFNNetRequest responseConfiguration:responseObject];
        success(task,dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
    
}

+ (void)POST:(NSString *)url parameters:(NSDictionary *)parameters successBlock:(ResponseSuccess)success failureBlock:(ResponseFailure)failure {
    
    AFHTTPSessionManager * manager = [KTAFNNetRequest managerWithBaseURL:nil sessionConfiguration:NO];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id dic = [KTAFNNetRequest responseConfiguration:responseObject];
        success(task,dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(task,error);
        
    }];
    
}

+ (void)POST:(NSString *)url baseURL:(NSString *)baseUrl parameters:(NSDictionary *)parameters successBlock:(ResponseSuccess)success failureBlock:(ResponseFailure)failure {
    
    AFHTTPSessionManager * manager = [KTAFNNetRequest managerWithBaseURL:baseUrl sessionConfiguration:NO];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id dic = [KTAFNNetRequest responseConfiguration:responseObject];
        success(task,dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(task,error);
        
    }];
}

+ (void)uploadWithURL:(NSString *)url parameters:(NSDictionary *)parameters fileData:(NSData *)filedata name:(NSString *)name fileName:(NSString *)filename mimeType:(NSString *)mimeType progressBlock:(UploadProgress)progress successBlock:(ResponseSuccess)success failureBlock:(ResponseFailure)failure {
    
    AFHTTPSessionManager *manager = [KTAFNNetRequest managerWithBaseURL:nil sessionConfiguration:NO];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:filedata name:name fileName:filename mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id dic = [KTAFNNetRequest responseConfiguration:responseObject];
        success(task,dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(task,error);
        
    }];
}

+ (void)uploadWithURL:(NSString *)url baseURL:(NSString *)baseurl parameters:(NSDictionary *)parameters fileData:(NSData *)filedata name:(NSString *)name fileName:(NSString *)filename mimeType:(NSString *)mimeType progressBlock:(UploadProgress)progress successBlock:(ResponseSuccess)success failureBlock:(ResponseFailure)failure {
    
    AFHTTPSessionManager *manager = [KTAFNNetRequest managerWithBaseURL:baseurl sessionConfiguration:YES];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:filedata name:name fileName:filename mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id dic = [KTAFNNetRequest responseConfiguration:responseObject];
        success(task,dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(task,error);
        
    }];
}

+ (NSURLSessionDownloadTask *)downloadWithURL:(NSString *)url savePathURL:(NSURL *)fileURL progressBlock:(UploadProgress)progress successBlock:(void (^)(NSURLResponse *, NSURL *))success failureBlock:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [self managerWithBaseURL:nil sessionConfiguration:YES];
    
    NSURL *urlpath = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlpath];
    
    NSURLSessionDownloadTask *downloadtask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        progress(downloadProgress);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return [fileURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) {
            failure(error);
        }else{
            success(response,filePath);
        }
    }];
    
    [downloadtask resume];
    
    return downloadtask;
}


@end
