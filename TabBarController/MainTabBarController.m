//
//  MainTabBarController.m
//  小猪TV
//
//  Created by yinpeng on 15/6/23.
//  Copyright (c) 2015年 YinPeng. All rights reserved.
//

#import "MainTabBarController.h"
#import "HomePageViewController.h"
#import "FriendsViewController.h"
#import "MineViewController.h"
#import "SearchViewController.h"
#import "LoginViewController.h"
@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createViewControllers];
    
    //隐藏系统的Tabbar
    //    self.tabBar.hidden = YES;
    
}

#pragma mark - 创建视图控制器
- (void)createViewControllers
{
    //视图控制器数组
    NSArray *vcArray = @[@"HomePageViewController",
                         @"FriendsViewController",
                         @"",
                         @"SearchViewController",
                         @"LoginViewController"];
    //tabbar按钮图片
    NSArray * imageArray = @[@"iconfont-home(1)",
                             @"3",
                             @"5",
                             @"7",
                             @"9"];
    //tabbar选中按钮的图片
    NSArray * clickImageArray = @[@"iconfont-home_on(1)",
                                  @"4",
                                  @"6",
                                  @"8",
                                  @"10"];
    NSArray * titleArray = @[@"首页",@"发现",@"布得了",@"朋友",@"我的"];
    
    NSMutableArray *array = [NSMutableArray array];
    
    //循环创建视图控制器
    for (int i = 0; i < vcArray.count; i++) {
        UIViewController *vc = [[NSClassFromString(vcArray[i]) alloc] init];
        vc.tabBarItem.title = titleArray[i];
        vc.tabBarItem.image = [[UIImage imageNamed:imageArray[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:clickImageArray[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
        navi.tabBarItem.tag = i;
        [array addObject:navi];
    }
    self.viewControllers = array;
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    //    _oldSelectIndex = tabBar.selectedItem;
    if (item.tag == 2) {
        
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发布采购",@"发布商品",@"以图搜布", nil];
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
        
    }
}

-(void) showTabBarController
{
    if(self.tabBar)
    {
        self.tabBar.hidden = NO;
    }
}

-(void) hiddenTabBarController
{
    if(self.tabBar)
    {
        self.tabBar.hidden = YES;
    }
}

@end
