//
//  KWAddressBookManager.m
//  CashLoan
//
//  Created by hey on 2017/3/3.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import "KWAddressBookManager.h"


@implementation KWAddressBookManager

+ (instancetype)shareManger{
    static KWAddressBookManager *manger = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manger) {
            manger = [[KWAddressBookManager alloc]init];
        }
    });
    return manger;
}

- (id)init{
    self = [super init];
    if (self) {
        _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    }
    
    return self;
}

//获取读取权限
- (void)canReadAddressBookWithBlock:(YFAddressBookBlock)block{
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    if (authStatus == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(_addressBook, ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    //拒绝访问
                    block(NO,kABAuthorizationStatusDenied);
                }else{
                    block(YES,0);
                }
            });
        });
    }else if (authStatus == kABAuthorizationStatusAuthorized){
        block(YES,0);
    }else{
        block(NO,authStatus);
    }
}

//去设置页面
- (void)gotoSetting:(UIViewController *)vc{
    NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
    if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
    NSString *message = [NSString stringWithFormat:@"请在%@的\"设置-隐私-通讯录\"选项中，\r允许%@访问你的通讯录。",[UIDevice currentDevice].model,appName];
    
    UIAlertController *alertVC = [[UIAlertController alloc]init];
    [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancleAction];
    [alertVC addAction:sureAction];
}

@end
