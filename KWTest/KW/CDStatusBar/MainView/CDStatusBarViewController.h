//
//  CDStatusBarViewController.h
//  Pods
//
//  Created by aaaa on 16/8/13.
//
//

#import <UIKit/UIKit.h>
#import "CDStatusBarView.h"
#import "CDStatusBarConfig.h"
#import "CDStatusBarTableView.h"

@interface CDStatusBarViewController : UIViewController

@property (nonatomic, strong) CDStatusBarView *statusBarView;

/**
 *  状态栏样式
 */
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

@property (nonatomic, strong) CDStatusBarTableView *list;


- (void)expendSelectItems:(NSMutableArray *)items;

- (void)closeSelectItems;
@end
