//
//  LoginViewController.m
//  kuaibu
//
//  Created by zxy on 15/9/1.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "LoginViewController.h"
#import "UIViewAdditions.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "HZCookie.h"
#import "FGGProgressHUD.h"
#import "NetworkService.h"
#import "MineViewController.h"
#import "RegisterViewController.h"
#import "FindPswViewController.h"




enum TextField_Type
{
    TextField_phoneNumber = 130,//账号文本框-登录
    TextField_password, //密码框-登录
    TextField_rgPhoneNumber,
    TextField_rgPassword,
    TextField_rgRePassword,
    TextField_checkCode
};

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UIView *loginView;//登入界面

//登录界面
@property (nonatomic, strong) UITextField *phoneNumberTextField;
@property (nonatomic, strong) UITextField *passwordTextField;


@property (nonatomic, weak) UIButton *LoginButton;//登陆按钮
@property (nonatomic, weak) UIButton *forgetPasswordBtn;//忘记密码按钮

@property (strong, nonatomic) UIView *forgetPswView; //忘记密码view

@property (strong,nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) NSString *token;
@property (strong,nonatomic) NSString *verifyCode;

// 从服务器接收的完整数据
@property (strong, nonatomic) NSMutableData *serverData;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = kViewBackgroundColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.view addGestureRecognizer:tap];
    
    [self settitleLabel:@"登陆"];
    
    [self.view addSubview:self.loginView];
    
    [self setRightButton:[UIImage imageNamed:nil] title:@"注册" target:self action:@selector(showRegister)];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tap
{
    [self resignAllKeybord];
}


-(void)showRegister
{
    RegisterViewController *regiterController=[[RegisterViewController alloc] init];
    [self.navigationController pushViewController:regiterController animated:YES];
}


//登入
- (void)touchLoginButton
{
    [self resignAllKeybord];//隐藏所有键盘
    if (self.phoneNumberTextField.text.length && self.passwordTextField.text.length) {
        
        //        if(_phoneNumberTextField.text.length==0)
        //        {
        //            [self showAlertWithMessage:@"手机号码不能为空" automaticDismiss:YES];
        //            return;
        //        }
        //        if(_phoneNumberTextField.text.length!=11)
        //        {
        //            [self showAlertWithMessage:@"手机号或密码输入有误" automaticDismiss:YES];
        //            return;
        //        }
        //        if(![self isPhoneNumber])
        //        {
        //            [self showAlertWithMessage:@"手机号或密码输入有误" automaticDismiss:YES];
        //            return;
        //        }
        //        if(_passwordTextField.text.length==0)
        //        {
        //            [self showAlertWithMessage:@"密码不能为空" automaticDismiss:YES];
        //            return;
        //        }
        //        if(![self isPasswordCorrect])
        //        {
        //            [self showAlertWithMessage:@"手机号或密码输入有误" automaticDismiss:NO];
        //            return;
        //        }
   
        [FGGProgressHUD showLoadingOnView:self.view];
        __weak typeof(self) weakSelf=self;
        [NetworkService loginWithphone:_phoneNumberTextField.text password:_passwordTextField.text success:^(NSData *receiveData) {
            [FGGProgressHUD hideLoadingFromView:weakSelf.view];
            if(receiveData.length>0)
            {
                id result=[NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
                if([result isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dictionary=result;
                    NSString *msg = dictionary[@"RESPMSG"];
                    NSString *status = dictionary[@"RESPCODE"];
                    NSString *token = dictionary[@"RESULT"];
                    NSLog(@"%@",result);
                    if([status integerValue] == 0)
                    {
                        [weakSelf showAlertWithMessage:msg automaticDismiss:YES];
                                            AppDelegate *app= DefaultAppDelegate;
                                            //保存Token
                                            app.token = token;
                                            app.isLoginedIn = YES;
                        MineViewController *vc = [[MineViewController alloc] init];
                        vc.userName = _phoneNumberTextField.text;
//                        self.tabBarController.tabBar.hidden = YES;
//                        [self presentViewController:[[LSNavigationController alloc] initWithRootViewController:vc] animated:YES completion:^{
//                            
//                        }];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else if ([status integerValue] != 0)
                    {
                        [FGGProgressHUD hideLoadingFromView:weakSelf.view];
                        [weakSelf showAlertWithMessage:msg automaticDismiss:NO];
                    }
                }
            }
        } failure:^(NSError *error) {
            [FGGProgressHUD hideLoadingFromView:weakSelf.view];
            [self showAlertWithMessage:error.localizedDescription automaticDismiss:NO];
        }];

    }
}

#pragma mark - UITextField代理方法
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==_phoneNumberTextField)
        return range.location<11;
    else
        return range.location<16&&(![string isEqualToString:@" "]);//不包含空格
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
//结束输入
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//登入界面
- (UIView *)loginView
{
    if (!_loginView) {
        _loginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-49)];
        _loginView.backgroundColor = RGBCOLOR(249, 249, 249);
        
        UIView *whiteBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 145)];
        whiteBackView.backgroundColor = [UIColor whiteColor];
        whiteBackView.layer.borderColor = [kLineColor CGColor];//[RGBCOLOR(207, 207, 207) CGColor];
        whiteBackView.layer.borderWidth = 1.0f;
        //whiteBackView.layer.cornerRadius = 4.0;
        [_loginView addSubview:whiteBackView];
        
        self.phoneNumberTextField = [self customedTextFieldWithFrame:CGRectMake(25, 10+20, whiteBackView.bounds.size.width-50, 35) andPlaceholder:@"输入手机号" andTag:TextField_phoneNumber andReturnKeyType:(UIReturnKeyNext)];
        self.phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
        [whiteBackView addSubview:self.phoneNumberTextField];
        
        self.passwordTextField = [self customedTextFieldWithFrame:CGRectMake(25, 60+20, whiteBackView.bounds.size.width-50, 35) andPlaceholder:@"密码" andTag:TextField_password andReturnKeyType:UIReturnKeyGo];
        self.passwordTextField.secureTextEntry = YES;
        [whiteBackView addSubview:self.passwordTextField];
        
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.backgroundColor = KColor;
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton setFrame:CGRectMake(20, 125+45+20, kMainScreenWidth-40.0, 40)];
        loginButton.layer.cornerRadius = 5.0f;
        [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(touchLoginButton) forControlEvents:UIControlEventTouchUpInside];
        _LoginButton = loginButton;
        [_loginView addSubview:loginButton];
        
        UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetPasswordBtn = forgetButton;
        [_forgetPasswordBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetPasswordBtn addTarget:self action:@selector(touchForgetPswBtn) forControlEvents:UIControlEventTouchUpInside];
        [_forgetPasswordBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_forgetPasswordBtn setFrame:CGRectMake(kMainScreenWidth - 20-60, loginButton.bottom+20, 60, 20)];
        _forgetPasswordBtn.titleLabel.font = kFont12;
        [_loginView addSubview:_forgetPasswordBtn];
        [self.view addSubview:_loginView];
    }
    return _loginView;
}

