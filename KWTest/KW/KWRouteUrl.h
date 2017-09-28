//
//  KWRouteUrl.h
//  HuiBang
//
//  Created by Mr_zhaohy on 2017/1/10.
//  Copyright © 2017年 Mr_zhaohy. All rights reserved.
//

#ifndef KWRouteUrl_h
#define KWRouteUrl_h
/********** Home ***********/
//首页
#define LOAN_Home_HomePage   @"loan://home/homePage"

#define LOAN_Home_HomePageStyleTwo @"loan://home/homePageStyleTwo"

#define LOAN_Home_HomePageStyleFour @"loan://home/homePageStyleFour"

#define LOAN_Home_Web @"loan://home/webHome"

/********** Account ***********/
//我的
#define LOAN_Mine_MineCenter   @"loan://mine/mineCenter/"
//消息中心
#define Loan_Mine_MessageList   @"loan://mine/messageList/"
//借款记录
#define LOAN_Mine_LoanLog_List   @"loan://mine/loanLog/list/"
//认证中心  列表
#define LOAN_Mine_Auth_Center   @"loan://mine/auth/authCenter/"
//认证中心  九宫格
#define Loan_Mine_Auth_SecondStyleCenter @"loan://mine/auth/authCenterStyleTwo/"
//认证中心  可展开
#define Loan_Mine_Auth_ThirdStyleCenter(state) [NSString stringWithFormat:@"loan://mine/auth/authCenterStyleThree/%@",state]

//个人认证 商汤
#define LOAN_Mine_Auth_Personal(state) [NSString stringWithFormat:@"loan://mine/auth/personal/%@",state]
//个人认证 face++
#define LOAN_Mine_Auth_Personal_V2(state) [NSString stringWithFormat:@"loan://mine/auth/personal/v2/%@",state]
//个人认证 小视
#define LOAN_Mine_Auth_Personal_V3(state) [NSString stringWithFormat:@"loan://mine/auth/personal/v3/%@",state]
//工作认证
#define LOAN_Mine_Auth_Job   @"loan://mine/auth/job/"
//工作照片
#define LOAN_Mine_Auth_JobPhoto   @"loan://mine/auth/jobPhoto/"
//我的更多
#define LOAN_Mine_Auth_MoreInfo   @"loan://mine/auth/MoreInfo/"

//联系人
#define LOAN_Mine_Auth_Contacts   @"loan://mine/auth/contacts/"
//已绑银行卡
#define LOAN_Mine_Auth_BankCard   @"loan://mine/auth/bankCard/"
//设置
#define LOAN_Mine_Setting   @"loan://mine/setting/"
//设置交易密码
#define LOAN_Mine_Setting_PayPwd(pwd,type,lastVC)   [NSString stringWithFormat:@"loan://mine/setting/payPwd/%@/%@/%@",pwd,type,lastVC]
//修改交易密码
#define LOAN_Mine_Setting_ModifyPayPwd(oldPwd,pwd,type)   [NSString stringWithFormat:@"loan://mine/setting/ModifypayPwd/%@/%@/%@",oldPwd,pwd,type]

//修改密码
#define LOAN_Mine_Setting_ModifyPwd   @"loan://mine/setting/modifyPwd/"
//手机运营商认证 type 0:用密码认证，1:用验证码验证
#define LOAN_Mine_Auth_Mobile(type)  [NSString stringWithFormat:@"loan://mine/auth/mobile/%@",type]
//认证状态 type:0 芝麻信用 1：手机运营商
#define LOAN_Mine_Auth_State(type,state)  [NSString stringWithFormat:@"loan://mine/auth/authState/%@/%@",type,state]
//添加银行卡
#define LOAN_Mine_Auth_BankCardBind(type)  [NSString stringWithFormat:@"loan://mine/auth/bankCard/bind/%@",type]

