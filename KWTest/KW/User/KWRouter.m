//
//  KWRouter.m
//  router
//
//  Created by Liang Shen on 2016/10/21.
//  Copyright © 2016年 com.erongdu.friday. All rights reserved.
//
// 此类用户 各个模块的路由注册，命名规范约定为如下
//  "/module/action/"
// 如果被调用的模块有入参的需要，则规范如下
//  "/module/action/:value"

#import "KWRouter.h"

@implementation KWRouter
+ (KWRouter *)shareManager{
    static KWRouter *router=nil;
    static dispatch_once_t oncet;
    dispatch_once(&oncet, ^{
        router=[[self alloc]init];
    });
    return router;
}

-(void)createRouterForAllControllers{
    
    [self homeRouteRegist];
    
    [self accountRouteRegist];
    
    [self TppPayMediator];
    
    [self loginWithRegist];
    
    [self repaymentRouteRegist];
}

-(void)loginWithRegist
{
    [[HHRouter shared] map:LOAN_User_LoginRegist toControllerClass:NSClassFromString(@"LoginRegistViewController")];
    [[HHRouter shared] map:LOAN_User_Login(@":phone") toControllerClass:NSClassFromString(@"LoginViewController")];
    [[HHRouter shared] map:LOAN_User_Regist(@":phone") toControllerClass:NSClassFromString(@"RegisterViewController")];
    [[HHRouter shared] map:LOAN_User_Forget(@":phone") toControllerClass:NSClassFromString(@"ForgetViewController")];
    [[HHRouter shared] map:LOAN_User_ResetPwd(@":phone",@":code") toControllerClass:NSClassFromString(@"ResetPwdViewController")];
    
     [[HHRouter shared] map:LOAN_User_FindTardePwd toControllerClass:NSClassFromString(@"FindTardePwdViewController")];
}

-(void)homeRouteRegist
{
    [[HHRouter shared] map:LOAN_Home_HomePage toControllerClass:NSClassFromString(@"LoanHomePageViewController")];
    
    [[HHRouter shared] map:LOAN_Home_LoanApply toControllerClass:NSClassFromString(@"LoanApplyViewController")];
    
    [[HHRouter shared] map:LOAN_Home_HomePageStyleTwo toControllerClass:NSClassFromString(@"LoanHomePageStyleViewController")];
    
    [[HHRouter shared] map:LOAN_Home_HomePageStyleFour toControllerClass:NSClassFromString(@"LoanHomeFourthStyleViewController")];
    
    [[HHRouter shared] map:LOAN_Home_Web toControllerClass:NSClassFromString(@"HomeWebViewController")];
}

