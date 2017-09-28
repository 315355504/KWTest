//
//  KWAppErrorHandlerYYModel.m
//  HuiBang
//
//  Created by 李帅良 on 2017/1/10.
//  Copyright © 2017年 Mr_zhaohy. All rights reserved.
//

#import "KWAppErrorHandlerYYModel.h"
#import "KWNetworkResult.h"
#import "KWMacro.h"
#import <YYModel/YYModel.h>
//#import "AppRequestMacro.h"




@implementation KWAppErrorHandlerYYModel
//instancetype ,不做具体类型检查
//利用dispatch_once 实现单例
+ (instancetype)sharedManager
{
    static KWAppErrorHandlerYYModel *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark KWAppErrorDelegate

- (void)beforeRequestURL:(NSString *__autoreleasing *)url headerParameter:(NSMutableDictionary *__autoreleasing *)headerParameter parameter:(NSMutableDictionary *__autoreleasing *)parameter
{
    *parameter = [[KWAppServiceAgent shareService].defaultConfig.commentArguments KWAppServiceBodyArgumentsAttach:*parameter];
    *headerParameter = [[KWAppServiceAgent shareService].defaultConfig.commentArguments KWAppServiceHeaderArgumentsAttach:*headerParameter];
    
}

- (void)endRequestDefaultFlag:(BOOL)defaultFlag
{
    if (defaultFlag) {
    }
}

- (KWAppError *)successKWAppErrorWithResponseObject:(id)responseObject
{
    KWNetworkResult *result = [KWNetworkResult yy_modelWithJSON:responseObject];
    if (result == nil || (result.code == 0 && result.msg == nil)) {
        return [[KWAppError alloc] initWithCode:KWP2PAppErrorTypeYYResponseModel errorMessage:@"返回数据格式有问题" responseData:responseObject];
    }
    return [[KWAppError alloc] initWithCode:result.code errorMessage:result.msg resData:result.data pageData:result.page];
    
}


- (KWAppError *)failKWAppErrorWithNetworkError:(NSError *)error
{
    return [[KWAppError alloc] initWithCode:error.code errorMessage:@"网络连接错误，请查看网络是否已连接!" responseData:nil];
}



- (id)response:(id)responseObject convertToModelClass:(__unsafe_unretained Class)ModelClass appError:(KWAppError *)appError
{
    if ([NSStringFromClass(ModelClass) isEqualToString:NSStringFromClass([NSDictionary class])]) {
        
        
        return appError.resData;
    }
    else
    {
        
//        return [ModelClass yy_modelWithDictionary:appError.errorData];;

        return [ModelClass yy_modelWithDictionary:appError.resData];
    }
}


- (BOOL)isResponseCanConvert:(KWAppError *)appError
{
    return appError.errorCode == KWP2PAppErrorTypeYYSuccess?YES:NO;
}


- (void)unifiedTreatmentAppError:(KWAppError *)appError
{
    //统一处理
    NSLog(@"code:%ld message:%@ data:%@",appError.errorCode, appError.errorMessage, appError.resData);
    if(appError.errorCode != KWP2PAppErrorTypeYYSuccess)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_AppErrorNotification object:nil userInfo:@{@"error":appError}];
    }
}

@end
