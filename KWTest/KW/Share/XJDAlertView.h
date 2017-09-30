//
//  RepaymentViewController.h
//  Erongdu
//
//  Created by 李帅良 on 2017/2/15.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ButtonType)
{
    Normal,
    LeftGray,
    RightGray
};

@interface XJDAlertView : UIView


/**
 XJDAlertView初始化

 @param title 标题
 @param content 内容
 @param leftTitle 左边按钮标题
 @param rigthTitle 右边按钮标题
 */
- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle;


/**
 XJDAlertView初始化

 @param title 标题
 @param content 内容
 @param leftTitle 左边按钮标题
 @param rigthTitle 右边按钮标题
 @param buttonType 按钮类型
 */
- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
         buttonType:(ButtonType)buttonType;


/**
 调用显示
 */
- (void)show;

@property (nonatomic, copy) dispatch_block_t leftBlock;//左边按钮事件
@property (nonatomic, copy) dispatch_block_t rightBlock;//右边按钮事件
@property (nonatomic, copy) dispatch_block_t dismissBlock;
@property (nonatomic, strong) UIView *backImageView;


/**
 调研隐藏
 */
- (void)dismissAlert;

@end
