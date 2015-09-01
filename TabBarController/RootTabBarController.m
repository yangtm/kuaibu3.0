//
//  RootTabBarController.m
//  kuaibu
//
//  Created by zxy on 15/9/1.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "RootTabBarController.h"
#import "HomePageViewController.h"
#import "FriendsViewController.h"
#import "MineViewController.h"
#import "SearchViewController.h"
#import "LoginViewController.h"
#import "LSNavigationController.h"
#import "WoWTabBarItem.h"





@interface RootTabBarController ()
{
    HomePageViewController *_homePageVC;
    SearchViewController *_searchVC;
    FriendsViewController *_friendsVC;
    MineViewController *_mineVC;
    
    NSInteger _newSelectIndex;
    NSInteger _oldSelectIndex;
}

@property (nonatomic, strong) LoginViewController *loginVC;
@property (nonatomic, strong) LSNavigationController *loginNav;
@property (strong, nonatomic) NSMutableArray *itemArray;
@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initTabViewController];
    [self initTabBarItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)initTabViewController
{
    _homePageVC = [[HomePageViewController alloc] init];
    _searchVC = [[SearchViewController alloc] init];
    _friendsVC = [[FriendsViewController alloc] init];
    _mineVC = [[MineViewController alloc] init];
    
    LSNavigationController *nav0 = [[LSNavigationController alloc] initWithRootViewController:_homePageVC];
    LSNavigationController *nav1 = [[LSNavigationController alloc] initWithRootViewController:_searchVC];
    LSNavigationController *nav2 = [[LSNavigationController alloc] init];
    LSNavigationController *nav3 = [[LSNavigationController alloc] initWithRootViewController:_friendsVC];
    LSNavigationController *nav4 = [[LSNavigationController alloc] initWithRootViewController:_mineVC];
    
    nav0.tabBarItem.tag = 0;
    nav1.tabBarItem.tag = 1;
    nav2.tabBarItem.tag = 2;
    nav3.tabBarItem.tag = 3;
    nav4.tabBarItem.tag = 4;
    
    self.viewControllers = @[nav0, nav1, nav2, nav3, nav4];
}

- (void)initTabBarItem
{
    self.itemArray = [NSMutableArray array];
    NSArray *imgs = @[@"1",
                      @"2",
                      @"3",
                      @"4",
                      @"5"];
    NSArray *titles = @[@"首页", @"发现", @"", @"朋友", @"我的"];
    CGFloat width = self.view.bounds.size.width / 5.0;
    for (int i = 0; i < 5; i++) {
        WoWTabBarItem *item = [[WoWTabBarItem alloc] initWithFrame:CGRectMake(i * width, 0, width, 49)
                                                             image:[UIImage imageNamed:imgs[i]]
                                                             title:titles[i]];
        [self.itemArray addObject:item];
        [self.tabBar addSubview:item];
    }
    
    WoWTabBarItem *item = self.itemArray[0];
    [item setSelect];
    
    item = self.itemArray[2];
    item.resposeEnable = NO;
}


- (void)changeSelectItem:(NSInteger)num
{
    WoWTabBarItem *item = self.itemArray[_newSelectIndex];
    [item setUnselect];
    
    item = self.itemArray[num];
    [item setSelect];
    
    _newSelectIndex = num;
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    _oldSelectIndex = tabBarController.selectedIndex;
    if (viewController.tabBarItem.tag == 2) {
//        YHBSelectMenuView *menuView = [[YHBSelectMenuView alloc] init];
//        menuView.delegate = self;
//        [menuView showView:self];
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发布采购",@"发布商品",@"以图搜布", nil];
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
        return NO;
    }
    
    return YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
//    _oldSelectIndex = tabBar.selectedItem;
    if (item.tag == 2) {
        
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发布采购",@"发布商品",@"以图搜布", nil];
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
        
    }
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSInteger num = viewController.tabBarItem.tag;
    if (_newSelectIndex == num) {
        return;
    }
    
    [self changeSelectItem:num];
}

@end
