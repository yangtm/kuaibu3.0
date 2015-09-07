//
//  PasswordManagerViewController.m
//  YHB_Prj
//
//  Created by 童小波 on 15/6/5.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "PasswordManagerViewController.h"
#import "UIScrollView+AvoidingKeyboard.h"
#import "SVProgressHUD.h"

@interface PasswordManagerViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthOfScrollView;
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end

@implementation PasswordManagerViewController

- (void)dealloc
{
    [self.scrollView removeAdjust];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settitleLabel:@"密码管理"];
    self.widthOfScrollView.constant = kMainScreenWidth;
    [self setTextFieldBoard:_textField1];
    [self setTextFieldBoard:_textField2];
    [self setTextFieldBoard:_textField3];
    [self setButtonRadius:_submitButton];
    [self.scrollView autoAdjust];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTextFieldBoard:(UITextField *)textField
{
    textField.layer.borderColor = RGBCOLOR(234, 112, 12).CGColor;
    textField.layer.borderWidth = 1.0;
    textField.layer.cornerRadius = 4.0;
    textField.layer.masksToBounds = YES;
}

- (void)setButtonRadius:(UIButton *)button
{
    button.layer.cornerRadius = 4.0;
    button.layer.masksToBounds = YES;
}

- (IBAction)submitButtonClick:(id)sender {
    
    if ([_textField1.text isEqualToString:@""] || [_textField2.text isEqualToString:@""] || [_textField3.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"密码不可为空" cover:YES offsetY:kMainScreenHeight / 2.0];
        return ;
    }
    
    if (![_textField2.text isEqualToString:_textField3.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次新密码输入不一致" cover:YES offsetY:kMainScreenHeight / 2.0];
        return;
    }
    
    [self passwordManager];
    
}
- (void)passwordManager
{
    [FGGProgressHUD showLoadingOnView:self.view];
    __weak typeof(self) weakSelf=self;
    [NetworkService changePassWordWithOldPwd:_textField1.text andNewPwd:_textField3.text success:^(NSData *receiveData) {
        [FGGProgressHUD hideLoadingFromView:weakSelf.view];
        if(receiveData.length>0)
        {
            id result=[NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
            if([result isKindOfClass:[NSDictionary class]])
            {
                NSLog(@"person=%@",result);
                NSDictionary *dictionary=result;
                NSString *msg = dictionary[@"RESPMSG"];
                NSString *status = dictionary[@"RESPCODE"];
                NSLog(@"%@",result);
                if([status integerValue] == 0)
                {
                    [weakSelf showAlertWithMessage:msg automaticDismiss:YES];
                    [self.navigationController popViewControllerAnimated:YES];
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
