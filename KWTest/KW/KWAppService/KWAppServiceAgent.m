//
//  KWAppServiceAgent.m
//  Pods
//
//  Created by aaaa on 16/8/24.
//
//

#import "KWAppServiceAgent.h"
#import <AFNetworking/AFNetworking.h>

@interface KWAppServiceAgent ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end
@implementation KWAppServiceAgent

+ (instancetype)shareService
{
    static KWAppServiceAgent *serviceAgent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceAgent = [[KWAppServiceAgent alloc] init];
    });
    return serviceAgent;
}

- (instancetype)init
{
    if (self = [super init]) {
        _defaultConfig = [KWAppServiceConfig sharedInstance];
        _manager = [self httpSessionManagerByDefaultConfig];
        
    }
    return self;
}

- (NSString *)methodStringFromMethod:(KWAppServiceMethod)method
{
    switch (method) {
        case KWAppServiceMethodGET:
            return @"GET";
        case KWAppServiceMethodHEAD:
            return @"HEAD";
        case KWAppServiceMethodPOST:
            return @"POST";
        case KWAppServiceMethodPUT:
            return @"PUT";
        case KWAppServiceMethodPATCH:
            return @"PATCH";
        case KWAppServiceMethodDELETE:
            return @"DELETE";
        default:
            return @"ERROR";
            break;
    }
}

/**
 *  获取默认配置标准的AFHTTPSessionManager
 *
 *  @return AFHTTPSessionManager实例
 */
- (AFHTTPSessionManager *)httpSessionManagerByDefaultConfig
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = _defaultConfig.securityPolicy;
    manager.requestSerializer.timeoutInterval = _defaultConfig.requestTimeoutInterval;
    return manager;
}

#pragma mark - 基本请求
- (NSURLSessionDataTask *)appDataTaskWithHTTPMethod:(KWAppServiceMethod)method
                                          URLString:(NSString *)URLString
                                         parameters:(NSDictionary *)parameters
                                            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [self appDataTaskWithHTTPMethod:method
                                 URLString:URLString
                                parameters:parameters
                           headerParamters:nil
                                   success:success
                                   failure:failure];
    
}


- (NSURLSessionDataTask *)appDataTaskWithHTTPMethod:(KWAppServiceMethod)method
                                          URLString:(NSString *)URLString
                                         parameters:(NSDictionary *)parameters
                                    headerParamters:(NSDictionary *)headerParamters
                                            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [self appDataTaskWithHTTPMethod:method
                                 URLString:URLString
                                parameters:parameters
                           headerParamters:headerParamters
                            uploadProgress:nil
                          downloadProgress:nil
                                   success:success
                                   failure:failure];
    
}

