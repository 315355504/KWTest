//
//  ViewController.m
//  KWTest
//
//  Created by Kwin on 2017/9/28.
//  Copyright © 2017年 Kwin. All rights reserved.
//
#define TestURL @"http://api.xianjiavip.com/api/user/isPhoneExists.htm"
#define KW_Loan_ShareUrl @"http://api.xianjiavip.com/api/userInvite/findInvite.htm"
#import "ViewController.h"
#import "KWAppError.h"
#import "CDStatusBarViewController.h"

#import "KWShareView.h"
#import "KWShareManage.h"
#import "QRCodeView.h"
#import "ShareInfoModel.h"
#import "KWAppErrorHandlerYYModel.h"
#import <MJExtension/MJExtension.h>
@interface ViewController ()<KWShareViewDelegate>
{
    NSDictionary * dic;
    ShareInfoModel *_shareInfoModel;
    NSDictionary *_shareContent;
    NSArray *_shareArray;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dic = @{@"phone" : @"13263266885",};
    _shareArray = @[@{@"title":@"微信好友",@"icon":@"wechat"},
                    @{@"title":@"微信朋友圈",@"icon":@"wechatf"},
                    @{@"title":@"QQ好友",@"icon":@"qq"},
                    @{@"title":@"QQ空间",@"icon":@"qqzone"},
                    @{@"title":@"二维码",@"icon":@"QR"}];
 
    [self requestShareUre];
    
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
    if (_shareInfoModel == nil) {
        return;
    }
        NSMutableArray *shareViewArray = [NSMutableArray array];
    for (NSDictionary *dic in _shareArray) {
        ShareViewItem *item = [[ShareViewItem alloc] init];
        item.title = [dic objectForKey:@"title"];
        item.image = [UIImage imageNamed:[dic objectForKey:@"icon"]];
        [shareViewArray addObject:item];
    }
    
    KWShareView *shareView = [[KWShareView alloc] init];
    shareView.KWShareViewDelegate = self;
    [shareView showKWShareViewWith:shareViewArray];
}
-(void)shareViewDidSelectItemWith:(NSIndexPath *)indexPath withTitle:(NSString *)title
{
    NSLog(@"title-->%@indexPath-->%@",title,indexPath);

    _shareContent = @{@"shareBtnTitle":@"分享",
                      @"share_title":_shareInfoModel.title,
                      @"share_body":_shareInfoModel.remark,
                      @"share_logo":_shareInfoModel.inviteLogo,
                      @"share_url":_shareInfoModel.url};

    if ([title isEqualToString:@"微信好友"]) {
        
        [[KWShareManage sharedInstance] shareButtonActionWithSharetype:wx withContentDic:_shareContent];
    }else if ([title isEqualToString:@"微信朋友圈"]){
        
        [[KWShareManage sharedInstance] shareButtonActionWithSharetype:wechatf withContentDic:_shareContent];
    }else if ([title isEqualToString:@"QQ好友"]){
        
        [[KWShareManage sharedInstance] shareButtonActionWithSharetype:qq withContentDic:_shareContent];
    }else if ([title isEqualToString:@"QQ空间"]){
        
        [[KWShareManage sharedInstance] shareButtonActionWithSharetype:qqzone withContentDic:_shareContent];
    }else if ([title isEqualToString:@"二维码"]){
        
        QRCodeView *view = [[QRCodeView alloc]init];
        [view showQRCodeViewWithUrl:_shareInfoModel.url];
    }
}
-(void)requestShareUre
{
    //JSON文件的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ShareInfoModel" ofType:@"json"];
    //加载JSON文件
    NSData *data = [NSData dataWithContentsOfFile:path];
    //将JSON数据转为NSArray或NSDictionary
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"json-> %@",dict);
    _shareInfoModel = [ShareInfoModel mj_objectWithKeyValues:dict];
    
    /*
    [KWAppError requestHTTPMethod:KWAppServiceMethodPOST URL:KW_Loan_ShareUrl parameters:@{} modelClass:[ShareInfoModel class] errorDelegate:[KWAppErrorHandlerYYModel sharedManager] success:^(NSURLSessionDataTask *task, KWAppError *error, id model) {
        if (error.errorCode == KWP2PAppErrorTypeYYSuccess) {
            _shareInfoModel = model;
        }
    } fail:^(NSURLSessionDataTask *task, KWAppError *error) {
        
    }];
    */
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
