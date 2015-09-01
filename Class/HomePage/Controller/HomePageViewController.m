//
//  HomePageViewController.m
//  kuaibu_3.0
//
//  Created by zxy on 15/8/18.
//  Copyright (c) 2015年 zxy. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomePageSearchViewController.h"


@interface HomePageViewController ()


@property (assign, nonatomic) CGFloat alphaOfNavigationBar;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIButton *navBarCameraButton;
@property (strong, nonatomic) UIButton *navBarSearchButton;
@property (strong, nonatomic) UIButton *navBarMessageButton;
@property (strong, nonatomic) UITextField *navBarSearchTextField;
@property (strong, nonatomic) UIButton *navBarCancelButton;
@property (assign, nonatomic) CGFloat ratio;
@property (strong, nonatomic) HomePageSearchViewController *homePageSearchViewController;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    self.ratio = kMainScreenWidth / 320;
    [self setupNormalNavBar];
}

#pragma mark -创建导航栏
- (void)setupNormalNavBar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navBarCameraButton];
    self.navigationItem.titleView = self.navBarSearchButton;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navBarMessageButton];
    [self.navBarSearchTextField resignFirstResponder];
}

- (UIButton *)navBarCameraButton
{
    if (_navBarCameraButton == nil) {
        _navBarCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _navBarCameraButton.frame = CGRectMake(0, 0, 20, 25);
        [_navBarCameraButton setImage:[UIImage imageNamed:@"home_camera"] forState:UIControlStateNormal];
        _navBarCameraButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_navBarCameraButton addTarget:self action:@selector(cameraButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBarCameraButton;
}

- (UIButton *)navBarSearchButton
{
    if (_navBarSearchButton == nil) {
        _navBarSearchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _navBarSearchButton.frame = CGRectMake(0, 0, 220 * kRatio, 25);
        _navBarSearchButton.backgroundColor = [UIColor whiteColor];
        _navBarSearchButton.layer.cornerRadius = 4.0;
        _navBarSearchButton.layer.masksToBounds = YES;
        [_navBarSearchButton setImage:[UIImage imageNamed:@"home_search_icn"] forState:UIControlStateNormal];
        [_navBarSearchButton setImage:[UIImage imageNamed:@"home_search_icn"] forState:UIControlStateHighlighted];
        [_navBarSearchButton setTitle:@"请输入关键词搜索" forState:UIControlStateNormal];
        _navBarSearchButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [_navBarSearchButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _navBarSearchButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_navBarSearchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBarSearchButton;
}

- (UIButton *)navBarCancelButton
{
    if (_navBarCancelButton == nil) {
        _navBarCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _navBarCancelButton.frame = CGRectMake(0, 0, 35, 30);
        [_navBarCancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_navBarCancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _navBarCancelButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_navBarCancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBarCancelButton;
}

#pragma mark -按钮响应事件
- (void)searchButtonClick:(UIButton *)sender
{
//    [self killScroll];
//    [self setupSearchNavBar];
    HomePageSearchViewController *vc = [[HomePageSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
//    self.homePageSearchViewController.view.frame  = self.view.bounds;
//    [self.view addSubview:self.homePageSearchViewController.view];
}

- (void)cancelButtonClick:(UIButton *)sender
{
    [self dismissSearchView];
}

- (void)cameraButtonClick:(UIButton *)sender
{
    [self killScroll];
//    ImageSearchViewController *imageSearchVC = [[ImageSearchViewController alloc] init];
//    LSNavigationController *nav = [[LSNavigationController alloc] initWithRootViewController:imageSearchVC];
//    [self presentViewController:nav animated:YES completion:nil];
}

- (void)messageButtonClick:(UIButton *)sender
{
    [self killScroll];
//    ChatListViewController *vc = [[ChatListViewController alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupSearchNavBar
{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.titleView = self.navBarSearchTextField;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navBarCancelButton];
    [self.navBarSearchTextField becomeFirstResponder];
}

- (void)dismissSearchView
{
    [self setupNormalNavBar];
    //    self.collectionView.scrollEnabled = YES;
    [self.homePageSearchViewController.view removeFromSuperview];
    self.homePageSearchViewController = nil;
    _navBarSearchTextField.text = @"";
}

- (void)killScroll
{
    CGPoint offset = _collectionView.contentOffset;
    offset.y += 10.0;
    [_collectionView setContentOffset:offset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
