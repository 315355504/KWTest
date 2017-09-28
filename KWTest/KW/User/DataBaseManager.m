//
//  DataBaseManager.m
//  Crowdfunding
//
//  Created by aaaa on 16/6/13.
//  Copyright © 2016年 erongdu. All rights reserved.
//

#import "DataBaseManager.h"
//#import "KVP.h"

#define DefaultBaseName @"appData.sqlite"
//银行卡省市区
#define CreateAreaTable @"CREATE TABLE IF NOT EXISTS REGION(id INTEGER PRIMARY KEY AUTOINCREMENT, PID INTEGER, NID INTEGER, NAME TEXT)"
#define GetRegionList   @"SELECT * FROM REGION"
#define SetRegion       @"INSERT INTO REGION(PID, NID, NAME) VALUES(%ld, %ld, '%@')"
#define DeleteRegionList @"DELETE FROM REGION"
#define UpdateRegion    @"UPDATE sqlite_sequence SET seq=0 WHERE name='REGION'"
#define GetRegionProvince @"SELECT T.* FROM REGION T WHERE T.PID = 0 ORDER BY T.PID ASC"
#define GetRegionCity @"SELECT T.* FROM REGION T, REGION B WHERE T.PID = B.NID AND B.PID = 0 ORDER BY T.PID ASC"
#define GetRegionArea @"SELECT T.* FROM REGION T, REGION B WHERE T.PID = B.NID AND B.PID != 0 ORDER BY T.PID ASC"

//地址省市区
#define CreateAddressAreaTable @"CREATE TABLE IF NOT EXISTS ADDRESSREGION(id INTEGER PRIMARY KEY AUTOINCREMENT, PID INTEGER, NID INTEGER, NAME TEXT)"
#define GetAddressRegionList   @"SELECT * FROM ADDRESSREGION"
#define SetAddressRegion       @"INSERT INTO ADDRESSREGION(PID, NID, NAME) VALUES(%ld, %ld, '%@')"
#define DeleteAddressRegionList @"DELETE FROM ADDRESSREGION"
#define UpdateAddressRegion    @"UPDATE sqlite_sequence SET seq=0 WHERE name='ADDRESSREGION'"
#define GetAddressRegionProvince @"SELECT T.* FROM ADDRESSREGION T WHERE T.PID = 0 ORDER BY T.PID ASC"
#define GetAddressRegionCity @"SELECT T.* FROM ADDRESSREGION T, ADDRESSREGION B WHERE T.PID = B.NID AND B.PID = 0 ORDER BY T.PID ASC"
#define GetAddressRegionArea @"SELECT T.* FROM ADDRESSREGION T, ADDRESSREGION B WHERE T.PID = B.NID AND B.PID != 0 ORDER BY T.PID ASC"

//搜索记录表
#define CreateSearchHistory @"CREATE TABLE IF NOT EXISTS SEARCHHISTORY(id INTEGER PRIMARY KEY AUTOINCREMENT, KEYWORD TEXT UNIQUE, TYPE INTEGER NOT NULL DEFAULT 0, ADDTIME TIMESTAMP NOT NULL DEFAULT (DATETIME('NOW','LOCALTIME')))"
#define SetSearchHistory @"INSERT OR REPLACE INTO SEARCHHISTORY (KEYWORD,TYPE) VALUES('%@',%@)"
#define GetSearchHistory @"SELECT * FROM SEARCHHISTORY WHERE TYPE = %@ ORDER BY ADDTIME DESC"
#define DeleteSearchHistory @"DELETE FROM SEARCHHISTORY WHERE TYPE = %@"
#define UpdateSearchHistory @"UPDATE sqlite_sequence SET seq=0 WHERE name='SEARCHHISTORY'"

//筛选存储
#define CreateSearchCondition @"CREATE TABLE IF NOT EXISTS SEARCHCONDITION(id INTEGER PRIMARY KEY AUTOINCREMENT, KEY TEXT, VALUE TEXT NOT NULL, TYPE INTEGER NOT NULL)"
#define SetSearchCondition @"INSERT OR REPLACE INTO SEARCHCONDITION(KEY, VALUE, TYPE) VALUES('%@', '%@',%@)"
#define GetSearchCondition @"SELECT * FROM SEARCHCONDITION ORDER BY TYPE"
#define DeleteSearchCondition @"DELETE FROM SEARCHCONDITION"
#define UpdateSearchCondition @"UPDATE sqlite_sequence SET seq=0 WHERE name='SEARCHCONDITION'"

