//
//  SellerViewController.m
//  kuaibu
//
//  Created by zxy on 15/9/22.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "SellerViewController.h"

@interface SellerViewController ()

@end

@implementation SellerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settitleLabel:@"我的店铺"];
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(clickLeftBtn)];
    // Do any additional setup after loading the view.
}

#pragma mark -返回
- (void)clickLeftBtn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
