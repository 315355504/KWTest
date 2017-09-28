//
//  KWAppError.m
//  Pods
//
//  Created by cxk@erongdu.com on 2016/11/23.
//
//

#import "KWAppError.h"
#import "KWAppErrorHandlerYYModel.h"
@implementation KWAppError

- (instancetype)initWithCode:(NSInteger)code
                errorMessage:(NSString *)errorMessage
                responseData:(id)responseData
{
    self = [super init];
    if (self) {
        _errorCode = code;
        _errorMessage = errorMessage;
        _errorData = responseData;
    }
    return self;
}

- (instancetype)initWithCode:(NSInteger)code
                errorMessage:(NSString *)errorMessage
                     resData:(NSDictionary *)resData
{
    self = [super init];
    if (self) {
        _errorCode = code;
        _errorMessage = errorMessage;
        _resData = resData;
    }
    return self;
}

- (instancetype)initWithCode:(NSInteger)code
                errorMessage:(NSString *)errorMessage
                     resData:(NSDictionary *)resData pageData:(NSDictionary *)pageDic
{
    self = [super init];
    if (self) {
        _errorCode = code;
        _errorMessage = errorMessage;
        _resData = resData;
        _pageData = pageDic;
    }
    return self;
}
+ (void)requestHTTPMethod:(KWAppServiceMethod)method
                      URL:(NSString *)URL
               parameters:(NSDictionary *)parameters
               modelClass:(__unsafe_unretained Class)modelClass
            errorDelegate:(id<KWAppErrorDelegate>)errorDelegate
                  success:(KWAppErrorSuccessBlock)success
                     fail:(KWAppErrorFailBlock)fail
{
    [KWAppError requestHTTPMethod:method
                              URL:URL
                 headerParameters:nil
                       parameters:parameters
                       modelClass:modelClass
                    errorDelegate:errorDelegate
                          success:success
                             fail:fail];
}

+ (void)requestHTTPMethod:(KWAppServiceMethod)method
                      URL:(NSString *)URL
         headerParameters:(NSDictionary *)headerParameters
               parameters:(NSDictionary *)parameters
               modelClass:(__unsafe_unretained Class)modelClass
            errorDelegate:(id<KWAppErrorDelegate>)errorDelegate
                  success:(KWAppErrorSuccessBlock)success
                     fail:(KWAppErrorFailBlock)fail
{
    NSLog(@"%@",URL);
    if(errorDelegate && [errorDelegate respondsToSelector:@selector(beforeRequestURL:headerParameter:parameter:)])
    {
        headerParameters = headerParameters?[headerParameters mutableCopy]:[[NSMutableDictionary alloc] init];
        parameters = parameters?[parameters mutableCopy]:[[NSMutableDictionary alloc] init];
        
        [errorDelegate beforeRequestURL:&URL headerParameter:&headerParameters parameter:&parameters];
    }
    //创建KWAppError对象
    __block KWAppError *appError;
 
    //请求网络
    [[KWAppServiceAgent shareService] appDataTaskWithHTTPMethod:method URLString:URL parameters:parameters headerParamters:headerParameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //成功处理
        if(errorDelegate && [errorDelegate respondsToSelector:@selector(successKWAppErrorWithResponseObject:)])
        {
            appError = [errorDelegate successKWAppErrorWithResponseObject:responseObject];
        }
        id object;
        if(errorDelegate && [errorDelegate respondsToSelector:@selector(isResponseCanConvert:)])
        {
            if ([errorDelegate isResponseCanConvert:appError]) {
                //封装模型
                if (errorDelegate && [errorDelegate respondsToSelector:@selector(response:convertToModelClass:appError:)]) {
                    object = [errorDelegate response:responseObject convertToModelClass:modelClass appError:appError];
                }
            }
        }
        
        if (errorDelegate && [errorDelegate respondsToSelector:@selector(unifiedTreatmentAppError:)])
        {
            [errorDelegate unifiedTreatmentAppError:appError];
        }
   
        if (object == nil ){
         id obJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(task, appError, obJson);
        }else{
            success(task, appError, object);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //错误处理
        
        if ([errorDelegate respondsToSelector:@selector(failKWAppErrorWithNetworkError:)])
        {
            appError = [errorDelegate failKWAppErrorWithNetworkError:error];
            if (errorDelegate && [errorDelegate respondsToSelector:@selector(unifiedTreatmentAppError:)])
            {
                [errorDelegate unifiedTreatmentAppError:appError];
            }
        }

        if (appError == nil) {
            KWAppError * failError = [[KWAppErrorHandlerYYModel sharedManager] failKWAppErrorWithNetworkError:error];
            failError.error = error;
            fail(task,failError);
        }else{
            fail(task, appError);
        }
    }];
}

