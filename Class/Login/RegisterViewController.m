//
//  RegisterViewController.m
//  kuaibu
//
//  Created by zxy on 15/9/2.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIViewAdditions.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "HZCookie.h"
#import "FGGProgressHUD.h"
#import "NetworkService.h"
#import "AppDelegate.h"
#import "NSString+MD5.h"
#import "MineViewController.h"
#import "LoginViewController.h"
#define ksecond 60
enum TextField_Type
{
    TextField_phoneNumber = 130,//账号文本框-登录
    TextField_password, //密码框-登录
    TextField_rgPhoneNumber,
    TextField_rgPassword,
    TextField_rgRePassword,
    TextField_checkCode
};

@interface RegisterViewController ()<UITextFieldDelegate>
{
    int _secondCountDown;
}
//注册界面
@property (nonatomic,strong) UIView *registerView;//注册界面
@property (nonatomic, strong) UITextField *rgPhoneNumberTextField;
@property (nonatomic, strong) UITextField *rgPasswordTextField;
@property (nonatomic, strong) UITextField *rgRePasswordTextFiled;
@property (nonatomic, strong) UITextField *checkCodeTextField;
@property (nonatomic, weak) UIButton *registerButton;//注册按钮
@property (nonatomic, weak) UIButton *checkCodeButton;//验证码按钮
@property (nonatomic, strong) NSString *checkCode;//验证码
@property (nonatomic, strong) NSTimer *checkCodeTimer; //计时器
@property (strong,nonatomic) NSString *verifyCode;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = kViewBackgroundColor;
    [self settitleLabel:@"注册"];

    [self.view addSubview:self.registerView];
    
}

