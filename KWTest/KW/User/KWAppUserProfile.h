//
//  KWAppUserProfile.h
//  KWP2PApp
//
//  Created by Yosef Lin on 10/21/15.
//  Copyright © 2015 Yosef Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWAppUserProfile : NSObject

/********************************登录信息********************/
/**
 *  用户id
 */
//@property(nonatomic, copy)NSString *bindingId;

/**
 *  用户名
 */
@property(nonatomic, copy)NSString *userName;
/**
 *  脱敏后的用户名
 */
@property(nonatomic, copy)NSString *hideUserName;
/**
 *  登录认证信息
 */
@property(nonatomic, copy)NSString *oauthToken;
/**
 *  刷新token
 */
@property(nonatomic, copy)NSString *refreshToken;
/**
 *  生命周期
 */
@property(nonatomic, copy)NSString *expiresIn;
/**
 *  用户id
 */
@property(nonatomic, copy)NSString *userId;

/**
 *  头像地址
 */
@property (nonatomic, copy) NSString *avatarPath;

/********************************登录信息********************/

/**
 *  是否登录
 */
@property(nonatomic, readonly)BOOL isLogon;

@property(nonatomic, assign)BOOL isBorrow;


+ (instancetype)sharedInstance;


/**
 退出登录

 @return 成功YES 失败NO
 */
-(BOOL)cleanUp;

-(void)updateTokenExpiredTime:(NSTimeInterval)life;

//-(void)updateInfo:(LoginResultModel *)model;
/**
 *  加载基本信息模型更新
 *
 *  @param userBasicInfo 基本信息模型
 */
//- (void)updateInfoWith:(UserBasicInfo *)userBasicInfo;

- (BOOL)save;

- (BOOL)checkGesture:(NSString *)pwd;

- (BOOL)isOpenTouchID;

- (void)setOpenTouchID:(BOOL)open;

- (void)saveGesture:(NSString *)gesturePwd;

- (BOOL)hasSetGesture;

//临时存储
-(void)saveTemUserName:(NSString *)name;

-(BOOL)checkTemUser;

-(NSString *)getTemUserName;

-(void)cleanUpTemUserName;
@end
