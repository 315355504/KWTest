//
//  CDStatusBar.h
//  Pods
//
//  Created by aaaa on 16/8/11.
//
//

#import "CDStatusBarConfig.h"
#import "CDStatusBarWindow.h"
#import "CDStatusBarViewController.h"

@protocol CDStatusBarDelegate <NSObject>

/**
 点击代理

 @param index 所以
 @param prompt 文案
 */
- (void)statusBarSelectAtIndex:(NSInteger)index prompt:(NSString *)prompt;

@end

extern NSString * const CDStatusBarHadSelect;
/**
 *  处理业务逻辑，和存储数据源
 */
@interface CDStatusBar : NSObject


/**
 代理
 */
@property (nonatomic, weak)id<CDStatusBarDelegate> delegate;
/**
 初始化默认显示文案
 */
@property (nonatomic, copy) NSString *defaultPrompt;

@property (nonatomic, strong) NSMutableArray *items;

+ (instancetype)sharedInstance;

@end
