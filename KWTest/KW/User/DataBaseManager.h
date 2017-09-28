//
//  DataBaseManager.h
//  Crowdfunding
//
//  Created by aaaa on 16/6/13.
//  Copyright © 2016年 erongdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWAppUserProfile.h"
#import <FMDB/FMDB.h>
//#import "SearchHistoryModel.h"
//#import "CondictionSearch.h"
//#import "KVP.h"
//#import "RegionModel.h"

@interface DataBaseManager : NSObject

/**
 *  单例
 *
 *  @return 对象
 */
+ (instancetype) sharedInstance;
/**
 *  创建默认数据库
 */
- (void)createDefaultDataBase;
/**
 *  创建数据库
 *
 *  @param dataBaseName 数据库名字
 *
 *  @return 返回数据库对象
 */
- (FMDatabase *)createDataBaseName:(NSString *)dataBaseName;

///**
// *  获取省
// *
// *  @return 省
// */
//- (NSMutableArray<RegionModel *> *)getProvinceRegionList;
//
///**
// *  获取市
// *
// *  @return 市
// */
//- (NSMutableArray<RegionModel *> *)getCityRegionList;
///**
// *   获取区
// *
// *  @return 区
// */
//- (NSMutableArray<RegionModel *> *)getAreaRegionList;
///**
// *  存储省市区
// *
// *  @param regionList 省市区列表
// */
//- (void)setRegionList:(NSArray<RegionModel *> *)regionList;
//
///**
// *  获取地址省
// *
// *  @return 省
// */
//- (NSMutableArray<RegionModel *> *)getProvinceAddressRegionList;
//
///**
// *  获取地址市
// *
// *  @return 市
// */
//- (NSMutableArray<RegionModel *> *)getCityAddressRegionList;
///**
// *   获取地址区
// *
// *  @return 区
// */
//- (NSMutableArray<RegionModel *> *)getAreaAddressRegionList;
///**
// *  存储地址省市区
// *
// *  @param regionList 省市区列表
// */
//- (void)setAddressRegionList:(NSArray<RegionModel *> *)regionList;
//
//- (void)setEquitySearchHistoryKeyWord:(NSString *)keyword;
//
//- (NSMutableArray<SearchHistoryModel *> *)getEquitySearchHistory;
//
//- (void)deleteEquitySearchHistory;
//
//- (void)setProductSearchHistoryKeyWord:(NSString *)keyword;
//
//- (NSMutableArray<SearchHistoryModel *> *)getProductSearchHistory;
//
//- (void)deleteProductSearchHistory;
//
///**
// *  存储筛选数据
// *
// *  @param condition 筛选单例
// */
//- (void)setSearchCondition:(NSArray<KVP *> *)conditionlist;
///**
// *  从本地获取筛选数据
// */
//- (void)getSearchCondition;

//-------------------------------------------------------

- (BOOL)savetUserInfo:(KWAppUserProfile *)userInfo;

- (void)updateUserInfo:(KWAppUserProfile *)userInfo gesturePWD:(NSString *)gesturePwd;

- (void)updateUserInfo:(KWAppUserProfile *)userInfo openTouchID:(BOOL)open;

- (BOOL)checkUserInfo:(KWAppUserProfile *)userInfo gesturePWD:(NSString *)gesturePwd;

- (BOOL)userIsOpenTouchID:(KWAppUserProfile *)userInfo;

- (void)loadUser:(KWAppUserProfile *)userInfo;

- (BOOL)userLogOut:(KWAppUserProfile *)userInfo;

- (NSString *)getGesturePWD:(KWAppUserProfile *)userInfo;

@end
