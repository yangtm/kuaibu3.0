//
//  ShopingCartController.m
//  kuaibu
//
//  Created by zxy on 15/9/24.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "ShopingCartController.h"

@interface ShopingCartController ()

@end

@implementation ShopingCartController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settitleLabel:@"购物车"];
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



@end
