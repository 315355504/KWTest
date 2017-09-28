//
//  CDStatusBar.m
//  Pods
//
//  Created by aaaa on 16/8/11.
//
//

#import "CDStatusBar.h"
#import "CDStatusBarDataManage.h"

static  CDStatusBar *sharedInstance = nil;

NSString * const CDStatusBarHadSelect = @"CDStatusBarHadSelect";

@interface CDStatusBar ()<CDStatusBarTableViewDelegate, CDStatusBarViewDelegate>
/**
 *  跟状态栏同级的window
 */
@property (nonatomic, strong) CDStatusBarWindow *statusBarWindow;

@property (nonatomic, strong) CDStatusBarViewController *statusBarViewController;

@property (nonatomic, assign) BOOL flag;
@end

@implementation CDStatusBar

+ (instancetype)sharedInstance
{
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[CDStatusBar alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        //window
        _statusBarViewController = [CDStatusBarViewController new];
        _statusBarWindow = [[CDStatusBarWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _statusBarWindow.backgroundColor = [UIColor clearColor];
        _statusBarWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _statusBarWindow.windowLevel = UIWindowLevelStatusBar;
        _statusBarWindow.rootViewController = _statusBarViewController;
        _statusBarWindow.rootViewController.view.clipsToBounds = YES;
        //设置no之后rootVc才会出现
        _statusBarWindow.hidden = NO;
        
        //设置window的rootvc后再对rootvc进行修改
        _statusBarViewController.view.frame = CDGetStatusBarFrameForOrientation(CDGetDeviceOrientation());
        _statusBarViewController.statusBarView = [[CDStatusBarView alloc] initWithFrame:CDGetStatusBarFrameForOrientation(CDGetDeviceOrientation())];
        _statusBarViewController.statusBarView.backgroundColor = [UIColor colorWithRed:51/255.0 green:163/255.0 blue:220/255.0 alpha:0.5];
        _statusBarViewController.statusBarView.prompt.text = self.defaultPrompt;
        _statusBarViewController.statusBarView.delegate = self;
        _statusBarViewController.list.statusBarTableViewDelegate = self;
        
        [_statusBarViewController.view addSubview:_statusBarViewController.statusBarView];
        
        _flag = NO;
    }
    return self;
}

- (void)setDefaultPrompt:(NSString *)defaultPrompt
{
    _defaultPrompt = defaultPrompt;
    _statusBarViewController.statusBarView.prompt.text = defaultPrompt;
}
#pragma mark -CDStatusBarViewDelegate
- (void)statusBarViewTouch:(CDStatusBarView *)barView
{
    if (!_flag)
    {
        _flag = YES;
        _items = [CDStatusBarDataManage listItem];
        [_statusBarViewController expendSelectItems:_items];
    }
    else
    {
        _flag = NO;
        [_statusBarViewController closeSelectItems];
    }
}


#pragma mark -CDStatusBarTableViewDelegate

- (void)statusBarTableView:(CDStatusBarTableView *)tableView selectAtIndex:(NSInteger)index
{
    _flag = NO;
    //赋值
    _statusBarViewController.statusBarView.prompt.text = _items[index];
    if (_delegate && [_delegate respondsToSelector:@selector(statusBarSelectAtIndex:prompt:)]) {
        [_delegate statusBarSelectAtIndex:index prompt:_items[index]];
    }
    //更新值
    [_statusBarViewController closeSelectItems];
}

- (void)statusBarTableView:(CDStatusBarTableView *)tableView addItem:(NSString *)item
{
    _items = [CDStatusBarDataManage addItem:item];
    self.statusBarViewController.list.items = _items;
    [self.statusBarViewController.list insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_items.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)statusBarTableView:(CDStatusBarTableView *)tableView deleteAtIndex:(NSInteger)index
{
   _items = [CDStatusBarDataManage deleteItemAtIndex:index];
    self.statusBarViewController.list.items = _items;
}
@end
