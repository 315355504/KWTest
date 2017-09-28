//
//  KWAddressBookManager.h
//  CashLoan
//
//  Created by hey on 2017/3/3.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <UIKit/UIKit.h>

typedef void(^YFAddressBookBlock)(BOOL canRead, ABAuthorizationStatus authorStatus);

@interface KWAddressBookManager : NSObject

@property (nonatomic, assign) ABAddressBookRef addressBook;
//单例类方法
+ (instancetype)shareManger;

//设置传值
- (void)canReadAddressBookWithBlock:(YFAddressBookBlock)block;

- (void)gotoSetting:(UIViewController *)vc;

@end
