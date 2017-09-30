//
//  AutoBannerScrollView.h
//  CashLoan
//
//  Created by xia on 2017/8/9.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickWithBlock)(NSInteger index);

@interface AutoBannerScrollView : UIView

@property (nonatomic, strong) UIColor *pageIndicatorTintColor;
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;

/**
 *  创建本地图片
 *
 *  @param imageNames   图片名字数组
 *  @param timeInterval 自动切换时间(0为不切换)
 *  @return             创建本地图片
 */
-(id)initWithImageNames:(NSArray *)imageNames autoTimerInterval:(NSTimeInterval)timeInterval clickBlock:(ClickWithBlock)block;


/**
 *  创建网络图片 init
 *
 *  @param imageUrls   图片名字数组
 *  @param timeInterval 自动切换时间(0为不切换)
 *  @return             创建网络图片
 */
-(id)initWithImageUrls:(NSArray *)imageUrls autoTimerInterval:(NSTimeInterval)timeInterval clickBlock:(ClickWithBlock)block;


/**
 *  更换图片地址
 *
 *  @param imageUrls    图片地址
 */
-(void)replaceImageUrls:(NSArray *)imageUrls clickBlock:(ClickWithBlock)block;


/**
 *  更换图片
 *
 *  @param imageNames   图片文件名
 */
-(void)replaceImageNames:(NSArray *)imageNames clickBlock:(ClickWithBlock)block;

@end