#pragma mark -注册界面
- (UIView *)registerView
{
    if (!_registerView) {
        _registerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-49)];
        _registerView.backgroundColor = RGBCOLOR(249, 249, 249);
        
        UIView *whiteBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 255)];
        whiteBackView.backgroundColor = [UIColor whiteColor];
        whiteBackView.layer.borderColor = [kLineColor CGColor];//[RGBCOLOR(207, 207, 207) CGColor];
        whiteBackView.layer.borderWidth = 1.0f;
        //whiteBackView.layer.cornerRadius = 4.0;
        [_registerView addSubview:whiteBackView];
        
        _rgPhoneNumberTextField = [self customedTextFieldWithFrame:CGRectMake(25, 15+20, whiteBackView.bounds.size.width-50, 35)  andPlaceholder:@"输入手机号" andTag:TextField_rgPhoneNumber andReturnKeyType:UIReturnKeyNext];
        [_rgPhoneNumberTextField setKeyboardType:UIKeyboardTypeNumberPad];
        [whiteBackView addSubview:self.rgPhoneNumberTextField];
        
        _checkCodeTextField = [self customedTextFieldWithFrame:CGRectMake(25, 65+20, (whiteBackView.bounds.size.width-50)*1.9/3.0f, 35) andPlaceholder:@"输入验证码" andTag:TextField_checkCode andReturnKeyType:UIReturnKeyNext];
        [whiteBackView addSubview:self.checkCodeTextField];
        
        _rgPasswordTextField = [self customedTextFieldWithFrame:CGRectMake(25, 115+20, whiteBackView.bounds.size.width-50, 35) andPlaceholder:@"输入密码" andTag:TextField_rgPassword andReturnKeyType:UIReturnKeyNext];
        self.rgPasswordTextField.secureTextEntry = YES;
        [whiteBackView addSubview:self.rgPasswordTextField];
        [self.view addSubview:_registerView];
        
        _rgRePasswordTextFiled = [self customedTextFieldWithFrame:CGRectMake(25, _rgPasswordTextField.bottom+15, whiteBackView.bounds.size.width-50, 35) andPlaceholder:@"再次输入密码" andTag:TextField_rgRePassword andReturnKeyType:UIReturnKeyGo];
        self.rgRePasswordTextFiled.secureTextEntry = YES;
        [whiteBackView addSubview:self.rgRePasswordTextFiled];
        [self.view addSubview:_registerView];
        
        //验证码button
        UIButton *checkCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        checkCodeButton.frame = CGRectMake(whiteBackView.bounds.size.width-25-_checkCodeTextField.width/2.0, 65+20, _checkCodeTextField.width/2.0, 35);
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
        [whiteBackView addSubview:checkCodeButton];
        
        UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        registerButton.backgroundColor = KColor;
        [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [registerButton setFrame:CGRectMake(20, 165+45+20+40, kMainScreenWidth-40.0, 40)];
        registerButton.layer.cornerRadius = 5.0f;
        [registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [registerButton addTarget:self action:@selector(registerBtn) forControlEvents:UIControlEventTouchUpInside];
        [_registerView addSubview:registerButton];
        
    }
    return _registerView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -注册
- (void)registerBtn
{
    if (self.rgPasswordTextField.text.length && self.rgPhoneNumberTextField.text.length && self.rgRePasswordTextFiled.text.length){
        if ([self.rgPasswordTextField.text isEqualToString:self.rgRePasswordTextFiled.text]) {
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
            [FGGProgressHUD showLoadingOnView:self.view];
            [NetworkService registerWithPhone:_rgPhoneNumberTextField.text checkCode:_checkCodeTextField.text passWord:_rgPasswordTextField.text success:^(NSData *receiveData) {
                [FGGProgressHUD hideLoadingFromView:weakSelf.view];
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
                            [weakSelf showAlertWithMessage:@"注册成功" automaticDismiss:YES];
                            [self.navigationController popViewControllerAnimated:YES];
                            [NSThread sleepForTimeInterval:1];
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
}


- (void)resignAllKeybord
{
    [self.view endEditing:YES];
}


#pragma mark 点击获取验证码按钮
- (void)getCheckCode
{
    if (self.rgPhoneNumberTextField.text && self.rgPhoneNumberTextField.text.length) {
        
        [SVProgressHUD showWithStatus:@"验证码发送中" cover:YES offsetY:kMainScreenHeight/2.0];
        
        [NetworkService getCheckCodeWithPhone:_rgPhoneNumberTextField.text smstpl:_checkCodeTextField.text success:^(NSData *receiveData) {
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
        
//        NSString *nonce = [NSString stringWithFormat:@"%d",arc4random_uniform(1000)+1];
//        NSString *timestamp = [self getcurrentTimestamp];
//        NSString *sign = [[NSString stringWithFormat:@"%@||%@||%@||%@",kAPPID,nonce,timestamp,kAPPKEY] MD5Hash];
//        //    NSLog(@"sign:%@",sign);
//        //    NSString *signs = [sign MD5Hash];
//        //    NSLog(@"sign:%@",signs);
//        NSString *newSign = [sign substringWithRange:NSMakeRange(12, 8)];
//        NSDictionary *postDic =@{@"app_id":kAPPID,@"timestamp":timestamp,@"nonce":nonce,@"sign":newSign, @"phone":_rgPhoneNumberTextField.text,@"zone":@""};
//        NSString *registeUrl = [NSString stringWithFormat:@"%@sendSms/getCheckCode",kYHBBaseUrl];
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        //                manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        //    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
//        
//        [manager POST:registeUrl parameters:postDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"%@",responseObject);
//            NSLog(@"%@",responseObject[@"RESPMSG"]);
//            if ([responseObject[@"RESPCODE"] integerValue]==0) {
//                [SVProgressHUD dismissWithSuccess:@"验证码已发送到您的手机"];
//                self.checkCodeButton.enabled = NO;
//                _secondCountDown = ksecond;
//                if (!self.checkCodeTimer) {
//                    self.checkCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeClicked) userInfo:nil repeats:YES];
//                }
//                _verifyCode = [NSString stringWithFormat:@"%@",responseObject[@"RESULT"]] ;
//                
//                NSLog(@"************************************");
//                NSLog(@"_verifyCode%@:",_verifyCode);
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"%@",error);
//            
//        }];
    }
    
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
    BOOL result=[mobliePredicate evaluateWithObject:_rgPhoneNumberTextField.text];
    return result;
}
/**
 *  校验密码格式是否正确
 */
-(BOOL)isPasswordCorrect
{
    NSString *reg=@"^[0-9a-zA-Z]{6,16}$";
    NSPredicate *passwordPredicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
    BOOL result=[passwordPredicate evaluateWithObject:_rgPasswordTextField.text];
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
#pragma mark - UITextField代理方法
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==_rgPhoneNumberTextField)
        return range.location<11;
    else if(textField==_rgPasswordTextField||textField==_rgRePasswordTextFiled)
        return range.location<16&&(![string isEqualToString:@" "]);//不包含空格
    else if(textField==_checkCodeTextField)
        return range.location<6;
    else
        return YES;
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


- (void)clearText
{
 
    _rgPasswordTextField.text = @"";
    _rgPhoneNumberTextField.text = @"";
}


@end
