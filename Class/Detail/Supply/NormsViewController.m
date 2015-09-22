//
//  NormsViewController.m
//  kuaibu
//
//  Created by zxy on 15/9/22.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "NormsViewController.h"

@interface NormsViewController ()

@end

@implementation NormsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(236, 236, 236);
    self.title = @"填写规格";
    
    [self setRightButton:nil title:@"完成" target:self action:@selector(rightBarButtonClick:)];
    [self setLeftButton:[UIImage imageNamed:@"back"] title:@"" target:self action:@selector(backButtonClikc:)];
    // Do any additional setup after loading the view.
}

#pragma mark - 返回
- (void)backButtonClikc:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonClick:(UIButton *)btn
{
    
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
