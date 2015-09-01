//
//  MineViewController.h
//  kuaibu_3.0
//
//  Created by zxy on 15/8/18.
//  Copyright (c) 2015年 zxy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MineHeadView.h"
#import "FunctionsView.h"

@interface MineViewController : BaseViewController

@property (nonatomic,strong) MineHeadView *mineHeadView;
@property (nonatomic,strong) FunctionsView *functionsView;

@property (nonatomic,strong) UIButton *rightBtn;

@end
