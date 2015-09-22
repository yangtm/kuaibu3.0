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
#import "HomePageTitleHeadView.h"
#import "HomePageHotProductCell.h"
#import "ProductModel.h"
#import "HomePageBandCell.h"
#import "HomePageLatestBuyCell.h"
#import "SVPullToRefresh.h"
#import "LookSupplyViewController.h"

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

@interface HomeMainPageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,BannerDelegate,HomePageTitleHeadViewDelegate>
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
    self.collectionView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight -150);
    [self registerCell];
    [self.view addSubview:self.collectionView];
    
    [self addPullToRefresh];
    [self reloadData];
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

- (void)reloadData
{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"001" forKey:@"advertSpaceNumber"];
    
    NSString *adverturl= nil;
    kYHBRequestUrl(@"index", adverturl);
    [NetworkService postWithURL:adverturl paramters:dic success:^(NSData *receiveData) {
        if (receiveData.length>0) {
            id result=[NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
            if([result isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *allresult=result;
                NSDictionary *dictionary = allresult[@"RESULT"];
                NSArray *adverts = dictionary[@"adverts"];
                NSArray *pavilions = dictionary[@"stores"];
                NSArray *hotProduct = dictionary[@"products"];
                NSArray *bands = dictionary[@"industry"];
                NSArray *latestBuy = dictionary[@"procurement"];
                //NSLog(@"latesrbuy=%@",pavilions);
                self.pageIndex.banners = adverts;
                self.pageIndex.pavilions = pavilions;
                self.pageIndex.hotProduct = hotProduct;
                self.pageIndex.bands = bands;
                self.pageIndex.latestBuy = latestBuy;
                [_collectionView.pullToRefreshView stopAnimating];
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
    if (_pageIndex.pavilions == nil) {
        return;
    }
    HomePagePavilionCell *PavilionCell = (HomePagePavilionCell *)cell;
    NSDictionary *item = _pageIndex.pavilions[indexPath.row];
    PavilionModel *store = [[PavilionModel alloc]init];
    NSString *storelogo = item[@"logo"];
    kZXYRequestUrl(storelogo, store.logo);
    //NSLog(@"pavilio=%@",store.logo);
    [PavilionCell.pavilionImageView sd_setImageWithURL:[NSURL URLWithString:store.logo]];
}

- (void) configHotProductCell:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (_pageIndex.hotProduct ==nil) {
        return;
    }
    HomePageHotProductCell *ProductCell = (HomePageHotProductCell *)cell;
    NSDictionary *item = _pageIndex.hotProduct[indexPath.row];
    ProductModel *product = [[ProductModel alloc]init];
    NSString *url= item[@"productImage"];
    kZXYRequestUrl(url, product.productImage);
    [ProductCell.pruductImageView sd_setImageWithURL:[NSURL URLWithString:product.productImage]];
    [ProductCell configWithPrice:[NSString stringWithFormat:@"%@",item[@"price"]]];
    ProductCell.titleLabel.text = item[@"productName"];
    ProductCell.attention.text = @"123456";
    //NSLog(@"time=%@",[NSString stringWithFormat:@"%@",item[@"createDatetime"]]);
    ProductCell.time.text = @"11小时前";
    
}
- (void) configBandCell:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (_pageIndex.bands == nil) {
        return;
    }
    HomePageBandCell *bandCell = (HomePageBandCell *)cell;
    NSDictionary *item = _pageIndex.bands[indexPath.row];
    NSString *url= @"upload/Member/";
    NSString *bandlogo = [NSString stringWithFormat:@"%@%@",url,item[@"logo"]];
    NSString *bandurl = nil;
    kZXYRequestUrl(bandlogo, bandurl);
    [bandCell.bandImageView sd_setImageWithURL:[NSURL URLWithString:bandurl]];
}

- (void) configLatestBuyCell:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (_pageIndex.latestBuy == nil) {
        return;
    }
    HomePageLatestBuyCell *buyCell = (HomePageLatestBuyCell *)cell;
    NSDictionary *item = _pageIndex.latestBuy[indexPath.row];
    // NSString *url= @"upload/Member/";
    // NSString *bandlogo = [NSString stringWithFormat:@"%@%@",url,item[@"logo"]];
    // NSString *bandurl = nil;
    //kZXYRequestUrl(bandlogo, bandurl);
    //[bandCell.bandImageView sd_setImageWithURL:[NSURL URLWithString:bandurl]];
    buyCell.pruductImageView.image = [UIImage imageNamed:@"home_Pavilion_1"];
    buyCell.titleLabel.text = @"购买涤纶材质的布匹";
    [buyCell configWithLength:[NSString stringWithFormat:@"%@",item[@"amount"]]];
    
}

- (void)addPullToRefresh
{
    __weak HomeMainPageViewController *weakSelf = self;
    [self.collectionView addPullToRefreshWithActionHandler:^{
                [weakSelf reloadData];
        
    }];
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
    [self registerCellWithNibName:@"HomePageBandCell" identifier:BandCellIdentifier];
    [_collectionView registerClass:[HomePageHotProductCell class]forCellWithReuseIdentifier:HotProductIdentifier];
    [_collectionView registerClass:[HomePageLatestBuyCell class]forCellWithReuseIdentifier:LatestBuyIdentifier];
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
    return 5;
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
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:BannerCellIdentifier     forIndexPath:indexPath];
            [self configBannerCell:cell];
        }
            break;
        case PavilionSection:
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:PavilionCellIdentifier forIndexPath:indexPath];
            [self configPavilionCell:cell indexPath:indexPath];
        }
            break;
        case HotProductSection:
        {
            
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:HotProductIdentifier forIndexPath:indexPath];
            [self configHotProductCell:cell indexPath:indexPath];
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
            [self configLatestBuyCell:cell indexPath:indexPath];
        }
            break;
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
        case PavilionSection:
        {
            if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
                reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:TitleHeadViewIdentifier forIndexPath:indexPath];
                ((HomePageTitleHeadView *)reusableView).titleLabel.text = @"精品店铺";
                ((HomePageTitleHeadView *)reusableView).collectViewNum = PavilionSection;
                ((HomePageTitleHeadView *)reusableView).HomePageTitleHeadViewDelegate = self;
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
                ((HomePageTitleHeadView *)reusableView).titleLabel.text = @"热门商品";
                ((HomePageTitleHeadView *)reusableView).collectViewNum = HotProductSection;
                ((HomePageTitleHeadView *)reusableView).HomePageTitleHeadViewDelegate = self;
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
                ((HomePageTitleHeadView *)reusableView).collectViewNum = BandSection;
                ((HomePageTitleHeadView *)reusableView).HomePageTitleHeadViewDelegate = self;
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
                ((HomePageTitleHeadView *)reusableView).titleLabel.text = @"最新采购";
                ((HomePageTitleHeadView *)reusableView).collectViewNum = LatestBuySection;
                ((HomePageTitleHeadView *)reusableView).HomePageTitleHeadViewDelegate = self;
            }
            else{
                reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BlankReuseViewIdentifier forIndexPath:indexPath];
                reusableView.backgroundColor = RGBCOLOR(234, 234, 234);
            }
        }
            break;
        default:
            break;
    }
    return reusableView;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
        {
            NSLog(@"点击店铺");
        }
            break;
        case 2:
        {
            NSLog(@"点击商品");
        }
            break;
        case 3:
        {
            NSLog(@"点击产业带");
            //TODO 产业带界面
            //            [self addMerchantView];
            /*
             YHBBandModel *band = _pageIndex.bands[indexPath.row];
             IndustrialBeltViewController *vc = [[IndustrialBeltViewController alloc] initWithTitle:band.title itemId:band.itemId];
             vc.hidesBottomBarWhenPushed = YES;
             [self.navigationController pushViewController:vc animated:YES];
             */
        }
            break;
        case 4:
        {
            //TODO 热门板块界面
            /*
             HotPartsViewController *hotParts = [[HotPartsViewController alloc] initWithNibName:@"HotPartsViewController" bundle:nil];
             hotParts.hotPlateModel = _pageIndex.hotPlates[indexPath.row];
             hotParts.hidesBottomBarWhenPushed = YES;
             [self.navigationController pushViewController:hotParts animated:YES];
             */
        }
            break;
            
        default:
            break;
    }
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        //        HomePagePavilionCell *pavilionCell = (HomePagePavilionCell *)cell;
        //        [pavilionCell startRoll];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        //        HomePagePavilionCell *pavilionCell = (HomePagePavilionCell *)cell;
        //        [pavilionCell stopRoll];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    switch (indexPath.section) {
        case BannerSection:
        {
            size = CGSizeMake(kMainScreenWidth, 120 * kRatio);
        }
            break;
        case PavilionSection:
        {
            CGFloat width = (kMainScreenWidth - 15) / 4.0;
            size = CGSizeMake(width, width - 10);
        }
            break;
        case HotProductSection:
        {
            CGFloat width = (kMainScreenWidth - 15) / 2.0;
            size = CGSizeMake(width, width - 100);
        }
            break;
        case BandSection:
        {
            CGFloat width = (kMainScreenWidth - 15) / 3.0;
            size = CGSizeMake(width, width);
        }
            break;
        case LatestBuySection:
        {
            CGFloat width = (kMainScreenWidth - 20) / 3.0;
            size = CGSizeMake(width, width+50);
        }
            break;
        default:
            break;
    }
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = CGSizeMake(0, 0);
    switch (section) {
        case BannerSection:
        {
            
        }
            break;
        case PavilionSection:
        {
            size = CGSizeMake(kMainScreenWidth, 30);
        }
            break;
        case HotProductSection:
        {
            size = CGSizeMake(kMainScreenWidth, 30);
        }
            break;
        case BandSection:
        {
            size = CGSizeMake(kMainScreenWidth, 30);
        }
            break;
        case LatestBuySection:
        {
            size = CGSizeMake(kMainScreenWidth, 30);
        }
            break;
        default:
            break;
    }
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size = CGSizeMake(0, 0);
    switch (section) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            size = CGSizeMake(kMainScreenWidth, 5);
        }
            break;
        case 2:
        {
            size = CGSizeMake(kMainScreenWidth, 5);
        }
            break;
        case 3:
        {
            size = CGSizeMake(kMainScreenWidth, 5);
        }
            break;
        case 4:
        {
            size = CGSizeMake(kMainScreenWidth, 5);
        }
            break;
            
        default:
            break;
    }
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat space = 0;
    switch (section) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            space = 4.f;
        }
            break;
        case 2:
        {
            space = 4.f;
        }
            break;
        case 3:
        {
            space = 4.f;
        }
            break;
        case 4:
        {
            space = 4.f;
        }
            break;
        default:
            break;
    }
    return space;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat space = 0;
    switch (section) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            space = 0.f;
        }
            break;
        case 2:
        {
            space = 0.f;
        }
            break;
        case 3:
        {
            space = 0.f;
        }
            break;
        case 4:
        {
            space = 0.f;
        }
            break;
        default:
            break;
    }
    return space;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    if (section == 1) {
        edgeInsets = UIEdgeInsetsMake(2, 4, 5, 4);
    }
    else if (section == 2){
        edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    else if (section == 3){
        edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    else if (section == 4){
        edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    return edgeInsets;
}

-(void)selectTag:(NSInteger ) tag
{
    switch (tag) {
        case 1:
            NSLog(@"精品店铺列表");
            break;
        case 2:
            if ([_homeMainPageViewDelegate respondsToSelector:@selector(selectBtn:)]) {
                [_homeMainPageViewDelegate selectBtn:2];
            }
            break;
        case 3:
            NSLog(@"产业带列表");
            break;
        case 4:
        {
            if ([_homeMainPageViewDelegate respondsToSelector:@selector(selectBtn:)]) {
                [_homeMainPageViewDelegate selectBtn:4];
            }
        }
            break;
        default:
            break;
    }
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