#define CreateUser    @"CREATE TABLE IF NOT EXISTS USER(id INTEGER PRIMARY KEY AUTOINCREMENT, AVATARPHOTO TEXT, EXPIRESIN TEXT, HIDEUSERNAME TEXT, REFRESHTOKEN TEXT, OAUTHTOKEN TEXT, USERID TEXT, USERNAME TEXT, GESTUREPWD TEXT, TOUCHID INTEGER DEFAULT 0)"
//当登录时，存储信息
#define SaveUser @"INSERT INTO USER(AVATARPHOTO, EXPIRESIN, HIDEUSERNAME,REFRESHTOKEN,OAUTHTOKEN,USERID,USERNAME) VALUES('%@', '%@', '%@', '%@','%@', '%@','%@')"
//更新
#define UpdateUser @"UPDATE USER SET AVATARPHOTO = '%@', EXPIRESIN = '%@', HIDEUSERNAME = '%@', REFRESHTOKEN = '%@', OAUTHTOKEN = '%@',USERNAME = '%@' WHERE USERID = '%@'"
//是否存在该用户
#define ExistUser @"SELECT * FROM USER WHERE USERID = '%@'"
//更新手势密码
#define UpdateGuesturePWD  @"UPDATE USER SET GESTUREPWD = '%@' WHERE USERID = '%@'"
//判断手势密码是否正确
#define GetGuesturePWD @"SELECT GESTUREPWD FROM USER WHERE USERID = '%@'"
//更新指纹
#define UpdateTouchID  @"UPDATE USER SET TOUCHID = %@ WHERE USERID = '%@'"
//加载用户 当OAUTHTOKEN 不为空的时候
#define LoadUser @"SELECT AVATARPHOTO, EXPIRESIN, HIDEUSERNAME, REFRESHTOKEN,OAUTHTOKEN,USERID,USERNAME FROM USER WHERE OAUTHTOKEN NOT NULL"
//判断当前用户是否开启指纹识别
#define IsOpenTouchID @"SELECT TOUCHID FROM USER WHERE USERID = '%@'"
//用户退出
#define UserLogOut @"UPDATE USER SET OAUTHTOKEN = NULL, REFRESHTOKEN = NULL WHERE USERID = '%@'"

////创建文件存放目录
//#define CreateFileDownload @"FILEDOWNLOAD "

@interface DataBaseManager ()

/**
 *  默认数据库
 */
@property (nonatomic, strong) FMDatabase *defaultDataBase;
@end
@implementation DataBaseManager

static  DataBaseManager *sharedInstance = nil;

/*
 获取全局的单例
 */
+ (instancetype) sharedInstance
{
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[DataBaseManager alloc] init];
    });
    return sharedInstance;
}
//打开的前提下
- (void)createInitTableByDatabase
{
    if ([_defaultDataBase open]) {
        //        //创建区域表
        //        if (![_defaultDataBase executeUpdate:CreateAreaTable]) {
        //            NSLog(@"银行卡地址表创建失败");
        //        }
        //        if (![_defaultDataBase executeUpdate:CreateAddressAreaTable])
        //        {
        //            NSLog(@"地址表创建失败");
        //        }
        //        //创建搜索历史记录表
        //        if (![_defaultDataBase executeUpdate:CreateSearchHistory]) {
        //            NSLog(@"搜索历史表创建失败");
        //        }
        //        //创建筛选表
        //        if (![_defaultDataBase executeUpdate:CreateSearchCondition])
        //        {
        //            NSLog(@"筛选条件表创建失败");
        //        }
        //创建用户表
        if (![_defaultDataBase executeUpdate:CreateUser])
        {
            NSLog(@"创建用户表失败");
        }
        //关闭
        [_defaultDataBase close];
    }
}
- (FMDatabase *)createDataBaseName:(NSString *)dataBaseName
{
    //APP所在路径
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(
                                                               NSDocumentDirectory,
                                                               NSUserDomainMask,
                                                               YES);
    NSString *documentFolderPath = [searchPaths objectAtIndex:0];
    
    //往应用程序路径中添加数据库文件名称，把它们拼接起来
    NSString *dbFilePath = [documentFolderPath stringByAppendingPathComponent:dataBaseName];
    
    //没有则创建
    FMDatabase *dataBase=[FMDatabase databaseWithPath:dbFilePath];
    
    return dataBase;
}


- (void)createDefaultDataBase
{
    _defaultDataBase = [self createDataBaseName:DefaultBaseName];
    [self createInitTableByDatabase];
}

