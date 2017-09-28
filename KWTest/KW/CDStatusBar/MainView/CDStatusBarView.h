//
//  CDStatusBarView.h
//  Pods
//
//  Created by aaaa on 16/8/11.
//
//

#import <UIKit/UIKit.h>



extern NSString * const CDStatusBarViewTouch;

@class CDStatusBarView;

@protocol CDStatusBarViewDelegate <NSObject>

- (void)statusBarViewTouch:(CDStatusBarView *)barView;

@end
/**
 *  statusBar视图，发送对应事件消息
 */
@interface CDStatusBarView : UIView


@property (nonatomic, weak)id<CDStatusBarViewDelegate> delegate;
/**
 *  显示内容
 */
@property (nonatomic, strong) UILabel *prompt;

@end