/**
 *  校验手机号码是否正确
 */
-(BOOL)isPhoneNumber
{
    NSString *reg=@"^(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *mobliePredicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
    BOOL result=[mobliePredicate evaluateWithObject:_phoneNumberTextField.text];
    return result;
}
/**
 *  校验密码格式是否正确
 */
-(BOOL)isPasswordCorrect
{
    NSString *reg=@"^[0-9a-zA-Z]{6,16}$";
    NSPredicate *passwordPredicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
    BOOL result=[passwordPredicate evaluateWithObject:_passwordTextField.text];
    return result;
}
/**
 *  警告视图
 *
 *  @param message   警告信息
 *  @param automatic 警告视图是否自动消失
 */
-(void)showAlertWithMessage:(NSString *)message automaticDismiss:(BOOL)automatic
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    if(automatic)
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:1.0f];
    
}
/**
 *  消失警告视图
 *
 *  @param alert 警告视图
 */
-(void)dismissAlertView:(UIAlertView *)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}



#pragma mark touch忘记密码按钮
- (void)touchForgetPswBtn
{
    FindPswViewController *findVC = [[FindPswViewController alloc] init];
    LSNavigationController *nav = [[LSNavigationController alloc] initWithRootViewController:findVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)resignAllKeybord
{
    [self.view endEditing:YES];
}

//定制的textField
- (UITextField *)customedTextFieldWithFrame:(CGRect)frame andPlaceholder:(NSString *)placeholder andTag:(NSInteger)TextField_Type andReturnKeyType:(UIReturnKeyType)returnKeyType
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = 4.0f;
    textField.layer.borderColor = [kLineColor CGColor];//[RGBCOLOR(207, 207, 207) CGColor];//[KColor CGColor];
    if (kSystemVersion < 7.0) {
        [textField setBorderStyle:UITextBorderStyleBezel];
    }
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.layer.borderWidth = 0.7f;
    textField.placeholder = placeholder;
    textField.delegate = self;
    textField.tag = TextField_Type;
    [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [textField setReturnKeyType:returnKeyType];
    return textField;
}

- (void)clearText
{
    //_phoneNumberTextField.text = @"";
    _passwordTextField.text = @"";
}


@end
