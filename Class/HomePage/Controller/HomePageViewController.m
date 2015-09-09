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
#import "HomePageBannerCell.h"
#import "AFNetworking.h"
#import "DicModel.h"

NSString *const BannerCellIdentifier = @"BannerCellIdentifier";
NSString *const PavilionCellIdentifier = @"PavilionCellIdentifier";
NSString *const HotProductIdentifier = @"HotProductIdentifier";
NSString *const BandCellIdentifier = @"BandCellIdentifier";
NSString *const LatestBuyIdentifier = @"LatestBuyIdentifier";
NSString *const TitleHeadViewIdentifier = @"TitleHeadViewIdentifier";
NSString *const BlankReuseViewIdentifier = @"BlankReuseViewIdentifier";

typedef NS_ENUM(NSInteger, SectionTag) {
    BannerSection,
    PavilionSection,
    HotProductSection,
    BandSection,
    LatestBuySection,
};

@interface HomePageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,BannerDelegate>

@property (assign, nonatomic) CGFloat alphaOfNavigationBar;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIButton *navBarCameraButton;
@property (strong, nonatomic) UIButton *navBarSearchButton;
@property (strong, nonatomic) UIButton *navBarMessageButton;
@property (strong, nonatomic) UITextField *navBarSearchTextField;
@property (strong, nonatomic) UIButton *navBarCancelButton;
@property (assign, nonatomic) CGFloat ratio;
@property (strong, nonatomic) UIView *badgeView;
@property (strong, nonatomic) PageIndex *pageIndex;
@property (strong, nonatomic) HomePageSearchViewController *homePageSearchViewController;


@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.ratio = kMainScreenWidth / 320;
    [self setupNormalNavBar];
    
    self.collectionView.frame = CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight - 64);
    [self registerCell];
    [self.view addSubview:self.collectionView];
    
    //[self addPullToRefresh];
    [self reloadData];
    
}

#pragma mark -创建导航栏
- (void)setupNormalNavBar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navBarCameraButton];
    self.navigationItem.titleView = self.navBarSearchButton;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navBarMessageButton];
    [self.navBarSearchTextField resignFirstResponder];
}

#pragma mark - setters and getters
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
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

- (void)configBannerCell:(UICollectionViewCell *)cell
{
    if (_pageIndex.banners == nil) {
        return;
    }
    NSMutableArray *mutableArary = [NSMutableArray array];
    for (BannerModel *item in _pageIndex.banners) {
        [mutableArary addObject:item.thumb];
    }
    HomePageBannerCell *bannerCell = (HomePageBannerCell *)cell;
    bannerCell.bannerView.delegate = self;
    bannerCell.bannerView.isNeedCycle = YES;
    bannerCell.bannerView.autoRoll = YES;
    [bannerCell.bannerView resetUIWithUrlStrArray:mutableArary];
}

