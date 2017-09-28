//
//  KWNetworkResult.h
//  HuiBang
//
//  Created by 李帅良 on 2017/1/10.
//  Copyright © 2017年 Mr_zhaohy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWNetworkResult : NSObject
/**
 *  返回结果code
 */
@property (nonatomic, assign)NSInteger code;
/**
 *  返回的Message
 */
@property (nonatomic, strong)NSString *msg;
/**
 *  返回数据resData,可选
 */
@property (nonatomic, strong)NSDictionary *data;
@property (nonatomic, strong)NSDictionary *page;
@end
