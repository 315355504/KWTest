//
//  KWShareManage.h
//  CashLoan
//
//  Created by 李帅良 on 2017/2/20.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ShareType){
    wx,
    wechatf,
    sina,
    qq,
    qqzone
};

@interface KWShareManage : NSObject

//获取全局的单例
+(KWShareManage *)sharedInstance;
-(void)shareButtonActionWithSharetype:(ShareType)shareType withContentDic:(NSDictionary *)dic;
@end
