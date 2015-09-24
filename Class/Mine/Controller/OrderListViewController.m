//
//  OrderListViewController.m
//  kuaibu
//
//  Created by zxy on 15/9/24.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "OrderListViewController.h"
#import "MineViewController.h"

@interface OrderListViewController ()
@property (nonatomic,strong) UIButton *backbutton;
@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settitleLabel:@"我的订单"];
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(back)];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
