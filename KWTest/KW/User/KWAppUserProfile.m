//
//  KWAppUserProfile.m
//  KWP2PApp
//
//  Created by Yosef Lin on 10/21/15.
//  Copyright © 2015 Yosef Lin. All rights reserved.
//

#import "KWAppUserProfile.h"
#import "DataBaseManager.h"
@interface KWAppUserProfile()


@end

@implementation KWAppUserProfile

static  KWAppUserProfile *sharedInstance = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[KWAppUserProfile alloc] init];
        [sharedInstance load];
    });
    return sharedInstance;
}

-(BOOL)cleanUp
{
    BOOL reslut = [[DataBaseManager sharedInstance] userLogOut:self];
    _oauthToken = @"";
    _refreshToken = @"";
    _userId = @"";
    _expiresIn = @"";
    _userName = @"";
    _hideUserName = @"";
    _avatarPath = @"";
    return reslut;
}
-(NSString *)hideUserName{
    NSString *tmpUserName;
    if (_userName.length == 11) {
        tmpUserName = [_userName stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        return tmpUserName;
    }
    else{
        return _userName;
    }
}

- (BOOL)save
{
    return  [[DataBaseManager sharedInstance] savetUserInfo:self];
}

- (void)load
{
   [[DataBaseManager sharedInstance] loadUser:self];
}

//-(void)updateTokenExpiredTime:(NSTimeInterval)life
//{
//    _tokenExpiredTime = [NSDate dateWithTimeIntervalSinceNow:life];
//}

-(BOOL)isLogon
{
    return _oauthToken.length > 0;
}


- (BOOL)checkGesture:(NSString *)pwd
{
    return [[DataBaseManager sharedInstance] checkUserInfo:self gesturePWD:pwd];
}

- (BOOL)isOpenTouchID
{
    return [[DataBaseManager sharedInstance] userIsOpenTouchID:self];
}

- (void)setOpenTouchID:(BOOL)open
{
    [[DataBaseManager sharedInstance] updateUserInfo:self openTouchID:open];
}
- (void)saveGesture:(NSString *)gesturePwd
{
    return [[DataBaseManager sharedInstance] updateUserInfo:self gesturePWD:gesturePwd];
}

- (BOOL)hasSetGesture
{
    return [[DataBaseManager sharedInstance] getGesturePWD:self].length > 0;
}

-(void)saveTemUserName:(NSString *)name
{

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [user setObject:name forKey:@"temUserName"];
    
    [user synchronize];
}

-(BOOL)checkTemUser
{
    BOOL check;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSString *name = [ user objectForKey:@"temUserName"];
    
    if (name.length > 0) {
        check = YES;
    }
    else
        check = NO;
    
    return check;
}

-(NSString *)getTemUserName
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSString *name = [ user objectForKey:@"temUserName"];
    
    return name;
}

-(void)cleanUpTemUserName
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [user setObject:@"" forKey:@"temUserName"];
    
    [user synchronize];
}
-(void)updateTokenExpiredTime:(NSTimeInterval)life{
    
}
@end
