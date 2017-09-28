//
//  KWDictManager.m
//  CashLoan
//
//  Created by Mr_zhaohy on 2017/2/21.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import "KWDictManager.h"

@implementation KWDictManager
+ (KWDictManager *)shareManager{
    static KWDictManager *manager=nil;
    static dispatch_once_t oncet;
    dispatch_once(&oncet, ^{
        manager=[[self alloc]init];
    });
    return manager;
}
@end
