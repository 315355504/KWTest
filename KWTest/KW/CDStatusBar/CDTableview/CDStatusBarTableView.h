//
//  CDStatusBarTableView.h
//  Pods
//
//  Created by aaaa on 16/8/16.
//
//

#import <UIKit/UIKit.h>

const static CGFloat cellHeight = 44;

extern NSString * const CDStatusBarTableViewSelect;
extern NSString * const CDStatusBarViewTouch;

@class CDStatusBarTableView;

@protocol CDStatusBarTableViewDelegate <NSObject>

- (void)statusBarTableView:(CDStatusBarTableView *)tableView selectAtIndex:(NSInteger)index;

- (void)statusBarTableView:(CDStatusBarTableView *)tableView addItem:(NSString *)item;

- (void)statusBarTableView:(CDStatusBarTableView *)tableView deleteAtIndex:(NSInteger)index;

@end
@interface CDStatusBarTableView : UITableView

@property (nonatomic, weak) id<CDStatusBarTableViewDelegate> statusBarTableViewDelegate;

@property (nonatomic, strong) NSMutableArray *items;

@end
