//
//  HomeMainPageViewController.m
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/8.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "HomeMainPageViewController.h"
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

@interface HomeMainPageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,BannerDelegate>
//@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) PageIndex *pageIndex;

@end

@implementation HomeMainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //self.collectionView.frame = CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight - 64);
    //[self registerCell];
    //[self.view addSubview:self.collectionView];
}
/*
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
