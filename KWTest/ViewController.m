//
//  ViewController.m
//  KWTest
//
//  Created by Kwin on 2017/9/28.
//  Copyright © 2017年 Kwin. All rights reserved.
//
#define TestURL @"http://api.xianjiavip.com/api/user/isPhoneExists.htm"
#import "ViewController.h"
#import "KWAppError.h"
#import "CDStatusBarViewController.h"

#import "KWShareView.h"
#import "KWShareManage.h"
#import "QRCodeView.h"
@interface ViewController ()<KWShareViewDelegate>
{
    NSDictionary * dic;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dic = @{@"phone" : @"13263266885",};

 
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
static void extracted(ViewController *object) {
    [KWAppError requestHTTPMethod:KWAppServiceMethodPOST URL:TestURL parameters:object->dic modelClass:nil errorDelegate:nil success:^(NSURLSessionDataTask *task, KWAppError *error, id model) {
        NSLog(@"%@",model);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:model options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dict);
    } fail:^(NSURLSessionDataTask *task, KWAppError *error) {
        NSLog(@"%@",error.error);
    }];
}

- (void)extracted {
    extracted(self);
}

- (IBAction)touch:(UIButton *)sender {
    
    [self shareWayViewDoShare];
  
   
    
}
-(void)shareWayViewDoShare
{
//    if (_shareInfoModel == nil) {
//        return;
//    }
        NSMutableArray *shareViewArray = [NSMutableArray array];
//    for (NSDictionary *dic in _shareArray) {
        ShareViewItem *item = [[ShareViewItem alloc] init];
        item.title = @"微信好友";
        item.image = [UIImage imageNamed:@"WechatIMG6.jpeg"];
        [shareViewArray addObject:item];
//    }
    
    KWShareView *shareView = [[KWShareView alloc] init];
    shareView.KWShareViewDelegate = self;
    [shareView showKWShareViewWith:shareViewArray];
}
-(void)shareViewDidSelectItemWith:(NSIndexPath *)indexPath withTitle:(NSString *)title
{
    NSLog(@"111111111-->%@%@",title,indexPath);

    /*
    _shareContent = @{@"shareBtnTitle":@"分享",
                      @"share_title":_shareInfoModel.title,
                      @"share_body":_shareInfoModel.remark,
                      @"share_logo":_shareInfoModel.inviteLogo,
                      @"share_url":[[KWAppServiceConfig sharedInstance] baseURLWithPath:_shareInfoModel.url]};
    */
    
    NSDictionary * shareContent = [NSDictionary dictionary];
    
    if ([title isEqualToString:@"微信好友"]) {
        
        [[KWShareManage sharedInstance] shareButtonActionWithSharetype:wx withContentDic:shareContent];
    }else if ([title isEqualToString:@"微信朋友圈"]){
        
        [[KWShareManage sharedInstance] shareButtonActionWithSharetype:wechatf withContentDic:shareContent];
    }else if ([title isEqualToString:@"QQ好友"]){
        
        [[KWShareManage sharedInstance] shareButtonActionWithSharetype:qq withContentDic:shareContent];
    }else if ([title isEqualToString:@"QQ空间"]){
        
        [[KWShareManage sharedInstance] shareButtonActionWithSharetype:qqzone withContentDic:shareContent];
    }else if ([title isEqualToString:@"二维码"]){
        
        QRCodeView *view = [[QRCodeView alloc]init];
        [view showQRCodeViewWithUrl:[[KWAppServiceConfig sharedInstance] baseURLWithPath:@"_shareInfoModel.url"]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
