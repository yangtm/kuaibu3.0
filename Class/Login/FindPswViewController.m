//
//  FindPswViewController.m
//  kuaibu
//
//  Created by zxy on 15/9/6.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "FindPswViewController.h"
#import "SVProgressHUD.h"

#define kWhiteleft 0
#define kButtonleft 25
enum TextField_Type
{
    TextField_phoneNumber = 30,//账号文本框-登录
    TextField_checkCode,
    TextField_newPassword,
    TextField_rePassword,
};

@interface FindPswViewController ()<UITextFieldDelegate>
{
    int _secondCountDown;
}
@property (strong, nonatomic) UIView *findPswView;
@property (strong, nonatomic) UITextField *phoneNumberTextField;
@property (strong, nonatomic) UITextField *checkCodeTextField;
@property (strong, nonatomic) UITextField *passwordTextFiled;
@property (strong, nonatomic) UITextField *rePasswordTextField;
@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UIButton *checkCodeButton;
@property (nonatomic, strong) NSTimer *checkCodeTimer; //计时器
@property (strong,nonatomic) NSString *verifyCode;
@end

@implementation FindPswViewController
#pragma mark - getter and setter
- (UIView *)findPswView
{
    if (!_findPswView) {
        
        _findPswView = [[UIView alloc] initWithFrame:CGRectMake(kWhiteleft, 0, kMainScreenWidth-2*kWhiteleft, 215+20+20)];
        _findPswView.backgroundColor = [UIColor whiteColor];
        _findPswView.layer.borderColor = [kLineColor CGColor];//[RGBCOLOR(207, 207, 207) CGColor];
        _findPswView.layer.borderWidth = 1.0f;
        _findPswView.layer.cornerRadius = 4.0;
        
        _phoneNumberTextField = [self customedTextFieldWithFrame:CGRectMake(kButtonleft, 15+20, _findPswView.bounds.size.width-2*kButtonleft, 35)  andPlaceholder:@"输入手机号" andTag:TextField_phoneNumber andReturnKeyType:UIReturnKeyNext];
        [_phoneNumberTextField setKeyboardType:UIKeyboardTypeNumberPad];
        [_findPswView addSubview:self.phoneNumberTextField];
        
        _checkCodeTextField = [self customedTextFieldWithFrame:CGRectMake(kButtonleft, 15+_phoneNumberTextField.bottom, (_findPswView.bounds.size.width-2*kButtonleft)*1.9/3.0f, 35) andPlaceholder:@"输入验证码" andTag:TextField_checkCode andReturnKeyType:UIReturnKeyNext];
        [_findPswView addSubview:self.checkCodeTextField];
        
        _passwordTextFiled = [self customedTextFieldWithFrame:CGRectMake(kButtonleft, 15+_checkCodeTextField.bottom, _findPswView.bounds.size.width-2*kButtonleft, 35) andPlaceholder:@"输入新密码" andTag:TextField_newPassword andReturnKeyType:UIReturnKeyNext];
        self.passwordTextFiled.secureTextEntry = YES;
        [_findPswView addSubview:self.passwordTextFiled];
        
        _rePasswordTextField = [self customedTextFieldWithFrame:CGRectMake(kButtonleft, 15+_passwordTextFiled.bottom, _findPswView.bounds.size.width-2*kButtonleft, 35) andPlaceholder:@"重新输入新密码" andTag:TextField_rePassword andReturnKeyType:UIReturnKeyGo];
        self.rePasswordTextField.secureTextEntry = YES;
        [_findPswView addSubview:self.rePasswordTextField];
        
        //验证码button
        UIButton *checkCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        checkCodeButton.frame = CGRectMake(_findPswView.bounds.size.width-kButtonleft-_checkCodeTextField.width/2.0f,_checkCodeTextField.top, _checkCodeTextField.width/2.0f, 35);
        checkCodeButton.titleLabel.font = kFont14;
        [checkCodeButton setBackgroundColor:RGBCOLOR(220, 220, 220)];
        [checkCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [checkCodeButton setTitleColor:RGBCOLOR(157, 157, 157) forState:UIControlStateNormal];
        [checkCodeButton addTarget:self action:@selector(getCheckCode) forControlEvents:UIControlEventTouchUpInside];
        checkCodeButton.layer.borderColor = [kLineColor CGColor];//[RGBCOLOR(198, 198, 198) CGColor];
        checkCodeButton.layer.borderWidth = 0.5f;
        checkCodeButton.layer.masksToBounds = YES;
        self.checkCodeButton = checkCodeButton;
        checkCodeButton.layer.cornerRadius = 5.0f;
        [_findPswView addSubview:checkCodeButton];
        
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.backgroundColor = KColor;
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton setFrame:CGRectMake(20, _findPswView.bottom+45, kMainScreenWidth-40.0, 40)];
        loginButton.layer.cornerRadius = 5.0f;
        [loginButton setTitle:@"确认修改" forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(ConfirmChange) forControlEvents:UIControlEventTouchUpInside];
        _loginButton = loginButton;
        [self.view addSubview:loginButton];
        
    }
    return _findPswView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settitleLabel:@"找回密码"];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    //ui
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(backItem)];
    
    self.view.backgroundColor = kViewBackgroundColor;
    [self.view addSubview:self.findPswView];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    [super viewWillDisappear:animated];
}