- (void)reloadData
{
    
     NSDictionary *dic = [NSDictionary dictionaryWithObject:@"001" forKey:@"advertSpaceNumber"];
     
     NSString *adverturl= nil;
     kYHBRequestUrl(@"advert/getAdvert", adverturl);
//    NSLog(@"%@",adverturl);
     [NetworkService postWithURL:adverturl paramters:dic success:^(NSData *receiveData) {
     if (receiveData.length>0) {
     id result=[NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
         
     
//     NSLog(@"result=%@",result);
     }
     
     
     
     
     }failure:^(NSError *error){
     NSLog(@"下载数据失败");
     }];
    
    
    
    /*
     [self.indexManager getPageIndexWithSuccess:^(YHBPageIndex *model) {
     
     self.pageIndex = model;
     [_collectionView.pullToRefreshView stopAnimating];
     [self.collectionView reloadData];
     
     } failure:^(int result, NSString *errorString) {
     
     }];*/
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
    // [self registerCellWithNibName:@"HomePagePavilionCell" identifier:PavilionCellIdentifier];
    //[self registerCellWithNibName:@"HomePageHotProductCell" identifier:HotProductIdentifier];
    // [self registerCellWithNibName:@"HomePageBandCell" identifier:BandCellIdentifier];
    // [self registerCellWithNibName:@"HomePageLatestBuyCell" identifier:LatestBuyIdentifier];
    
    // [_collectionView registerNib:[UINib nibWithNibName:@"HomePageTitleHeadView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TitleHeadViewIdentifier];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BlankReuseViewIdentifier];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BlankReuseViewIdentifier];
    
}

- (void)registerCellWithNibName:(NSString *)nibName identifier:(NSString *)identifier
{
    [self.collectionView registerNib:[UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger num = 0;
    switch (section) {
        case BannerSection:
        {
            num = 1;
        }
            break;
        case PavilionSection:
        {
            num = 8;
        }
            break;
        case HotProductSection:
        {
            num = 4;
        }
            break;
        case BandSection:
        {
            num = 6;
        }
            break;
        case LatestBuySection:
        {
            num = 3;
        }
            break;
        default:
            break;
    }
    return num;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    switch (indexPath.section) {
        case BannerSection:
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:BannerCellIdentifier forIndexPath:indexPath];
            [self configBannerCell:cell];
        }
            break;
            /*
             case PavilionSection:
             {
             cell = [collectionView dequeueReusableCellWithReuseIdentifier:PavilionCellIdentifier forIndexPath:indexPath];
             [self configCategoryCell:cell indexPath:indexPath];
             }
             case HotProductSection:
             {
             cell = [collectionView dequeueReusableCellWithReuseIdentifier:HotProductIdentifier forIndexPath:indexPath];
             [self configPavilionCell:cell indexPath:indexPath];
             }
             break;
             case BandSection:
             {
             cell = [collectionView dequeueReusableCellWithReuseIdentifier:BandCellIdentifier forIndexPath:indexPath];
             [self configBandCell:cell indexPath:indexPath];
             }
             break;
             case LatestBuySection:
             {
             cell = [collectionView dequeueReusableCellWithReuseIdentifier:LatestBuyIdentifier forIndexPath:indexPath];
             [self configHotPlateCell:cell indexPath:indexPath];
             }
             break;
             */
        default:
            break;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView  = nil;
    switch (indexPath.section) {
        case BannerSection:
        {
            reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BlankReuseViewIdentifier forIndexPath:indexPath];
            reusableView.backgroundColor = RGBCOLOR(234, 234, 234);
        }
            break;
            /*
             case PavilionSection:
             {
             if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
             reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:TitleHeadViewIdentifier forIndexPath:indexPath];
             ((HomePageTitleHeadView *)reusableView).titleLabel.text = @"产业带";
             }
             else{
             reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BlankReuseViewIdentifier forIndexPath:indexPath];
             reusableView.backgroundColor = RGBCOLOR(234, 234, 234);
             }
             }
             break;
             case HotProductSection:
             {
             if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
             reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:TitleHeadViewIdentifier forIndexPath:indexPath];
             ((HomePageTitleHeadView *)reusableView).titleLabel.text = @"热门板块";
             }
             else{
             reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BlankReuseViewIdentifier forIndexPath:indexPath];
             reusableView.backgroundColor = RGBCOLOR(234, 234, 234);
             }
             }
             break;
             case BandSection:
             {
             if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
             reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:TitleHeadViewIdentifier forIndexPath:indexPath];
             ((HomePageTitleHeadView *)reusableView).titleLabel.text = @"产业带";
             }
             else{
             reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BlankReuseViewIdentifier forIndexPath:indexPath];
             reusableView.backgroundColor = RGBCOLOR(234, 234, 234);
             }
             }
             break;
             case LatestBuySection:
             {
             if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
             reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:TitleHeadViewIdentifier forIndexPath:indexPath];
             ((HomePageTitleHeadView *)reusableView).titleLabel.text = @"产业带";
             }
             else{
             reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BlankReuseViewIdentifier forIndexPath:indexPath];
             reusableView.backgroundColor = RGBCOLOR(234, 234, 234);
             }
             }
             break;
             */
        default:
            break;
    }
    return reusableView;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    switch (indexPath.section) {
        case BannerSection:
        {
            size = CGSizeMake(kMainScreenWidth, 200 * kRatio);
        }
            break;
        case PavilionSection:
        {
            CGFloat width = kMainScreenWidth / 4.0;
            size = CGSizeMake(width, width * 0.95);
        }
            break;
        case HotProductSection:
        {
            size = CGSizeMake(kMainScreenWidth, 56 * _ratio);
        }
            break;
        case BandSection:
        {
            size = CGSizeMake(kMainScreenWidth, 85 * _ratio);
        }
            break;
        case LatestBuySection:
        {
            CGFloat width = (kMainScreenWidth - 15) / 3.0;
            size = CGSizeMake(width, width);
        }
            break;
        default:
            break;
    }
    return size;
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