-(void)accountRouteRegist
{
    [[HHRouter shared] map:LOAN_Mine_MineCenter toControllerClass:NSClassFromString(@"MineCenterViewController")];
    [[HHRouter shared] map:LOAN_Mine_LoanLog_List toControllerClass:NSClassFromString(@"LoanLogListViewController")];
    [[HHRouter shared] map:LOAN_Mine_Auth_Center toControllerClass:NSClassFromString(@"AuthenticationCenterViewController")];
    [[HHRouter shared] map:Loan_Mine_Auth_SecondStyleCenter toControllerClass:NSClassFromString(@"AuthenticationCenterStyleViewController")];
    [[HHRouter shared] map:Loan_Mine_Auth_ThirdStyleCenter(@":state") toControllerClass:NSClassFromString(@"AuthenticationCenterThirdStyleViewController")];
    [[HHRouter shared] map:LOAN_Mine_Setting toControllerClass:NSClassFromString(@"MineSettingViewController")];
    [[HHRouter shared] map:LOAN_Mine_Setting_ModifyPwd toControllerClass:NSClassFromString(@"ModifyPasswordViewController")];
    [[HHRouter shared] map:LOAN_Mine_Setting_PayPwd(@":pwd", @":type",@":lastVC") toControllerClass:NSClassFromString(@"PayPwdViewController")];
    [[HHRouter shared] map:LOAN_Mine_Setting_ModifyPayPwd(@":oldPwd",@":pwd", @":type") toControllerClass:NSClassFromString(@"ModifyPayPwdViewController")];
    [[HHRouter shared] map:LOAN_Mine_AboutUs toControllerClass:NSClassFromString(@"AboutUsWebViewController")];

    [[HHRouter shared] map:LOAN_Mine_share(@":profitRate") toControllerClass:NSClassFromString(@"ShareViewController")];
    [[HHRouter shared] map:LOAN_Mine_Setting_Feedback toControllerClass:NSClassFromString(@"FeedBackViewController")];
    [[HHRouter shared] map:LOAN_Mine_Auth_State(@":type",@":state") toControllerClass:NSClassFromString(@"AuthStateViewController")];
    [[HHRouter shared] map:LOAN_Mine_Auth_Mobile(@":type") toControllerClass:NSClassFromString(@"MobileOperatorViewController")];
    [[HHRouter shared] map:LOAN_Mine_Auth_Personal(@":state") toControllerClass:NSClassFromString(@"PersonalAuthViewController")];
    [[HHRouter shared] map:LOAN_Mine_Auth_Personal_V2(@":state") toControllerClass:NSClassFromString(@"PersonalAuthViewController_V2")];
    
    [[HHRouter shared] map:LOAN_Mine_Auth_Personal_V3(@":state") toControllerClass:NSClassFromString(@"PersonalAuthViewController_V3")];

    [[HHRouter shared] map:LOAN_Mine_Auth_Job toControllerClass:NSClassFromString(@"JobAuthViewController")];
    [[HHRouter shared] map:LOAN_Mine_Auth_JobPhoto toControllerClass:NSClassFromString(@"JobPhotoAuthViewController")];
    [[HHRouter shared] map:LOAN_Mine_Auth_MoreInfo toControllerClass:NSClassFromString(@"MoreInformationViewController")];
    
    [[HHRouter shared] map:Loan_Mine_MessageList toControllerClass:NSClassFromString(@"MessageListViewController")];
    
    [[HHRouter shared] map:LOAN_Mine_Auth_Contacts toControllerClass:NSClassFromString(@"ContactsAuthViewController")];
    [[HHRouter shared] map:LOAN_Mine_Auth_BankCard toControllerClass:NSClassFromString(@"BankCardViewController")];
    [[HHRouter shared] map:LOAN_Mine_Auth_BankCardBind(@":type") toControllerClass:NSClassFromString(@"BindBankCardViewController")];
    
    [[HHRouter shared] map:LOAN_Mine_shareWay(@":shareUrl") toControllerClass:NSClassFromString(@"ShareWayViewController")];
    [[HHRouter shared] map:LOAN_Mine_shareRecord toControllerClass:NSClassFromString(@"ShareRecordViewController")];
    [[HHRouter shared] map:LOAN_Mine_shareRecordDetail(@":id") toControllerClass:NSClassFromString(@"ShareRecordDetailViewController")];
    [[HHRouter shared] map:LOAN_Mine_shareDetail toControllerClass:NSClassFromString(@"ShareDetailViewController")];
    [[HHRouter shared] map:LOAN_Mine_shareCash(@":phone") toControllerClass:NSClassFromString(@"ShareCashViewController")];
    [[HHRouter shared] map:LOAN_Mine_cashRecord toControllerClass:NSClassFromString(@"CashRecordViewController")];

    [[HHRouter shared] map:LOAN_Account_PortraitAuth toControllerClass:NSClassFromString(@"PortraitAuthViewController")];
    [[HHRouter shared] map:LOAN_Account_PortraitData toControllerClass:NSClassFromString(@"PortraitDataViewController")];
    [[HHRouter shared] map:LOAN_Account_PortraitResult(@":name", @":idCard", @":sex", @":address", @":nation",@":isAuthed") toControllerClass:NSClassFromString(@"PortraitResultViewController")];
    [[HHRouter shared] map:LOAN_Account_MyConsumption toControllerClass:NSClassFromString(@"MyConsumptionSegementViewController")];
    [[HHRouter shared] map:LOAN_Account_MyConsumptionDetail(@":title",@":orderNo") toControllerClass:NSClassFromString(@"MyConsumptionDetailViewController")];
    [[HHRouter shared] map:LOAN_Account_AccountSetting toControllerClass:NSClassFromString(@"AccountSettingViewController")];
    [[HHRouter shared] map:LOAN_Account_EditLoginPwd toControllerClass:NSClassFromString(@"EditLoginPasswoKWViewController")];
    [[HHRouter shared] map:LOAN_Account_ZMCreditResult toControllerClass:NSClassFromString(@"ZMCreditResultViewController")];
    [[HHRouter shared] map:LOAN_Account_MyBorrow(@":index") toControllerClass:NSClassFromString(@"MyBorrowViewController")];
    [[HHRouter shared] map:LOAN_Account_MyBorrow_ApplyList toControllerClass:NSClassFromString(@"MyBorrowApplyListViewController")];
    [[HHRouter shared] map:LOAN_Account_MyBorrow_RepayList toControllerClass:NSClassFromString(@"MyBorrowRepayListViewController")];
    [[HHRouter shared] map:LOAN_Account_MyBorrow_SettleList toControllerClass:NSClassFromString(@"MyBorrowSettleListViewController")];
}
-(void)TppPayMediator{
    [[HHRouter shared] map:@"" toControllerClass:NSClassFromString(@"")];
}
-(void)repaymentRouteRegist
{
    [[HHRouter shared] map:LOAN_Repay_Repayment toControllerClass:NSClassFromString(@"RepaymentViewController")];
    [[HHRouter shared] map:LOAN_Repay_RepaymentDetail(@":id") toControllerClass:NSClassFromString(@"RepaymentDetailViewController")];
    [[HHRouter shared] map:LOAN_Repay_RepaymentPayType(@":id") toControllerClass:NSClassFromString(@"RepaymentPayTypeViewController")];
    [[HHRouter shared] map:LOAN_Repay_ContinueBorrow(@":id",@":isPenalty") toControllerClass:NSClassFromString(@"ContinueBorrowViewController")];
    [[HHRouter shared] map:LOAN_Repay_RenewRecord(@":id") toControllerClass:NSClassFromString(@"RenewRecordViewController")];
    [[HHRouter shared] map:LOAN_Repay_RepaymentTypeContent(@":id",@":type") toControllerClass:NSClassFromString(@"RepaymentTypeContentViewController")];
}
@end
