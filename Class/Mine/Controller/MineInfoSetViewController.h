//
//  MineInfoSetViewController.h
//  YHB_Prj
//
//  Created by 童小波 on 15/6/3.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MineInfoSetViewController : BaseViewController

//进入到地址页面，返回前重新设置默认地址
- (void)setAddress:(NSString *)address;

@end