#pragma mark -存储或更新用户信息
- (BOOL)savetUserInfo:(KWAppUserProfile *)userInfo
{
    BOOL status;
    if([_defaultDataBase open])
    {
        FMResultSet *result = [_defaultDataBase executeQuery:[NSString stringWithFormat:ExistUser, userInfo.userId]];
        if (result.next) {
            status = [_defaultDataBase executeUpdate:[NSString stringWithFormat:UpdateUser,userInfo.avatarPath,userInfo.expiresIn,userInfo.hideUserName,userInfo.refreshToken,userInfo.oauthToken,userInfo.userName,userInfo.userId]];
        }
        else
        {
            status = [_defaultDataBase executeUpdate:[NSString stringWithFormat:SaveUser,userInfo.avatarPath,userInfo.expiresIn,userInfo.hideUserName,userInfo.refreshToken,userInfo.oauthToken,userInfo.userId,userInfo.userName]];
        }
        [_defaultDataBase close];
    }
    return status;
}


- (void)updateUserInfo:(KWAppUserProfile *)userInfo gesturePWD:(NSString *)gesturePwd
{
    if ([_defaultDataBase open]) {
        if (![_defaultDataBase executeUpdate:[NSString stringWithFormat:UpdateGuesturePWD, gesturePwd, userInfo.userId]]) {
        }
        [_defaultDataBase close];
    }
}

- (void)updateUserInfo:(KWAppUserProfile *)userInfo openTouchID:(BOOL)open
{
    if ([_defaultDataBase open]) {
        if (![_defaultDataBase executeUpdate:[NSString stringWithFormat:UpdateTouchID, @(open), userInfo.userId]]) {
        }
        [_defaultDataBase close];
    }
}

- (NSString *)getGesturePWD:(KWAppUserProfile *)userInfo
{
    NSString *temp = @"";
    if ([_defaultDataBase open]) {
        FMResultSet *result=[_defaultDataBase executeQuery:[NSString stringWithFormat:GetGuesturePWD, userInfo.userId]];
        if (result.next) {
            temp = [result stringForColumn:@"GESTUREPWD"];
        }
        [_defaultDataBase close];
    }
    return temp;
}

- (BOOL)checkUserInfo:(KWAppUserProfile *)userInfo gesturePWD:(NSString *)gesturePwd
{
    return [gesturePwd isEqualToString:[self getGesturePWD:userInfo]];
}

- (BOOL)userIsOpenTouchID:(KWAppUserProfile *)userInfo
{
    if ([_defaultDataBase open]) {
        FMResultSet *result = [_defaultDataBase executeQuery:[NSString stringWithFormat:IsOpenTouchID, userInfo.userId]];
        if (result.next) {
            return [result boolForColumn:@"TOUCHID"];
        }
    }
    return NO;
}

- (void)loadUser:(KWAppUserProfile *)userInfo
{
    if ([_defaultDataBase open]) {
        FMResultSet *result=[_defaultDataBase executeQuery:LoadUser];
        if(result.next)
        {
            userInfo.hideUserName = [result stringForColumn:@"HIDEUSERNAME"];
            userInfo.userName = [result stringForColumn:@"USERNAME"];
            userInfo.oauthToken = [result stringForColumn:@"OAUTHTOKEN"];
            userInfo.userId = [result stringForColumn:@"USERID"];
            userInfo.refreshToken = [result stringForColumn:@"REFRESHTOKEN"];
            userInfo.avatarPath = [result stringForColumn:@"AVATARPHOTO"];
            //            userInfo.expiresIn = [NSString stringWithFormat:@"%f", [result stringForColumn:@"EXPIRESIN"] ];
        }
    }
}

- (BOOL)userLogOut:(KWAppUserProfile *)userInfo
{
    BOOL status = false;
    if([_defaultDataBase open])
    {
        status = [_defaultDataBase executeUpdate:[NSString stringWithFormat:UserLogOut, userInfo.userId]];
        //        if(![_defaultDataBase executeUpdate:[NSString stringWithFormat:UserLogOut, userInfo.bindingId]])
        //        {
        //        }
    }
    return status;
}

