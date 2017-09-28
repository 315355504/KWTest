//
//  UIControl+avoidDuplicate.h
//  baianlicai
//
//  Created by Liang Shen on 16/5/11.
//  Copyright © 2016年 Yosef Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (avoidDuplicate)
@property (nonatomic, assign) NSTimeInterval kw_acceptEventInterval;// 可以用这个给重复点击加间隔

@end
