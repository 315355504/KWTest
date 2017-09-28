//
//  KWAppServiceArgumentsAttach.m
//  Pods
//
//  Created by aaaa on 16/8/28.
//
//

#import "KWAppServiceArgumentsAttach.h"
#import <CommonCrypto/CommonDigest.h>
#import "KWAppUserProfile.h"

@interface KWAppServiceArgumentsAttach ()

/**
 *  body公共参数
 */
@property (nonatomic, strong) NSMutableDictionary *bodyArguments;

/**
 *  头部公共参数
 */
@property (nonatomic, strong) NSMutableDictionary *headerArguments;

/**
 *  时间格式
 */
@property (nonatomic, strong) NSDateFormatter *formatter;
@end

KWAppServiceArgumentsAttach *g_appServiceArgumentsAttach = nil;

@implementation KWAppServiceArgumentsAttach

- (instancetype)initWithBodyArguments:(NSDictionary *)bodyArguments headerArguments:(NSDictionary *)headerArguments
{
    if (self = [super init]) {
        _bodyArguments = [NSMutableDictionary dictionaryWithCapacity:0];
        _headerArguments = [NSMutableDictionary dictionaryWithCapacity:0];
        if (bodyArguments) {
            [_bodyArguments addEntriesFromDictionary:bodyArguments];
        }
        if (headerArguments) {
            [_headerArguments addEntriesFromDictionary:headerArguments];
        }
    }
    return self;
}

+(KWAppServiceArgumentsAttach *)sharedInstance
{
    if( g_appServiceArgumentsAttach )
        return g_appServiceArgumentsAttach;
    else
    {
        g_appServiceArgumentsAttach = [[KWAppServiceArgumentsAttach alloc] init];
        return g_appServiceArgumentsAttach;
    }
}

- (instancetype)init
{
    if (self = [super init]) {
        _bodyArguments = [NSMutableDictionary dictionaryWithCapacity:0];
        _headerArguments = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}
#pragma mark - 
- (NSDictionary *)KWAppServiceBodyArgumentsAttach:(NSDictionary *)sourceBody
{
    NSMutableDictionary *bodyArguments = [[NSMutableDictionary alloc] initWithDictionary:sourceBody];
//    //appkey
//    if(![sourceBody objectForKey:@"appkey"])
//    {
//        [bodyArguments setObject:self.appKey forKey:@"appkey"];
//    }
 
    //版本号
    if (![sourceBody objectForKey:@"versionNumber"]) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        [bodyArguments setObject:app_Version forKey:@"versionNumber"];
    }
    //1是代表iOS
    if (![sourceBody objectForKey:@"mobileType"]) {
        [bodyArguments setObject:@"1" forKey:@"mobileType"];
    }
    //添加用户信息
    if ([KWAppUserProfile sharedInstance].isLogon) {
        [bodyArguments setObject:[KWAppUserProfile sharedInstance].userId forKey:@"userId"];
        [bodyArguments setObject:[KWAppUserProfile sharedInstance].oauthToken forKey:@"token"];
    }
    
    _bodyArguments = bodyArguments;
    return [bodyArguments copy];
}

- (NSDictionary *)KWAppServiceHeaderArgumentsAttach:(NSDictionary *)sourceHeader
{
    NSMutableDictionary *headerArguments = [[NSMutableDictionary alloc] initWithDictionary:sourceHeader];
    
    //添加用户信息
    if ([KWAppUserProfile sharedInstance].isLogon) {
        [headerArguments setObject:[KWAppUserProfile sharedInstance].oauthToken forKey:@"token"];
    }else{
        [headerArguments setObject:@"" forKey:@"token"];
    }
    [headerArguments setObject:[self returnSignature] forKey:@"signMsg"];
    _headerArguments = headerArguments;
    return [headerArguments copy];
}

#pragma mark -

- (UInt64)currentTimeStamp
{
    return [[NSDate date] timeIntervalSince1970]*1000;
}

+ (NSString *)md5WithString:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}
+ (NSString *)md5WithUpperString:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}

- (NSString *)returnSignature {
    NSMutableString *mutabelString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",self.appKey]];
    if ([KWAppUserProfile sharedInstance].isLogon) {
    [mutabelString appendString:[KWAppUserProfile sharedInstance].oauthToken];
    }
    //排序
    NSArray *sortKey = [_bodyArguments.allKeys sortedArrayUsingSelector:@selector(compare:)];
    //body 字段拼接
    NSString *paramsStr = [self returnSignature:sortKey arguments:_bodyArguments] ;
    //body 字段和appkey + token 拼接
    [mutabelString appendString:[NSString stringWithFormat:@"%@",paramsStr]];
    //MD5 结果
    mutabelString = [[KWAppServiceArgumentsAttach md5WithString:mutabelString] mutableCopy];
    //uppercaseString 转大写
    return [mutabelString uppercaseString];
}

- (NSString *)returnSignature:(NSArray *)keySort arguments:(NSDictionary *)arguments
{
    NSMutableString *mutabelString = [[NSMutableString alloc] init];
    for (NSString *key in keySort) {
        [mutabelString appendFormat:@"%@=%@",key,arguments[key]];
        [mutabelString appendString:@"|"];
    }
    //过滤最后一个|符号
    NSString *temStr = @"";
    if (mutabelString.length) {
        temStr = [mutabelString substringToIndex:mutabelString.length-1];
    }
    return temStr;
}

- (NSString *)validateMD5EncryptionBody:(NSString *)bodyStr
{
    NSString *temStr = [NSString stringWithFormat:@"%@%@",self.appKey,bodyStr];
    return [KWAppServiceArgumentsAttach md5WithString:temStr];
}
- (BOOL)validationExpression:(NSString *)inputStr
{
    //6-16位  数字+字母 区分大小写
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$"];
    return [predicate evaluateWithObject:inputStr];
}
@end
