//
//  MineViewController.m
//  kuaibu_3.0
//
//  Created by zxy on 15/8/18.
//  Copyright (c) 2015年 zxy. All rights reserved.
//

#import "MineViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "NSString+MD5.h"
#import "SettingViewController.h"



@interface MineViewController ()

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settitleLabel:@"用户中心"];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = item;
    
    [self test];
    self.view.backgroundColor = kViewBackgroundColor;
    self.mineHeadView = [[MineHeadView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 180) type:MineHeadViewTypeBuyer];
    self.functionsView = [[FunctionsView alloc] initWithFrame:CGRectMake(0, self.mineHeadView.bottom, kMainScreenWidth, kMainScreenHeight-self.mineHeadView.height)];
    //    self.mineHeadView.frame = CGRectMake(0, 0, kMainScreenWidth, 220);
    [self.view addSubview:self.mineHeadView];
    [self.view addSubview:self.functionsView];
    self.rightBtn.frame = CGRectMake([[UIScreen mainScreen]bounds].size.width-70, 30, 60, 20);
    [self.view addSubview:self.rightBtn];
    // Do any additional setup after loading the view.
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
}

- (UIButton *)rightBtn
{
    if (_rightBtn == nil) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"设置" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _rightBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 18, 5, 18);
        [_rightBtn addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (void)rightButtonClick:(UIButton *)btn
{
    SettingViewController *vc = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)test{
    
    //    http://192.168.1.111:8080/kuaibu-appServicr/member/memberInfo
    NSString *nonce = [NSString stringWithFormat:@"%d",arc4random_uniform(1000)+1];
    NSString *timestamp = [self getcurrentTimestamp];
    NSString *sign = [NSString stringWithFormat:@"%@||%@||%@||%@",kAPPID,nonce,timestamp,kAPPKEY];
    NSLog(@"sign:%@",sign);
    NSString *signs = [sign MD5Hash];
    NSLog(@"sign:%@",signs);
    NSString *newSign = [signs substringWithRange:NSMakeRange(12, 8)];
    NSDictionary *postDic =@{@"app_id":kAPPID,@"timestamp":timestamp,@"nonce":nonce,@"sign":newSign, @"memberNameTel":@"",@"password":@""};
    NSString *loginUrl = [NSString stringWithFormat:@"%@member/memberInfo",kYHBBaseUrl];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:loginUrl parameters:postDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"RESPMSG"]);
        
        if ([responseObject[@"RESPCODE"] integerValue]==0) {
            
        }
        NSLog(@"************************************");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

-(NSString*)getcurrentTimestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%f",time];
    NSString *timestamp = [timeStr componentsSeparatedByString:@"."][0]; //精确到秒
    return timestamp;
    
}

@end
