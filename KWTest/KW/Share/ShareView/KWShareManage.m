//
//  KWShareManage.m
//  CashLoan
//
//  Created by 李帅良 on 2017/2/20.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import "KWShareManage.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "XJDAlertView.h"

@interface KWShareManage ()

@end

@implementation KWShareManage

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static KWShareManage *shareManager = nil;
    dispatch_once(&once, ^{
        shareManager = [[KWShareManage alloc]init];
    });
    return shareManager;
}

-(void)shareButtonActionWithSharetype:(ShareType)shareType withContentDic:(NSDictionary *)dic
{
    if (shareType == wx) {
        [self wxShare:dic];
    }else if (shareType == wechatf){
        [self wxZoneShare:dic];
    }else if (shareType == qq){
        [self qqShare:dic];
    }else if (shareType == qqzone){
        [self qqZoneShare:dic];
    }
}
#pragma mark - 微信分享
-(void)wxShare:(NSDictionary *)dic
{
    if ([self isWXAppInstalled])
    {
        if (dic) {
            WXMediaMessage *message = [[WXMediaMessage alloc]init];
            message.title = [dic objectForKey:@"share_title"];
            message.description = [dic objectForKey:@"share_body"];
            NSData *_shareImg = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"share_logo"]]];
            UIImage *temImg = [UIImage imageWithData:_shareImg];
            [message setThumbImage:temImg];
            
            WXWebpageObject *ext = [WXWebpageObject object];
            ext.webpageUrl = [dic objectForKey:@"share_url"];
            
            message.mediaObject = ext;
            message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
            
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            req.message =  message;
            req.bText = NO;
            req.scene = 0;
            
            [WXApi sendReq:req];
        }
    }else{
        XJDAlertView *alertView = [[XJDAlertView alloc] initWithTitle:@"" contentText:@"未安装微信客户端 !" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alertView show];
    }
}
#pragma mark - 微信盆友圈分享
-(void)wxZoneShare:(NSDictionary *)dic
{
    if ([self isWXAppInstalled])
    {
        if (dic) {
            WXMediaMessage *message = [[WXMediaMessage alloc]init];
            message.title = [NSString stringWithFormat:@"【%@】 %@",[dic objectForKey:@"share_title"],[dic objectForKey:@"share_body"]];
            message.description = [dic objectForKey:@"share_body"];
            NSData *_shareImg = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"share_logo"]]];
            UIImage *temImg = [UIImage imageWithData:_shareImg];
            [message setThumbImage:temImg];

            WXWebpageObject *ext = [WXWebpageObject object];
            ext.webpageUrl = [dic objectForKey:@"share_url"];
            
            message.mediaObject = ext;
            message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
            
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            req.message =  message;
            req.bText = NO;
            req.scene = 1;
            
            [WXApi sendReq:req];
        }
    }else{
        XJDAlertView *alertView = [[XJDAlertView alloc] initWithTitle:@"" contentText:@"未安装微信客户端 !" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alertView show];
    }
}
#pragma mark - QQ分享
-(void)qqShare:(NSDictionary *)dic
{
    if ([self isQQInstalled])
    {
        if (dic) {
            NSData *_shareImg = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"share_logo"]]];
            UIImage *temImg = [UIImage imageWithData:_shareImg];
            if (temImg == nil) {
                temImg = [UIImage imageNamed:@"share_logo.jpg"];
            }
            
            NSData *data = [[NSData alloc]initWithData:UIImageJPEGRepresentation(temImg, 1)];
            QQApiNewsObject *new = [QQApiNewsObject objectWithURL:[NSURL URLWithString:[dic objectForKey:@"share_url"]] title:[dic objectForKey:@"share_title"] description:[dic objectForKey:@"share_body"] previewImageData:data];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:new];
                QQApiSendResultCode sent = [QQApiInterface sendReq:req];
                NSLog(@"qqResult:>>>>>>>%d",sent);
        }
    }else{
        XJDAlertView *alertView = [[XJDAlertView alloc] initWithTitle:@"" contentText:@"未安装QQ客户端 !" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alertView show];
    }
}
#pragma mark - QQ空间分享
-(void)qqZoneShare:(NSDictionary *)dic
{
    if ([self isQQInstalled])
    {
        if (dic) {
            NSData *_shareImg = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"share_logo"]]];
            UIImage *temImg = [UIImage imageWithData:_shareImg];
            if (temImg == nil) {
                temImg = [UIImage imageNamed:@"share_logo.jpg"];
            }
            NSData *data = [[NSData alloc]initWithData:UIImageJPEGRepresentation(temImg, 1)];
            
            QQApiNewsObject *new = [QQApiNewsObject objectWithURL:[NSURL URLWithString:[dic objectForKey:@"share_url"]] title:[dic objectForKey:@"share_title"] description:[dic objectForKey:@"share_body"] previewImageData:data];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:new];
            QQApiSendResultCode sent =  [QQApiInterface SendReqToQZone:req];
            NSLog(@"qqResult:>>>>>>>%d",sent);
        }
    }else{
        XJDAlertView *alertView = [[XJDAlertView alloc] initWithTitle:@"" contentText:@"未安装QQ客户端 !" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alertView show];
    }
}
//是否安装微信
-(BOOL)isWXAppInstalled
{
    return [WXApi isWXAppInstalled];
}
//判断qq是否安装
-(BOOL)isQQInstalled
{
    return [QQApiInterface isQQInstalled];
}
@end
