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
#import "PageIndex.h"
#import "MenuModel.h"
#import "BannerModel.h"
#import "AFNetworking.h"
#import "DicModel.h"
#import "LoginViewController.h"
#import "SlideSwitchView.h"
#import "HomeMainPageViewController.h"
#import "BannerDetailViewController.h"
#import "HomePageBannerCell.h"
#import "LookSupplyViewController.h"
#import "ProductViewController.h"
#import "CateViewController.h"

@interface HomePageViewController ()<SlideSwitchViewDelegate,HomeMainPageViewControllerDelegate,UITextFieldDelegate,HomePageSearchViewControllerDelegate,CateViewControllerDelegate>

@property (assign, nonatomic) CGFloat alphaOfNavigationBar;
@property (strong, nonatomic) UIButton *navBarCameraButton;
@property (strong, nonatomic) UIButton *navBarSearchButton;
@property (strong, nonatomic) UIButton *navBarMessageButton;
@property (strong, nonatomic) UITextField *navBarSearchTextField;
@property (strong, nonatomic) UIButton *navBarCancelButton;
@property (strong, nonatomic) UIButton *navBarDownButton;
@property (strong, nonatomic) UIView *badgeView;
@property (strong, nonatomic) HomePageSearchViewController *homePageSearchViewController;
@property (strong, nonatomic) HomeMainPageViewController *homeMainPageViewController;
@property (strong, nonatomic) SlideSwitchView *slideSwitchView;
@property (strong, nonatomic) CateViewController *CateViewController;
@property (strong, nonatomic) UIViewController *vc3;
@property (strong, nonatomic) UIViewController *vc4;
@property (strong, nonatomic) UIViewController *vc5;
@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor whiteColor];
    [self setupNormalNavBar];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.slideSwitchView.tabItemNormalColor = [SlideSwitchView colorFromHexRGB:@"868686"];
    self.slideSwitchView.tabItemSelectedColor = [SlideSwitchView colorFromHexRGB:@"bb0b15"];
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    
    _homeMainPageViewController =[[HomeMainPageViewController alloc]init];
    _homeMainPageViewController.title = @"热卖推荐";
    _homeMainPageViewController.homeMainPageViewDelegate = self;
    
    _CateViewController =[[CateViewController alloc]init];
    _CateViewController.title = @"产品类目";
    _CateViewController.delegate = self;
    
    _vc3 =[[UIViewController alloc]init];
    _vc4 =[[UIViewController alloc]init];
    _vc5 =[[UIViewController alloc]init];
   
    _vc3.view.backgroundColor = [UIColor yellowColor];
    _vc4.view.backgroundColor = [UIColor blueColor];
    _vc5.view.backgroundColor = [UIColor grayColor];
    
    _vc3.title = @"实时促销";
    _vc4.title = @"查看采购";
    _vc5.title = @"店铺列表";
    
    UIButton *rightSideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightSideButton setImage:[UIImage imageNamed:@"icon_rightarrow.png"] forState:UIControlStateNormal];
    [rightSideButton setImage:[UIImage imageNamed:@"icon_rightarrow.png"]  forState:UIControlStateHighlighted];
    rightSideButton.frame = CGRectMake(0, 0, 20.0f, 44.0f);
    rightSideButton.userInteractionEnabled = NO;
    
    self.slideSwitchView.rigthSideButton = rightSideButton;
    [self.slideSwitchView buildUI];
    [self.view addSubview:self.slideSwitchView];
    
}

