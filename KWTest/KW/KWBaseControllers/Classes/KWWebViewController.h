//
//  KWWebViewController.h
//  Pods
//
//  Created by cxk@erongdu.com on 2017/1/11.
//
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

typedef NS_ENUM(NSInteger, KWWebViewSendMethod)
{
    KWWebViewSendMethodPOST = 0,
    KWWebViewSendMethodGET = 1,
};

@interface KWWebViewController : UIViewController

/**
 *  url链接
 */
@property (nonatomic, retain) NSString* url;
/**
 *  参数
 */
@property (nonatomic, strong) NSDictionary *param;

/**
 web
 */
@property (nonatomic, strong) WKWebView * wkWebView;

/**
 头参数
 */
@property (nonatomic, strong) NSDictionary *headerParam;

/**
 请求方式
 */
@property (nonatomic, assign) KWWebViewSendMethod method;

/**
 是否显示网页标题
 */
@property (nonatomic, assign) BOOL isShowTitle;

/**
 刷新网页
 */
-(void)needRefreshWebView;

#pragma mark -子类需要重写的方法

- (void)changeShowView:(WKWebView *)webview progressView:(UIProgressView *)progressView;
@end
