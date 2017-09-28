//
//  KWViewController.h
//  demoapp
//
//  Created by Liang Shen on 16/3/23.
//  Copyright © 2016年 Yosef Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KWViewController;
@protocol KWViewControllerDelegate <NSObject>
/**
 *  重新请求
 */
-(void) requestNow;

@end

@interface KWViewController : UIViewController

#pragma mark -Need Overwriting

/**
 KWViewController进行DidLoad时，调用设置显示属性，子类需重写该方法
 */
- (void)viewControllerDidLoad;

@property (nonatomic , assign) id<KWViewControllerDelegate> KWViewControllerDelegate;

/**
 *  展现无网络视图
 */
-(void) showNetworkProblemView;

/**
 *  移除无网络视图
 */
-(void)dismissNetwrokProblemView;


@end
