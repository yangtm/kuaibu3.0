//
//  HomePageViewController.m
//  kuaibu_3.0
//
//  Created by zxy on 15/8/18.
//  Copyright (c) 2015年 zxy. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomePageSearchViewController.h"
#import "CategoryPageViewController.h"

NSString *const BannerCellIdentifier = @"BannerCellIdentifier";
NSString *const PavilionCellIdentifier = @"PavilionCellIdentifier";
NSString *const HotProductIdentifier = @"HotProductIdentifier";
NSString *const BandCellIdentifier = @"BandCellIdentifier";
NSString *const LatestBuyIdentifier = @"LatestBuyIdentifier";
NSString *const TitleHeadViewIdentifier = @"TitleHeadViewIdentifier";
NSString *const BlankReuseViewIdentifier = @"BlankReuseViewIdentifier";


@interface HomePageViewController ()

@property (assign, nonatomic) CGFloat alphaOfNavigationBar;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIButton *navBarCameraButton;
@property (strong, nonatomic) UIButton *navBarSearchButton;
@property (strong, nonatomic) UIButton *navBarMessageButton;
@property (strong, nonatomic) UITextField *navBarSearchTextField;
@property (strong, nonatomic) UIButton *navBarCancelButton;
@property (assign, nonatomic) CGFloat ratio;
@property (strong, nonatomic) UIView *badgeView;
@property (strong, nonatomic) HomePageSearchViewController *homePageSearchViewController;


@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.ratio = kMainScreenWidth / 320;
    [self setupNormalNavBar];
    
    self.collectionView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64);
    [self registerCell];
    [self.view addSubview:self.collectionView];
    
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

- (UIButton *)navBarMessageButton
{
    if (_navBarMessageButton == nil) {
        _navBarMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _navBarMessageButton.frame = CGRectMake(0, 0, 20, 25);
        [_navBarMessageButton setImage:[UIImage imageNamed:@"home_page_3"] forState:UIControlStateNormal];
        _navBarMessageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_navBarMessageButton addTarget:self action:@selector(messageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _badgeView = [[UIView alloc] initWithFrame:CGRectMake(13, 0, 10, 10)];
        _badgeView.layer.cornerRadius = 5.0;
        _badgeView.layer.masksToBounds = YES;
        _badgeView.backgroundColor = [UIColor redColor];
        [_navBarMessageButton addSubview:_badgeView];
    }
    return _navBarMessageButton;
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

- (void)registerCell
{
    [self registerCellWithNibName:@"HomePageBannerCell" identifier:BannerCellIdentifier];
    [self registerCellWithNibName:@"HomePagePavilionCell" identifier:PavilionCellIdentifier];
    [self registerCellWithNibName:@"HomePageHotProductCell" identifier:HotProductIdentifier];
    [self registerCellWithNibName:@"HomePageBandCell" identifier:BandCellIdentifier];
    [self registerCellWithNibName:@"HomePageLatestBuyCell" identifier:LatestBuyIdentifier];

    [_collectionView registerNib:[UINib nibWithNibName:@"HomePageTitleHeadView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TitleHeadViewIdentifier];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BlankReuseViewIdentifier];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BlankReuseViewIdentifier];
    
}

- (void)registerCellWithNibName:(NSString *)nibName identifier:(NSString *)identifier
{
    [self.collectionView registerNib:[UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
}


- (void)setupSearchNavBar
{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.titleView = self.navBarSearchTextField;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navBarCancelButton];
    [self.navBarSearchTextField becomeFirstResponder];
}

- (void)killScroll
{
    CGPoint offset = _collectionView.contentOffset;
    offset.y += 10.0;
    [_collectionView setContentOffset:offset];
}

- (void)dismissSearchView
{
    [self setupNormalNavBar];
    //    self.collectionView.scrollEnabled = YES;
    [self.homePageSearchViewController.view removeFromSuperview];
    self.homePageSearchViewController = nil;
    _navBarSearchTextField.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
