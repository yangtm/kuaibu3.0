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
#import "AdvertModel.h"
#import "BannerDetailViewController.h"
#import "HomePagePavilionCell.h"
#import "PavilionModel.h"
#import "UIImageView+WebCache.h"

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
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) PageIndex *pageIndex;
@property (assign, nonatomic) CGFloat ratio;
@end

@implementation HomeMainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.ratio = kMainScreenWidth / 320;
    self.pageIndex = [[PageIndex alloc]init];
    self.collectionView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64);
    [self registerCell];
    [self.view addSubview:self.collectionView];
    
    //[self addPullToRefresh];
    [self reloadData];
}

#pragma mark - setters and getters
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor yellowColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}

- (void)reloadData
{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"001" forKey:@"advertSpaceNumber"];
    
    NSString *adverturl= nil;
    kYHBRequestUrl(@"index", adverturl);
    //NSLog(@"%@",adverturl);
    //kYHBRequestUrl(@"index", adverturl);
    [NetworkService postWithURL:adverturl paramters:dic success:^(NSData *receiveData) {
        if (receiveData.length>0) {
            id result=[NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
//            NSLog(@"result=%@",result);
            if([result isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *allresult=result;
                NSDictionary *dictionary = allresult[@"RESULT"];
                NSArray *adverts = dictionary[@"adverts"];
                NSArray *pavilions = dictionary[@"stores"];
//                NSLog(@"store=%@",pavilions);
                NSArray *hotProduct = dictionary[@"products"];
                NSArray *bands = dictionary[@"industry"];
                NSArray *latestBuy = dictionary[@"procurement"];
                self.pageIndex.banners = adverts;
                self.pageIndex.pavilions = pavilions;
                self.pageIndex.hotProduct = hotProduct;
                self.pageIndex.bands = bands;
                self.pageIndex.latestBuy = latestBuy;
                [self.collectionView reloadData];
            }
        }
    }failure:^(NSError *error){
        NSLog(@"下载数据失败");
    }];
}

- (void)configBannerCell:(UICollectionViewCell *)cell
{
    if (_pageIndex.banners == nil) {
        return;
    }
    NSMutableArray *mutableArary = [NSMutableArray array];
    for (NSDictionary *item in _pageIndex.banners) {
        //NSLog(@"item=%@",item);
        AdvertModel *advert =[[AdvertModel alloc]init];
        advert.advertImage = item[@"advertImage"];
        advert.advertUrl = item[@"advertUrl"];
        advert.advertTitle = item[@"advertTitle"];
        [mutableArary addObject:advert.advertImage];
    }
    HomePageBannerCell *bannerCell = (HomePageBannerCell *)cell;
    bannerCell.bannerView.delegate = self;
    bannerCell.bannerView.isNeedCycle = YES;
    bannerCell.bannerView.autoRoll = YES;
    [bannerCell.bannerView resetUIWithUrlStrArray:mutableArary];
}

- (void) configPavilionCell:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    HomePagePavilionCell *PavilionCell = (HomePagePavilionCell *)cell;
    NSDictionary *item = _pageIndex.pavilions[indexPath.row];
    //NSLog(@"item=%@",item);
    PavilionModel *store = [[PavilionModel alloc]init];
    NSString *url= @"upload/Member";
    NSString *storelogo = [NSString stringWithFormat:@"%@%@",url,item[@"logo"]];
    kZXYRequestUrl(storelogo, store.logo);
    [PavilionCell.pavilionImageView sd_setImageWithURL:[NSURL URLWithString:store.logo]];
}


#pragma mark - YHBBannerDelegate
- (void)touchBannerWithNum:(NSInteger)num
{
    NSDictionary *bannerModel = _pageIndex.banners[num];
    AdvertModel *advert =[[AdvertModel alloc]init];
    advert.advertUrl = bannerModel[@"advertUrl"];
    advert.advertTitle = bannerModel[@"advertTitle"];
    if (![advert.advertUrl isEqual:@""] && advert.advertUrl != nil) {
        [self.homeMainPageViewDelegate advertUrl:advert.advertUrl advertTitle:advert.advertTitle];
    }
}

- (void)registerCell
{
    [self registerCellWithNibName:@"HomePageBannerCell" identifier:BannerCellIdentifier];
    [self registerCellWithNibName:@"HomePagePavilionCell" identifier:PavilionCellIdentifier];
    //[self registerCellWithNibName:@"HomePageHotProductCell" identifier:HotProductIdentifier];
    // [self registerCellWithNibName:@"HomePageBandCell" identifier:BandCellIdentifier];
    // [self registerCellWithNibName:@"HomePageLatestBuyCell" identifier:LatestBuyIdentifier];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"HomePageTitleHeadView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TitleHeadViewIdentifier];
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
    return 2;
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
        /*
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
         */
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
             cell = [collectionView dequeueReusableCellWithReuseIdentifier:BannerCellIdentifier     forIndexPath:indexPath];
             [self configBannerCell:cell];
         }
             break;
 
        case PavilionSection:
         {
             cell = [collectionView dequeueReusableCellWithReuseIdentifier:PavilionCellIdentifier forIndexPath:indexPath];
             [self configPavilionCell:cell indexPath:indexPath];
         }
          /*
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
            }*/
                break;
                /*
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
                size = CGSizeMake(kMainScreenWidth, 150 * kRatio);
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
 
 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
