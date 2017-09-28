//
//  KWPageViewController.h
//  KWPageViewController v0.5
//
//  Created by Nico Arqueros on 10/17/14.
//  Copyright (c) 2014 Moblox. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KWPageMode) {
    KW_FreeButtons,
    KW_LeftRightArrows,
    KW_SegmentController
};

@protocol KWPageControllerDataSource;
@protocol KWPageControllerDataDelegate;

@interface KWPageViewController : UIPageViewController

@property (nonatomic, assign) id<KWPageControllerDataSource>   KWDataSource;
@property (nonatomic, assign) id<KWPageControllerDataDelegate> KWDataDelegate;

@property (nonatomic, assign) KWPageMode                           pageMode;     // This selects the mode of the PageViewController

- (void)reloadPages;                                                        // Like reloadData in tableView. You need to call this method to update the stack of viewcontrollers and/or buttons
- (void)reloadPagesToCurrentPageIndex:(NSInteger)currentPageIndex;          // Like reloadData in tableView. You need to call this method to update the stack of viewcontrollers and/or buttons

- (void)moveToViewNumber:(NSInteger)viewNumber __attribute__((deprecated));                // Default to YES. Deprecated.
- (void)moveToViewNumber:(NSInteger)viewNumber animated:(BOOL)animated;     // The ViewController position. Starts from 0
@end

@protocol KWPageControllerDataSource <NSObject>
@required
- (NSArray *)KWPageButtons;
- (NSArray *)KWPageControllers;
- (UIView *)KWPageContainer;
@optional
- (void)otherConfiguration;                         // Good place to put methods that you want to execute after everything is ready i.e. moveToViewNumber to set a different starting page.
@end

@protocol KWPageControllerDataDelegate <NSObject>
@optional
- (void)KWPageChangedToIndex:(NSInteger)index;
@end
