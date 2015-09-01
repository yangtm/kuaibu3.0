//
//  MessageDefine.h
//  Hubanghu
//
//  Created by  striveliu on 14-10-9.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#ifndef Hubanghu_MessageDefine_h
#define Hubanghu_MessageDefine_h

#define kLeftViewPushMessage @"leftviewpushmessage"
#define kLeftViewPopMessage @"leftviewpopmessage"
#define kLoginForUserMessage @"loginforuser"
#define kLoginSuccessMessae @"loginsuccess" //登陆成功发送消息
#define kLoginFailMessage @"loginFail"
#define kLogoutMessage @"logout"
#define kUpdateUserMessage @"updateuser"
#define kUserInfoGetMessage @"useiInfoGet"//成功加载用户信息
#define kSearchMessage @"search"//搜索通知
#define kSearchCateMessage @"searchCate"//搜索cate

#define KGlobalResultMessage @"globalresult"

#define kPaySuccess @"paySuccess"
#define kPayFail @"payFail"
#define kAlipayOrderResultMessage @"payorderResult"
#define kWxpayOrderResultMessage @"wxpay_order_result"

#define kUMENG_APPKEY  @"54d87c2efd98c567420003da"

#define kShareWEIXINAPPID @"wxdf71533663734340"
#define kShareWEIXINAPPSECRET  @"dec9729d50175d100d09b177586b0243"
#define kWeChatOpenUrl @"http://a.app.qq.com/o/simple.jsp?pkgname=com.yibu.kuaibu&g_f=991653"

//通知收到新的报价
#define NewOfferPriceNotification @"NewOfferPriceNotification"
#define UnreadCountChangedNotification @"UnreadCountChangedNotification"
#define UpdateChatListNotification @"UpdateChatListNotification"

//进入聊天窗口
#define EnterChatViewNotification @"EnterChatViewNotification"
//退出聊天窗口
#define LeaveChatViewNotification @"LeaveChatViewNotification"
//标记为已读通知
#define SetReadNotification @"SetReadNotification"

#endif
