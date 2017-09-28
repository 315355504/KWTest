//
//  KWAppError.h
//  Pods
//
//  Created by cxk@erongdu.com on 2016/11/23.
//
//

#import <Foundation/Foundation.h>
#import "KWAppService.h"
@class KWAppError;

/**
 网络成功时的回调
 
 @param task 请求任务
 @param error 错误信息
 @param model 数据模型
 */
typedef void(^KWAppErrorSuccessBlock)(NSURLSessionDataTask *task, KWAppError *error, id model);


/**
 网络失败时回调
 
 @param task 请求任务
 @param error 错误信息
 */
typedef void(^KWAppErrorFailBlock)(NSURLSessionDataTask *task, KWAppError *error);

/**
 文件下载目标地址回调
 
 @param targetPath 目标地址
 @param response 返回数据
 @return
 */
typedef NSURL *(^KWAppErrorDestinationBlock)(NSURL *targetPath, NSURLResponse *response);


/**
 下载文件进度回调
 
 @param downloadProgress <#downloadProgress description#>
 */
typedef void (^KWAppErrorProgressBlock)(NSProgress *downloadProgress);

/**
 下载成功
 
 @param task <#task description#>
 @param response <#response description#>
 */
typedef void (^KWAppErrorDownloadSuccess)(NSURLSessionDownloadTask *task, NSURLResponse *response);

@protocol KWAppErrorDelegate <NSObject>

@required


/**
 请求之前需要做的操作
 
 @param url 请求地址
 @param headerParameter
 @param parameter 参数
 @param defaultFlag 额外标识符
 */
- (void)beforeRequestURL:(NSString **)url headerParameter:(NSMutableDictionary **)headerParameter parameter:(NSMutableDictionary **)parameter;


/**
 网络请求成功时返回KWAppError对象
 
 @param responseObject 网络请求返回数据
 @return KWAppError对象
 */
- (KWAppError *)successKWAppErrorWithResponseObject:(id)responseObject;

/**
 网络请求失败时返回KWAppError对象
 
 @param error 网络错误信息
 @return KWAppError对象
 */
- (KWAppError *)failKWAppErrorWithNetworkError:(NSError *)error;



/**
 将数据转换成Model，在成功回调中返回
 
 @param responseObject 返回数据
 @param modelClass 数据模型
 @return 数据模型对象
 */
- (id)response:(id)responseObject convertToModelClass:(__unsafe_unretained Class)ModelClass appError:(KWAppError *)appError;


/**
 根据code判断是否可封装数据
 
 @param appError 是一步产生的错误对象
 @return 是否可封装
 */
- (BOOL)isResponseCanConvert:(KWAppError *)appError;

/**
 在成功和错误回调之前进行统一处理代理
 
 @param appError 生成的错误对象
 */
- (void)unifiedTreatmentAppError:(KWAppError *)appError;


@end
@interface KWAppError : NSObject

/**
 返回code保护成功或网络失败的code
 */
@property (nonatomic, assign) NSInteger errorCode;

/**
 返回成功信息或网络错误信息
 */
@property (nonatomic, copy) NSString *errorMessage;
@property (nonatomic, copy) NSError *error;
/**
 网络请求成功时返回的数据
 */
@property (nonatomic, strong) id errorData;

@property (nonatomic, strong) NSDictionary *resData;

/**
 有些平台（现金贷） 页码数据与data 同一层级
 */
@property (nonatomic, strong) NSDictionary *pageData;
/**
 创建KWAppError对象
 
 @param code code
 @param errorMessage 信息
 @param responseData 返回数据
 @return KWAppError对象
 */
- (instancetype)initWithCode:(NSInteger)code
                errorMessage:(NSString *)errorMessage
                responseData:(id)responseData;


- (instancetype)initWithCode:(NSInteger)code
                errorMessage:(NSString *)errorMessage
                     resData:(NSDictionary *)resData;

- (instancetype)initWithCode:(NSInteger)code
                errorMessage:(NSString *)errorMessage
                     resData:(NSDictionary *)resData pageData:(NSDictionary *)pageDic;
/**
 对网络请求进行封装，基本网络请求
 
 @param method 请求方式
 @param URL 请求地址
 @param parameters 参数
 @param errorDelegate 代理
 @param success 网络成功回调
 @param fail 网络失败回调
 */