+(void)requestWithoutWrapperHTTPMethod:(KWAppServiceMethod)method
                                   URL:(NSString *)URL
                      headerParameters:(NSDictionary *)headerParameters
                            parameters:(NSDictionary *)parameters
                            modelClass:(__unsafe_unretained Class)modelClass
                         errorDelegate:(id<KWAppErrorDelegate>)errorDelegate
                               success:(KWAppErrorSuccessBlock)success
                                  fail:(KWAppErrorFailBlock)fail
{
    NSLog(@"%@",URL);
    if(errorDelegate && [errorDelegate respondsToSelector:@selector(beforeRequestURL:headerParameter:parameter:)])
    {
        headerParameters = headerParameters?[headerParameters mutableCopy]:[[NSMutableDictionary alloc] init];
        parameters = parameters?[parameters mutableCopy]:[[NSMutableDictionary alloc] init];
        
        [errorDelegate beforeRequestURL:&URL headerParameter:&headerParameters parameter:&parameters];
    }
    //创建KWAppError对象
    __block KWAppError *appError;
    
    //请求网络
    [[KWAppServiceAgent shareService] appDataTaskWithHTTPMethod:method URLString:URL parameters:parameters headerParamters:headerParameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //成功处理
        
        id obJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        success(task, nil, obJson);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //错误处理
        if ([errorDelegate respondsToSelector:@selector(failKWAppErrorWithNetworkError:)])
        {
            appError = [errorDelegate failKWAppErrorWithNetworkError:error];
            if (errorDelegate && [errorDelegate respondsToSelector:@selector(unifiedTreatmentAppError:)])
            {
                [errorDelegate unifiedTreatmentAppError:appError];
            }
        }
        if (appError == nil) {
            KWAppError * failError = [[KWAppErrorHandlerYYModel sharedManager] failKWAppErrorWithNetworkError:error];
            failError.error = error;
            fail(task,failError);
        }else{
            fail(task, appError);
        }
    }];
}

+ (void)requestUploadWithUrl:(NSString *)URL
                  parameters:(NSDictionary *)parameters
                 uploadFiles:(NSArray<KWAppServiceUploadFile *> *)uploadFiles
                  modelClass:(__unsafe_unretained Class)modelClass
               errorDelegate:(id<KWAppErrorDelegate>)errorDelegate
                    progress:(void(^) (NSProgress *uploadProgress))progressCallBack
                     success:(KWAppErrorSuccessBlock)success
                        fail:(KWAppErrorFailBlock)fail
{
    [KWAppError requestUploadWithUrl:URL headerParameters:nil parameters:parameters uploadFiles:uploadFiles modelClass:modelClass errorDelegate:errorDelegate progress:progressCallBack success:success fail:fail];
}
+ (void)requestUploadWithUrl:(NSString *)URL
            headerParameters:(NSDictionary *)headerParameters
                  parameters:(NSDictionary *)parameters
                 uploadFiles:(NSArray<KWAppServiceUploadFile *> *)uploadFiles
                  modelClass:(__unsafe_unretained Class)modelClass
               errorDelegate:(id<KWAppErrorDelegate>)errorDelegate
                    progress:(void(^) (NSProgress *uploadProgress))progressCallBack
                     success:(KWAppErrorSuccessBlock)success
                        fail:(KWAppErrorFailBlock)fail

