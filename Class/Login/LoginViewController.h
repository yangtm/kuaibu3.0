//
//  LoginViewController.h
//  kuaibu
//
//  Created by zxy on 15/9/1.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "BaseViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "BaseViewController.h"

@interface LoginViewController : BaseViewController


typedef NS_ENUM(int, loginType)
{
    eLoginSucc,//登陆成功
    eLoginFail,//登陆失败
    eLoginBack//点击返回按钮
};


@property (nonatomic, assign)loginType type;
@property (nonatomic, strong)NSString *password;
- (void)clearText;
@end