#pragma mark - Action
- (void)getCheckCode
{
    
    if (self.phoneNumberTextField.text && self.phoneNumberTextField.text.length) {
        
        [SVProgressHUD showWithStatus:@"验证码发送中" cover:YES offsetY:kMainScreenHeight/2.0];
        
        [NetworkService getCheckCodeWithPhone:_phoneNumberTextField.text smstpl:_checkCodeTextField.text success:^(NSData *receiveData) {
            id result=[NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
            if ([result[@"RESPCODE"] integerValue]==0) {
                [SVProgressHUD dismissWithSuccess:@"验证码已发送到您的手机"];
                self.checkCodeButton.enabled = NO;
                _secondCountDown = ksecond;
                if (!self.checkCodeTimer) {
                    self.checkCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeClicked) userInfo:nil repeats:YES];
                }
                _verifyCode = [NSString stringWithFormat:@"%@",result[@"RESULT"]] ;
                
                NSLog(@"************************************");
                NSLog(@"_verifyCode%@:",_verifyCode);
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)ConfirmChange
{
    [self resignAllKeyBord];
    {
//        if (self.phoneNumberTextField.text.length && self.phoneNumberTextField.text.length && self.rePasswordTextField.text.length){
//            if ([self.rePasswordTextField.text isEqualToString:self.passwordTextFiled.text]) {
                //            if(_rgPhoneNumberTextField.text.length==0)
                //            {
                //                [self showAlertWithMessage:@"手机号码不能为空" automaticDismiss:YES];
                //                return;
                //            }
                //            if(_rgPhoneNumberTextField.text.length!=11)
                //            {
                //                [self showAlertWithMessage:@"手机号码输入不正确" automaticDismiss:YES];
                //                return;
                //            }
                //            if(![self isPhoneNumber])
                //            {
                //                [self showAlertWithMessage:@"手机号码输入不正确" automaticDismiss:YES];
                //                return;
                //            }
                //            if(_checkCodeTextField.text.length==0)
                //            {
                //                [self showAlertWithMessage:@"验证码不能为空，请输入验证码" automaticDismiss:YES];
                //                return;
                //            }
                //            if(![_checkCodeTextField.text isEqualToString: _verifyCode])
                //            {
                //                NSLog(@"_checkCodeTextField:%@",_checkCodeTextField.text);
                //                NSLog(@"_verifyCode1111:%@",_verifyCode);
                //                [self showAlertWithMessage:@"验证码不正确" automaticDismiss:YES];
                //                return;
                //            }
                //            if(_rgPasswordTextField.text.length==0)
                //            {
                //                [self showAlertWithMessage:@"密码不能为空" automaticDismiss:YES];
                //                return;
                //            }
                //            if(![self isPasswordCorrect])
                //            {
                //                [self showAlertWithMessage:@"密码格式不正确，请输入6~16位密码" automaticDismiss:YES];
                //                return;
                //            }
                //            if(_rgRePasswordTextFiled.text.length==0)
                //            {
                //                [self showAlertWithMessage:@"请输入确认密码！" automaticDismiss:YES];
                //                return;
                //            }
                //            if(![_rgPasswordTextField.text isEqualToString:_rgRePasswordTextFiled.text])
                //            {
                //
                //                [self showAlertWithMessage:@"两次密码不一致！请重新输入" automaticDismiss:YES];
                //                _rgPasswordTextField.text=nil;
                //                _rgRePasswordTextFiled.text=nil;
                //                [_rgPasswordTextField becomeFirstResponder];
                //                return;
                //            }
                
                __weak typeof(self) weakSelf=self;
//                [FGGProgressHUD showLoadingOnView:self.view];
                [NetworkService findPasswordWithPhone:_phoneNumberTextField.text newPassword:_rePasswordTextField.text checkcode:_checkCodeTextField.text success:^(NSData *receiveData) {
//                    [FGGProgressHUD hideLoadingFromView:weakSelf.view];
                    NSLog(@"%@",receiveData);
                    if(receiveData.length>0)
                    {
                        id result=[NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
                        if([result isKindOfClass:[NSDictionary class]])
                        {
                            NSDictionary *dict=(NSDictionary *)result;
                            NSString *status=dict[@"RESPCODE"];
                            NSString *msg=dict[@"RESPMSG"];
                            NSLog(@"%@",result);
                            if([status integerValue] == 0)
                            {
                                [weakSelf showAlertWithMessage:@"密码修改成功" automaticDismiss:YES];
//                                [self.navigationController popViewControllerAnimated:YES];
//                                [NSThread sleepForTimeInterval:1];
                            }
                            else if([status intValue] != 0 )
                            {
                                [weakSelf showAlertWithMessage:msg automaticDismiss:YES];
                            }
                        }
                    }
                } failure:^(NSError *error) {
                    [FGGProgressHUD hideLoadingFromView:weakSelf.view];
                    [self showAlertWithMessage:error.localizedDescription automaticDismiss:NO];
                }];
            }
        }
//    }
//}

- (void)backItem
{
    [self resignAllKeyBord];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 倒计时
- (void)timeClicked
{
    if (_secondCountDown > 0) {
        //self.checkCodeButton.titleLabel.text = [NSString stringWithFormat:@"%ds重发",_secondCountDown];
        [self.checkCodeButton setTitle:[NSString stringWithFormat:@"%ds后重发",_secondCountDown] forState:UIControlStateNormal];
        _secondCountDown--;
    }else{
        self.checkCodeButton.enabled = YES;
        [self.checkCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        if ([self.checkCodeTimer isValid]) {
            [self.checkCodeTimer invalidate];
            _checkCodeTimer = nil;
        }
    }
}

- (void)resignAllKeyBord
{
    if([self.phoneNumberTextField isFirstResponder]) [self.phoneNumberTextField resignFirstResponder];
    if([self.passwordTextFiled isFirstResponder]) [self.passwordTextFiled resignFirstResponder];
    if([self.rePasswordTextField isFirstResponder]) [self.rePasswordTextField resignFirstResponder];
    if([self.checkCodeTextField isFirstResponder]) [self.checkCodeTextField resignFirstResponder];
}

#pragma mark - delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.layer.borderColor = [KColor CGColor];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textField.layer.borderColor = [kLineColor CGColor];//[RGBCOLOR(207, 207, 204) CGColor];
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case TextField_phoneNumber:
            [self.checkCodeTextField becomeFirstResponder];
            break;
        case TextField_checkCode:
            [self.passwordTextFiled becomeFirstResponder];
            break;
        case TextField_newPassword:
            [self.rePasswordTextField becomeFirstResponder];
            break;
        case TextField_rePassword:
        {
            [textField resignFirstResponder];
            [self ConfirmChange];
        }
            break;
        default:
            break;
    }
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignAllKeyBord];
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

/**
 *  校验手机号码格式是否正确
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
    BOOL result=[passwordPredicate evaluateWithObject:_rePasswordTextField.text];
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
@end