{
    NSLog(@"%@",URL);
    if(errorDelegate && [errorDelegate respondsToSelector:@selector(beforeRequestURL:headerParameter:parameter:)])
    {
        headerParameters = headerParameters?[headerParameters mutableCopy]:[[NSMutableDictionary alloc] init];
        parameters = parameters?[parameters mutableCopy]:[[NSMutableDictionary alloc] init];
        [errorDelegate beforeRequestURL:&URL headerParameter:&headerParameters parameter:&parameters];
    }
    //创建KWAppError对象
    __block KWAppError *appError;
    
    [[KWAppServiceAgent shareService] appUploadTaskWithURLString:URL parameters:parameters headerParamters:headerParameters uploadFiles:uploadFiles progress:^(NSProgress *uploadProgress) {
        progressCallBack(uploadProgress);
    } success:^(NSURLSessionUploadTask *task, id responseObject) {
        //成功处理
        
        if(errorDelegate && [errorDelegate respondsToSelector:@selector(successKWAppErrorWithResponseObject:)])
        {
            appError = [errorDelegate successKWAppErrorWithResponseObject:responseObject];
        }
        id object;
        if(errorDelegate && [errorDelegate respondsToSelector:@selector(isResponseCanConvert:)])
        {
            if ([errorDelegate isResponseCanConvert:appError]) {
                //封装模型
                if (errorDelegate && [errorDelegate respondsToSelector:@selector(response:convertToModelClass:appError:)]) {
                    object = [errorDelegate response:responseObject convertToModelClass:modelClass appError:appError];
                }
            }
        }
        
        if (errorDelegate && [errorDelegate respondsToSelector:@selector(unifiedTreatmentAppError:)])
        {
            [errorDelegate unifiedTreatmentAppError:appError];
        }
        
        if (object == nil ){
            id obJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(task, appError, obJson);
        }else{
            success(task, appError, object);
        }
    } failure:^(NSURLSessionUploadTask *task, NSError *error) {
        //错误处理
        if ([errorDelegate respondsToSelector:@selector(failKWAppErrorWithNetworkError:)])
        {
            appError = [errorDelegate failKWAppErrorWithNetworkError:error];
            if (errorDelegate && [errorDelegate respondsToSelector:@selector(unifiedTreatmentAppError:)])
            {
                [errorDelegate unifiedTreatmentAppError:appError];
            }
        }
        if (appError == nil) {
            KWAppError * failError = [[KWAppErrorHandlerYYModel sharedManager] failKWAppErrorWithNetworkError:error];
            failError.error = error;
            fail(task,failError);
        }else{
            fail(task, appError);
        }
    }];
    
}

+ (void)requestDownloadWithHTTPMethod:(KWAppServiceMethod)method
                                  URL:(NSString *)URL
                           parameters:(NSDictionary *)parameters
                        errorDelegate:(id<KWAppErrorDelegate>)errorDelegate
                             progress:(KWAppErrorProgressBlock)progress
                          destination:(KWAppErrorDestinationBlock)destination
                              success:(KWAppErrorDownloadSuccess)success
                                 fail:(KWAppErrorFailBlock)fail
{
    [KWAppError requestDownloadWithHTTPMethod:method
                                          URL:URL headerParameters:nil
                                   parameters:parameters
                                errorDelegate:errorDelegate
                                     progress:progress
                                  destination:destination
                                      success:success
                                         fail:fail];
}

+ (void)requestDownloadWithHTTPMethod:(KWAppServiceMethod)method
                                  URL:(NSString *)URL
                     headerParameters:(NSDictionary *)headerParameters
                           parameters:(NSDictionary *)parameters
                        errorDelegate:(id<KWAppErrorDelegate>)errorDelegate
                             progress:(KWAppErrorProgressBlock)progress
                          destination:(KWAppErrorDestinationBlock)destination
                              success:(KWAppErrorDownloadSuccess)success
                                 fail:(KWAppErrorFailBlock)fail
{
    if(errorDelegate && [errorDelegate respondsToSelector:@selector(beforeRequestURL:headerParameter:parameter:)])
    {
        headerParameters = headerParameters?[headerParameters mutableCopy]:[[NSMutableDictionary alloc] init];
        parameters = parameters?[parameters mutableCopy]:[[NSMutableDictionary alloc] init];
        [errorDelegate beforeRequestURL:&URL headerParameter:&headerParameters parameter:&parameters];
    }
    //创建KWAppError对象
    __block KWAppError *appError;
    
    [[KWAppServiceAgent shareService] appDownloadTaskWithHTTPMethod:method URLString:URL parameters:parameters headerParamters:headerParameters progress:^(NSProgress *downloadProgress) {
        progress(downloadProgress);
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return destination(targetPath, response);
    } success:^(NSURLSessionDownloadTask *task, NSURLResponse *response) {
        success(task, response);
    } failure:^(NSURLSessionDownloadTask *task, NSError *error) {
        if ([errorDelegate respondsToSelector:@selector(failKWAppErrorWithNetworkError:)])
        {
            appError = [errorDelegate failKWAppErrorWithNetworkError:error];
            if (errorDelegate && [errorDelegate respondsToSelector:@selector(unifiedTreatmentAppError:)])
            {
                [errorDelegate unifiedTreatmentAppError:appError];
            }
        }
        fail(task, appError);
    }];
}
@end