- (NSURLSessionDataTask *)appDataTaskWithHTTPMethod:(KWAppServiceMethod)method
                                          URLString:(NSString *)URLString
                                         parameters:(id)parameters
                                    headerParamters:(id)headerParamters
                                     uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadProgress
                                   downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadProgress
                                            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSString *methodString = [self methodStringFromMethod:method];
    AFHTTPSessionManager *manager = _manager;
    manager.requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json" ,@"text/javascript",@"image/jpeg",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSError *serializationError = nil;
    
    if (headerParamters) {
        [headerParamters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:methodString URLString:URLString parameters:parameters error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(manager.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [manager dataTaskWithRequest:request
                             uploadProgress:uploadProgress
                           downloadProgress:downloadProgress
                          completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                              if (error) {
                                  if (failure) {
                                      NSLog(@"error = %@",error);
                                      
                                      failure(dataTask, error);
                                  }
                              } else {
                                  if (success) {
                                      NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                                      NSLog(@"responseObject --> %@",dict);
                                      success(dataTask, responseObject);
                                  }
                              }
                          }];
    //启动
    [dataTask resume];
    
    return dataTask;
}

#pragma mark - 上传文件


- (NSURLSessionUploadTask *)appUploadTaskWithURLString:(NSString *)URLString
                                            parameters:(NSDictionary *)parameters
                                           uploadFiles:(NSArray<KWAppServiceUploadFile *> *)uploadFiles
                                              progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                                               success:(void (^)(NSURLSessionUploadTask *task, id responseObject))success
                                               failure:(void (^)(NSURLSessionUploadTask *task, NSError *error))failure
{
    return [self appUploadTaskWithURLString:URLString parameters:parameters headerParamters:nil uploadFiles:uploadFiles progress:uploadProgress success:success failure:failure];
}

- (NSURLSessionUploadTask *)appUploadTaskWithURLString:(NSString *)URLString
                                            parameters:(NSDictionary *)parameters
                                       headerParamters:(NSDictionary *)headerParamters
                                           uploadFiles:(NSArray<KWAppServiceUploadFile *> *)uploadFiles
                                              progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                                               success:(void (^)(NSURLSessionUploadTask *task, id responseObject))success
                                               failure:(void (^)(NSURLSessionUploadTask *task, NSError *error))failure
{
    AFHTTPSessionManager *manager = _manager;
    manager.requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json" ,@"text/javascript", nil];
    NSError *serializationError = nil;
    if (headerParamters) {
        [headerParamters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    NSMutableURLRequest *request = [manager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (uploadFiles && uploadFiles.count > 0) {
            for (KWAppServiceUploadFile *file in uploadFiles) {
                NSData *fileData = [NSData dataWithContentsOfFile:file.fileURL];
                if (fileData != nil) {
                    [formData appendPartWithFileData:fileData name:file.name fileName:file.filename mimeType:file.mimeType];
                }else{
                    NSLog(@"--------------------------没取到图片------------------------");
                }
            }
        }
    } error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(manager.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    __block NSURLSessionUploadTask *task = [manager uploadTaskWithStreamedRequest:request progress:uploadProgress completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(task, error);
            }
        } else {
            if (success) {
                success(task, responseObject);
            }
        }
    }];
    
    [task resume];
    
    return task;
}

#pragma mark - 文件下载

- (NSURLSessionDownloadTask *)appDownloadTaskWithHTTPMethod:(KWAppServiceMethod)method
                                                  URLString:(NSString *)URLString
                                                 parameters:(NSDictionary *)parameters
                                                   progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                                                destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                                    success:(void (^)(NSURLSessionDownloadTask *task, NSURLResponse *response))success
                                                    failure:(void (^)(NSURLSessionDownloadTask *task, NSError *error))failure
{
    return [self appDownloadTaskWithHTTPMethod:method URLString:URLString parameters:parameters headerParamters:nil progress:downloadProgressBlock destination:destination success:success failure:failure];
}

- (NSURLSessionDownloadTask *)appDownloadTaskWithHTTPMethod:(KWAppServiceMethod)method
                                                  URLString:(NSString *)URLString
                                                 parameters:(NSDictionary *)parameters
                                            headerParamters:(NSDictionary *)headerParamters
                                                   progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                                                destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                                    success:(void (^)(NSURLSessionDownloadTask *task, NSURLResponse *response))success
                                                    failure:(void (^)(NSURLSessionDownloadTask *task, NSError *error))failure
{
    NSParameterAssert((method == KWAppServiceMethodGET) || (method == KWAppServiceMethodPOST));
    NSString *methodString = [self methodStringFromMethod:method];
    AFHTTPSessionManager *manager = _manager;
    manager.requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json" ,@"text/javascript", nil];
    NSError *serializationError = nil;
    if (headerParamters) {
        [headerParamters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:methodString URLString:[[NSURL URLWithString:URLString] absoluteString] parameters:parameters error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(manager.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    __block NSURLSessionDownloadTask *downloadTask;
    downloadTask = [manager downloadTaskWithRequest:request progress:downloadProgressBlock destination:destination completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure(downloadTask, error);
            }
        } else {
            if (success) {
                success(downloadTask, response);
            }
        }
    }];
    
    [downloadTask resume];
    return downloadTask;
}

@end