//#pragma mark -银行卡省市区
//- (NSMutableArray<RegionModel *> *)getRegionListBy:(NSString *)sql
//{
//    NSMutableArray *tempList = [NSMutableArray arrayWithCapacity:0];
//    if ([_defaultDataBase open]) {
//        FMResultSet *result=[_defaultDataBase executeQuery:sql];
//        while (result.next) {
//            RegionModel *region = [[RegionModel alloc] init];
//            region.pid = [result longForColumn:@"pid"];
//            region.nid = [result longForColumn:@"nid"];
//            region.name = [result stringForColumn:@"name"];
//            [tempList addObject:region];
//        }
//        [_defaultDataBase close];
//    }
//    return tempList;
//}
//
//- (NSMutableArray<RegionModel *> *)getProvinceRegionList
//{
//    return [self getRegionListBy:GetRegionProvince];
//}
//
//- (NSMutableArray<RegionModel *> *)getCityRegionList
//{
//    return [self getRegionListBy:GetRegionCity];
//}
//
//- (NSMutableArray<RegionModel *> *)getAreaRegionList
//{
//    return [self getRegionListBy:GetRegionArea];
//}
//
//- (void)setRegionList:(NSArray<RegionModel *> *)regionList
//{
//    if (regionList == nil || regionList.count == 0) {
//        NSLog(@"传入数据空");
//        return;
//    }
//    if ([_defaultDataBase open]) {
//        //删除之前的数据
//        [_defaultDataBase executeUpdate:DeleteRegionList];
//        //自增为0开始
//        [_defaultDataBase executeUpdate:UpdateRegion];
//        //开启事务
//        [_defaultDataBase beginTransaction];
//        BOOL isRollBack = NO;
//        @try{
//            for (RegionModel *region in regionList) {
//                if (![_defaultDataBase executeUpdate:[NSString stringWithFormat:SetRegion, region.pid, region.nid, region.name]]) {
//                }
//            }
//        }
//        @catch(NSException *exception)
//        {
//            isRollBack = YES;
//            [_defaultDataBase rollback];
//        }
//        @finally
//        {
//            if (!isRollBack) {
//                //提交事务
//                [_defaultDataBase commit];
//                [_defaultDataBase close];
//            }
//        }
//    }
//}
//
//#pragma mark -地址省市区
//- (NSMutableArray<RegionModel *> *)getAddressRegionListBy:(NSString *)sql
//{
//    NSMutableArray *tempList = [NSMutableArray arrayWithCapacity:0];
//    if ([_defaultDataBase open]) {
//        FMResultSet *result=[_defaultDataBase executeQuery:sql];
//        while (result.next) {
//            RegionModel *region = [[RegionModel alloc] init];
//            region.pid = [result longForColumn:@"pid"];
//            region.nid = [result longForColumn:@"nid"];
//            region.name = [result stringForColumn:@"name"];
//            [tempList addObject:region];
//        }
//        [_defaultDataBase close];
//    }
//    return tempList;
//}
//
//- (NSMutableArray<RegionModel *> *)getProvinceAddressRegionList
//{
//    return [self getRegionListBy:GetAddressRegionProvince];
//}
//
//- (NSMutableArray<RegionModel *> *)getCityAddressRegionList
//{
//    return [self getRegionListBy:GetAddressRegionCity];
//}
//
//- (NSMutableArray<RegionModel *> *)getAreaAddressRegionList
//{
//    return [self getRegionListBy:GetAddressRegionArea];
//}
//
//- (void)setAddressRegionList:(NSArray<RegionModel *> *)regionList
//{
//    if (regionList == nil || regionList.count == 0) {
//        NSLog(@"传入数据空");
//        return;
//    }
//    if ([_defaultDataBase open]) {
//        //删除之前的数据
//        [_defaultDataBase executeUpdate:DeleteAddressRegionList];
//        //自增为0开始
//        [_defaultDataBase executeUpdate:UpdateAddressRegion];
//        //开启事务
//        [_defaultDataBase beginTransaction];
//        BOOL isRollBack = NO;
//        @try{
//            for (RegionModel *region in regionList) {
//                if (![_defaultDataBase executeUpdate:[NSString stringWithFormat:SetAddressRegion, region.pid, region.nid, region.name]]) {
//                }
//            }
//        }
//        @catch(NSException *exception)
//        {
//            isRollBack = YES;
//            [_defaultDataBase rollback];
//        }
//        @finally
//        {
//            if (!isRollBack) {
//                //提交事务
//                [_defaultDataBase commit];
//                [_defaultDataBase close];
//            }
//        }
//    }
//}
//
//#pragma mark -搜索历史记录
//
//- (void)setSearchHistoryKeyWord:(NSString *)keyword type:(NSInteger)type
//{
//    if (keyword) {
//        if([_defaultDataBase open])
//        {
//            if (![_defaultDataBase executeUpdate:[NSString stringWithFormat:SetSearchHistory,keyword, @(type)]]) {
//            }
//            [_defaultDataBase close];
//        }
//    }
//}
//
//- (NSMutableArray<SearchHistoryModel *> *)getSearchHistoryType:(NSInteger)type
//{
//    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:0];
//    if ([_defaultDataBase open]) {
//        FMResultSet *result=[_defaultDataBase executeQuery:[NSString stringWithFormat:GetSearchHistory,@(type)]];
//        while (result.next) {
//            SearchHistoryModel *item = [[SearchHistoryModel alloc] init];
//            item.keyword = [result stringForColumn:@"KEYWORD"];
//            [temp addObject:item];
//        }
//        [_defaultDataBase close];
//    }
//    return temp;
//}
//
//- (void)deleteSearchHistoryType:(NSInteger)type
//{
//    if ([_defaultDataBase open]) {
//        //删除内容
//        [_defaultDataBase executeUpdate:[NSString stringWithFormat:DeleteSearchHistory,@(type)]];
//
//        [_defaultDataBase close];
//    }
//}
//
//#pragma mark -股权搜索记录
//- (void)setEquitySearchHistoryKeyWord:(NSString *)keyword
//{
//    [self setSearchHistoryKeyWord:keyword type:0];
//}
//
//- (NSMutableArray<SearchHistoryModel *> *)getEquitySearchHistory
//{
//    return [self getSearchHistoryType:0];
//}
//
//- (void)deleteEquitySearchHistory
//{
//    [self deleteSearchHistoryType:0];
//}
//
//#pragma mark -产品搜索记录
//- (void)setProductSearchHistoryKeyWord:(NSString *)keyword
//{
//    [self setSearchHistoryKeyWord:keyword type:1];
//}
//
//- (NSMutableArray<SearchHistoryModel *> *)getProductSearchHistory
//{
//    return [self getSearchHistoryType:1];
//}
//
//- (void)deleteProductSearchHistory
//{
//    [self deleteSearchHistoryType:1];
//}
//
//#pragma mark -筛选条件表
//
//- (void)setSearchCondition:(NSArray<KVP *> *)conditionlist
//{
//    if (conditionlist == nil) {
//        NSLog(@"传入数据空");
//        return;
//    }
//    if ([_defaultDataBase open]) {
//        //删除之前的数据
//        [_defaultDataBase executeUpdate:DeleteSearchCondition];
//        //自增为0开始
//        [_defaultDataBase executeUpdate:UpdateSearchCondition];
//        //开启事务
//        [_defaultDataBase beginTransaction];
//        BOOL isRollBack = NO;
//        @try{
//            for (int i = 0; i< conditionlist.count; i++) {
//                KVP *temp = (KVP *)conditionlist[i];
//                if (![_defaultDataBase executeUpdate:[NSString stringWithFormat:SetSearchCondition,temp.key, temp.value, @(temp.type)]]) {
//                }
//            }
//        }
//        @catch(NSException *exception)
//        {
//            isRollBack = YES;
//            [_defaultDataBase rollback];
//        }
//        @finally
//        {
//            if (!isRollBack) {
//                //提交事务
//                [_defaultDataBase commit];
//                [_defaultDataBase close];
//            }
//        }
//    }
//}
//
//- (void)getSearchCondition
//{
//    NSMutableArray *one = [NSMutableArray arrayWithCapacity:0];
//    NSMutableArray *two = [NSMutableArray arrayWithCapacity:0];
//    NSMutableArray *three = [NSMutableArray arrayWithCapacity:0];
//    if ([_defaultDataBase open]) {
//        FMResultSet *result=[_defaultDataBase executeQuery:[NSString stringWithFormat:GetSearchCondition]];
//        while (result.next) {
//            KVP *item = [[KVP alloc] init];
//            NSInteger type = [result intForColumn:@"TYPE"];
//            if (type == 1) {
//                item.key = [result stringForColumn:@"KEY"];
//                item.value = [result stringForColumn:@"VALUE"];
//                [one addObject:item];
//            }
//            else if (type == 2)
//            {
//                item.key = [result stringForColumn:@"KEY"];
//                item.value = [result stringForColumn:@"VALUE"];
//                [two addObject:item];
//            }
//            else if (type == 3)
//            {
//                item.key = [result stringForColumn:@"KEY"];
//                item.value = [result stringForColumn:@"VALUE"];
//                [three addObject:item];
//            }
//        }
//        [CondictionSearch sharedInstance].industry = [one copy];
//        [CondictionSearch sharedInstance].status = [two copy];
//        [CondictionSearch sharedInstance].orderby = [three copy];
//        
//        [_defaultDataBase close];
//    }
//
//}


@end