#pragma mark -HomeMainPageViewControllerDelegate
-(void)advertUrl:(NSString *)advertUrl  advertTitle:(NSString *)advertTitle
{
    self.navigationController.navigationBar.alpha = 1.f;
    BannerDetailViewController *vc = [[BannerDetailViewController alloc] initWithUrl:advertUrl  title:advertTitle];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -CateViewControllerDelegate
- (void)categoryViewController:(CateViewController *)viewController selectCategory:(YHBCatData *)category
{
    self.navigationController.navigationBar.alpha = 1.f;
    ProductViewController *vc = [[ProductViewController alloc] init];
    NSArray *array = [[NSArray alloc]initWithObjects:[NSNumber numberWithInteger:category.categoryId]  ,nil];
    vc.catIds =array;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)selectBtn:(NSInteger )tag
{
    switch (tag) {
        case 1:
            NSLog(@"精品店铺列表");
            break;
        case 2:
        {
            self.navigationController.navigationBar.alpha = 1.f;
            ProductViewController *vc = [[ProductViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
            NSLog(@"产业带列表");
            break;
        case 4:
        {
            self.navigationController.navigationBar.alpha = 1.f;
            LookSupplyViewController *vc = [[LookSupplyViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
- (NSUInteger)numberOfTab:(SlideSwitchView *)view
{
    // you can set the best you can do it ;
    return 5;
}

- (UIViewController *)slideSwitchView:(SlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0) {
        return self.homeMainPageViewController;
    } else if (number == 1) {
        return self.CateViewController;
    } else if (number == 2) {
        return self.vc3;
    } else if (number == 3) {
        return self.vc4;
    } else if (number == 4) {
        return self.vc5;
    }  else {
        return nil;
    }
}

- (void)slideSwitchView:(SlideSwitchView *)view didselectTab:(NSUInteger)number
{
    UIViewController *vc = nil;
    if (number == 0) {
        vc = self.homeMainPageViewController;
    } else if (number == 1) {
        vc = self.CateViewController;
    } else if (number == 2) {
        vc = self.vc3;
    } else if (number == 3) {
        vc = self.vc4;
    } else if (number == 4) {
        vc = self.vc5;
    }
}

-(SlideSwitchView *)slideSwitchView
{
    if (_slideSwitchView == nil) {
        _slideSwitchView = [[SlideSwitchView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight - 64)];
        _slideSwitchView.slideSwitchViewDelegate = self;
    }
    return _slideSwitchView;
}


#pragma mark -创建导航栏
- (void)setupNormalNavBar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navBarCameraButton];
    self.navigationItem.titleView = self.navBarSearchButton;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navBarMessageButton];
    [self.navBarSearchTextField resignFirstResponder];
}

- (void)setupSearchNavBar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navBarCancelButton];
    self.navigationItem.titleView = self.navBarSearchTextField;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navBarDownButton];
    [self.navBarSearchTextField becomeFirstResponder];
}

- (UIButton *)navBarCameraButton
{
    if (_navBarCameraButton == nil) {
        _navBarCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _navBarCameraButton.frame = CGRectMake(0, 0, 20, 25);
        [_navBarCameraButton setImage:[UIImage imageNamed:@"home_label"] forState:UIControlStateNormal];
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
        _navBarSearchButton.layer.cornerRadius = 2.0;
        _navBarSearchButton.layer.masksToBounds = YES;
        _navBarSearchButton.layer.borderWidth = 0.6;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){0.8118,0.8157,0.8196,1 });
        _navBarSearchButton.layer.borderColor = colorref;
        [_navBarSearchButton setImage:[UIImage imageNamed:@"home_search"] forState:UIControlStateNormal];
        [_navBarSearchButton setImage:[UIImage imageNamed:@"home_search"] forState:UIControlStateHighlighted];
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
        _navBarCancelButton.frame = CGRectMake(0, 0, 30, 30);
        [_navBarCancelButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_navBarCancelButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
        [_navBarCancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBarCancelButton;
}

- (UIButton *)navBarDownButton
{
    if (_navBarDownButton == nil) {
        _navBarDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _navBarDownButton.frame = CGRectMake(0, 0, 35, 30);
        [_navBarDownButton setTitle:@"搜索" forState:UIControlStateNormal];
        [_navBarDownButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _navBarDownButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_navBarDownButton addTarget:self action:@selector(toSearch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBarDownButton;
}

- (UIButton *)navBarMessageButton
{
    if (_navBarMessageButton == nil) {
        _navBarMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _navBarMessageButton.frame = CGRectMake(0, 0, 20, 25);
        [_navBarMessageButton setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
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

- (UITextField *)navBarSearchTextField
{
    if (_navBarSearchTextField == nil) {
        _navBarSearchTextField = [[UITextField alloc] init];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 17)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"home_search_icn"];
        _navBarSearchTextField.leftView = imageView;
        _navBarSearchTextField.leftViewMode = UITextFieldViewModeAlways;
        _navBarSearchTextField.backgroundColor = [UIColor whiteColor];
        _navBarSearchTextField.layer.cornerRadius = 4.0;
        _navBarSearchTextField.layer.masksToBounds = YES;
        _navBarSearchTextField.placeholder = @"使用关键字词搜商品/店铺";
        _navBarSearchTextField.font = [UIFont systemFontOfSize:12.0];
        _navBarSearchTextField.returnKeyType = UIReturnKeySearch;
        _navBarSearchTextField.clearButtonMode = UITextFieldViewModeAlways;
        _navBarSearchTextField.delegate = self;
    }
    _navBarSearchTextField.frame = CGRectMake(0, 0, 250 * kRatio, 25);
    return _navBarSearchTextField;
}

- (HomePageSearchViewController *)homePageSearchViewController
{
    if (_homePageSearchViewController == nil) {
        _homePageSearchViewController = [[HomePageSearchViewController alloc] init];
        _homePageSearchViewController.delegate = self;
    }
    return _homePageSearchViewController;
}

#pragma mark -按钮响应事件
- (void)searchButtonClick:(UIButton *)sender
{
    [self setupSearchNavBar];
    self.homePageSearchViewController.view.frame  = self.view.bounds;
    [self.view addSubview:self.homePageSearchViewController.view];
}

- (void)cancelButtonClick:(UIButton *)sender
{
    [self dismissSearchView];
}

- (void)cameraButtonClick:(UIButton *)sender
{
    //    ImageSearchViewController *imageSearchVC = [[ImageSearchViewController alloc] init];
    //    LSNavigationController *nav = [[LSNavigationController alloc] initWithRootViewController:imageSearchVC];
    //    [self presentViewController:nav animated:YES completion:nil];
}

- (void)messageButtonClick:(UIButton *)sender
{
    //    ChatListViewController *vc = [[ChatListViewController alloc] init];
    //    vc.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dismissSearchView
{
    [self setupNormalNavBar];
    //    self.collectionView.scrollEnabled = YES;
    [self.homePageSearchViewController.view removeFromSuperview];
    self.homePageSearchViewController = nil;
    _navBarSearchTextField.text = @"";
}

#pragma mark - UITextFieldDelegate
- (void)toSearch
{
    NSLog(@"搜索");
    //    NSString *keyword = [_navBarSearchTextField.text copy];
    //    [self dismissSearchView];
    //    [self saveSearchWord:keyword];
    //    YHBRecProductListViewController *vc = [[YHBRecProductListViewController alloc] initWithKeyword:keyword];
    //    vc.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
