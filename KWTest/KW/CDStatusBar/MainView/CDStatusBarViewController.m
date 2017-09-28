//
//  CDStatusBarViewController.m
//  Pods
//
//  Created by aaaa on 16/8/13.
//
//

#import "CDStatusBarViewController.h"

/**
 vc的view
 */
@interface CDStatusBarContainerView : UIView

@end

@implementation CDStatusBarContainerView

@end
@interface CDStatusBarViewController ()

@end

@implementation CDStatusBarViewController

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    _statusBarStyle = statusBarStyle;
    //更新
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark UIViewController

//是否可旋转
- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return [UIApplication sharedApplication].statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
}

- (void)loadView {
    self.view = [[CDStatusBarContainerView alloc] init];
    _list = [[CDStatusBarTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_list];
}

//将要旋转时

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    self.view.frame = CDGetStatusBarFrameForOrientation(CDGetDeviceOrientation());
    if (_statusBarView) {
        _statusBarView.frame = CDGetStatusBarFrameForOrientation(CDGetDeviceOrientation());
    }
}

#pragma mark - list

- (void)expendSelectItems:(NSArray *)items
{
    CGRect listFrame;
    CGRect viewFrame;
    NSInteger showMaxItem = ([[UIScreen mainScreen] bounds].size.height/2)/cellHeight;
    NSInteger showItem = showMaxItem > items.count+1? items.count+1:showMaxItem;
    
    listFrame = CGRectMake(0, _statusBarView.frame.size.height, _statusBarView.frame.size.width, showItem * cellHeight+60);
    viewFrame = CGRectMake(0, 0, _statusBarView.frame.size.width, showItem * cellHeight+20+60);
    _list.backgroundColor = _statusBarView.backgroundColor;
    _list.items = items;
    [_list reloadData];
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionTransitionCrossDissolve;
    [UIView transitionWithView:self.view duration:0.25 options:options animations:^{
        _list.frame = listFrame;
        self.view.frame = viewFrame;
    } completion:nil];

}

- (void)closeSelectItems
{
    CGRect listFrame;
    CGRect viewFrame;
    listFrame = CGRectMake(0, _statusBarView.frame.size.height, _statusBarView.frame.size.width, 0);
    viewFrame = CGRectMake(0, 0, _statusBarView.frame.size.width, 20);
    _list.items = nil;
    _list.backgroundColor = _statusBarView.backgroundColor;
    [_list reloadData];
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionTransitionCrossDissolve;
    [UIView transitionWithView:self.view duration:0.25 options:options animations:^{
        _list.frame = listFrame;
        self.view.frame = viewFrame;
    } completion:nil];

}
@end