+ (void)requestHTTPMethod:(KWAppServiceMethod)method
                      URL:(NSString *)URL
               parameters:(NSDictionary *)parameters
               modelClass:(__unsafe_unretained Class)modelClass
            errorDelegate:(id<KWAppErrorDelegate>)errorDelegate
                  success:(KWAppErrorSuccessBlock)success
                     fail:(KWAppErrorFailBlock)fail;
/**
 对网络请求进行封装，基本网络请求, 附带HeaderParameters头部参数
 */
+ (void)requestHTTPMethod:(KWAppServiceMethod)method
                      URL:(NSString *)URL
         headerParameters:(NSDictionary *)headerParameters
               parameters:(NSDictionary *)parameters
               modelClass:(__unsafe_unretained Class)modelClass
            errorDelegate:(id<KWAppErrorDelegate>)errorDelegate
                  success:(KWAppErrorSuccessBlock)success
                     fail:(KWAppErrorFailBlock)fail;

/**
 返回不封装的结果数据, 基本请求返回 id类型字典
 
 @param method 请求类型
 @param URL 地址
 @param headerParameters 头部参数
 @param parameters 参数
 @param modelClass Model
 @param errorDelegate 错误处理代理
 @param success 正确返回
 @param fail 错误返回
 */
+(void)requestWithoutWrapperHTTPMethod:(KWAppServiceMethod)method
                                   URL:(NSString *)URL
                      headerParameters:(NSDictionary *)headerParameters
                            parameters:(NSDictionary *)parameters
                            modelClass:(__unsafe_unretained Class)modelClass
                         errorDelegate:(id<KWAppErrorDelegate>)errorDelegate
                               success:(KWAppErrorSuccessBlock)success
                                  fail:(KWAppErrorFailBlock)fail;

/**
 对文件上传的网络请求进行封装
 
 @param URL 请求地址
 @param parameters 参数
 @param uploadFiles 文件数组
 @param modelClass 模型类名
 @param errorDelegate 代理
 @param progressCallBack 进度
 @param success 成功回调
 @param fail 失败回调
 */

+ (void)requestUploadWithUrl:(NSString *)URL
                  parameters:(NSDictionary *)parameters
                 uploadFiles:(NSArray<KWAppServiceUploadFile *> *)uploadFiles
                  modelClass:(__unsafe_unretained Class)modelClass
               errorDelegate:(id<KWAppErrorDelegate>)errorDelegate
                    progress:(void(^) (NSProgress *uploadProgress))progressCallBack
                     success:(KWAppErrorSuccessBlock)success
                        fail:(KWAppErrorFailBlock)fail;
/**
 对文件上传的网络请求进行封装, 附带HeaderParameters头部参数
 */
+ (void)requestUploadWithUrl:(NSString *)URL
            headerParameters:(NSDictionary *)headerParameters
                  parameters:(NSDictionary *)parameters
                 uploadFiles:(NSArray<KWAppServiceUploadFile *> *)uploadFiles
                  modelClass:(__unsafe_unretained Class)modelClass
               errorDelegate:(id<KWAppErrorDelegate>)errorDelegate
                    progress:(void(^) (NSProgress *uploadProgress))progressCallBack
                     success:(KWAppErrorSuccessBlock)success
                        fail:(KWAppErrorFailBlock)fail;


+ (void)requestDownloadWithHTTPMethod:(KWAppServiceMethod)method
                                  URL:(NSString *)URL
                           parameters:(NSDictionary *)parameters
                        errorDelegate:(id<KWAppErrorDelegate>)errorDelegate
                             progress:(KWAppErrorProgressBlock)progress
                          destination:(KWAppErrorDestinationBlock)destination
                              success:(KWAppErrorDownloadSuccess)success
                                 fail:(KWAppErrorFailBlock)fail;

/**
 , 附带HeaderParameters头部参数
 */
+ (void)requestDownloadWithHTTPMethod:(KWAppServiceMethod)method
                                  URL:(NSString *)URL
                     headerParameters:(NSDictionary *)headerParameters
                           parameters:(NSDictionary *)parameters
                        errorDelegate:(id<KWAppErrorDelegate>)errorDelegate
                             progress:(KWAppErrorProgressBlock)progress
                          destination:(KWAppErrorDestinationBlock)destination
                              success:(KWAppErrorDownloadSuccess)success
                                 fail:(KWAppErrorFailBlock)fail;





@end

