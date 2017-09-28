//
//  GetIpAddress.h
//  CashLoan
//
//  Created by hey on 2017/5/11.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetIpAddress : NSObject


/**
 获取设备IP地址

 @param preferIPv4 IPv6->true ,IPv4 -> false
 @return 字符串ip
 */
+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (BOOL)isValidatIP:(NSString *)ipAddress;

+ (NSDictionary *)getIPAddresses;

@end