//分享
//我的邀请码
#define LOAN_Mine_share(profitRate)   [NSString stringWithFormat:@"loan://mine/share/%@",profitRate]
//反馈
#define LOAN_Mine_Setting_Feedback   @"loan://mine/setting/feedback/"
//我的邀请码-邀请好友
#define LOAN_Mine_shareWay(shareUrl)   [NSString stringWithFormat:@"loan://mine/shareWay/%@",shareUrl]
//我的邀请码-邀请记录
#define LOAN_Mine_shareRecord        @"loan://mine/shareRecord/"
//我的邀请码-邀请好友详情
#define LOAN_Mine_shareRecordDetail(id)   [NSString stringWithFormat:@"loan://mine/shareRecordDetail/%@",id]
//我的邀请码-邀请明细
#define LOAN_Mine_shareDetail        @"loan://mine/shareDetail/"
//我的邀请码-我的奖金
#define LOAN_Mine_shareCash(phone)        [NSString stringWithFormat:@"loan://mine/shareCash/%@",phone]
//我的邀请码-提现记录
#define LOAN_Mine_cashRecord          @"loan://mine/cashRecord/"
//关于我们
#define LOAN_Mine_AboutUs            @"loan://mine/aboutUs/"


//人像验证
#define LOAN_Account_PortraitAuth    @"loan://account/portraitAuth/"
//人像数据
#define LOAN_Account_PortraitData    @"loan://account/portraitData/"
//对比结果
#define LOAN_Account_PortraitResult(name,idCard,sex,address,nation,isAuthed) [NSString stringWithFormat:@"loan://account/portraitResult/%@/%@/%@/%@/%@/%@",name,idCard,sex,address,nation,isAuthed]
//我的消费
#define LOAN_Account_MyConsumption   @"loan://account/myConsumption/"
//我的消费详情
#define LOAN_Account_MyConsumptionDetail(title,orderNo) [NSString stringWithFormat:@"loan://account/myConsumptionDetail/%@/%@",title,orderNo]
//设置
#define LOAN_Account_AccountSetting  @"loan://account/accountSetting/"
//修改密码
#define LOAN_Account_EditLoginPwd    @"loan://account/editLoginPassword/"
//认证结果
#define LOAN_Account_ZMCreditResult  @"loan://account/creditResult/"
//我的贷款index:选中的索引
#define LOAN_Account_MyBorrow(index) [NSString stringWithFormat:@"loan://account/borrow/%@",index]
//申请
#define LOAN_Account_MyBorrow_ApplyList @"loan://account/borrow/appleList/"
//还款
#define LOAN_Account_MyBorrow_RepayList @"loan://account/borrow/repayList/"
//结清
#define LOAN_Account_MyBorrow_SettleList @"loan://account/borrow/settleList/"

/********** LoginRegist ***********/
//登录/注册
#define LOAN_User_LoginRegist        @"loan://user/loginRegist/"
//登录
#define LOAN_User_Login(phone)       [NSString stringWithFormat:@"loan://user/login/%@",phone]
//注册
#define LOAN_User_Regist(phone)      [NSString stringWithFormat:@"loan://user/regist/%@",phone]
//找回密码
#define LOAN_User_Forget(phone)       [NSString stringWithFormat:@"loan://user/forget/%@",phone]
//设置密码
#define LOAN_User_ResetPwd(phone,code)     [NSString stringWithFormat:@"loan://user/resetPwd/%@/%@",phone,code]
//忘记交易密码
#define LOAN_User_FindTardePwd        @"loan://user/FindTardePwd/"



/********** LoginRegist ***********/
//还款首页
#define LOAN_Repay_Repayment        @"loan://repay/repayment/"
//还款详情
#define LOAN_Repay_RepaymentDetail(id)      [NSString stringWithFormat:@"loan://repay/repaymentDetail/%@",id]
//还款方式
#define LOAN_Repay_RepaymentPayType(id)     [NSString stringWithFormat:@"loan://repay/repaymentPayType/%@",id]
//续借
#define LOAN_Repay_ContinueBorrow(id,isPenalty)       [NSString stringWithFormat:@"loan://repay/ContinueBorrow/%@/%@",id,isPenalty]
//续借记录
#define LOAN_Repay_RenewRecord(id)                     [NSString stringWithFormat:@"loan://repay/ContinueBorrow/RenewRecord/%@",id]
//还款方式详情
#define LOAN_Repay_RepaymentTypeContent(id,type)     [NSString stringWithFormat:@"loan://repay/repaymentTypeContent/%@/%@",id,type]

//借款申请
#define LOAN_Home_LoanApply   @"loan://home/loanApply"

#endif /* KWRouteUrl_h */
