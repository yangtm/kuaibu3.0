//
//  ProductDetailViewController.m
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/22.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "BannerView.h"
#import "ProductModel.h"
#import "YHBPdtInfoView.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "YHBProductWebVC.h"
#import "YHBSelNumColorView.h"
#import "FXBlurView.h"
#import "YHBBuytoolBarView.h"
#import "YHBCommentCellView.h"
#import "YHBConnectStoreVeiw.h"
#import "SVProgressHUD.h"
#define kBlankHeight 15
#define kCCellHeight 35
#define kBannerHeight (kMainScreenWidth * 625/1080.0f)

@interface ProductDetailViewController ()<UIScrollViewDelegate,BannerDelegate,MWPhotoBrowserDelegate,YHBSelViewDelegate,YHBConStoreDelegate>
{
    CGFloat _currentY;
    BOOL _isBuy; //yes代表点击了购买 no代表点击了购物车
}
@property (strong, nonatomic) NSString * productID;
@property (assign, nonatomic) double number;
@property (strong, nonatomic) UIButton *backbutton;
@property (strong, nonatomic) BannerView *bannerView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) ProductModel *productModel;
@property (strong, nonatomic) YHBPdtInfoView *infoView;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) YHBProductWebVC *webVc;
@property (weak, nonatomic) UIView *selectCell;
@property (weak, nonatomic) UILabel *selectColorLabel;
@property (strong, nonatomic) YHBSelNumColorView *selView;
@property (strong, nonatomic) YHBSku *selSku;
@property (strong, nonatomic) FXBlurView *blurView;
@property (strong, nonatomic) YHBBuytoolBarView *toolBarView;
@property (weak, nonatomic) UIView *commentHead;
@property (strong, nonatomic) YHBConnectStoreVeiw *conStoreView;
@end

@implementation ProductDetailViewController

- (instancetype)initWithProductID:(NSString *)productID
{
    self = [super init];
    if (self) {
        self.productID = productID;
        self.title = @"产品详情";
        _number = 1;
        
    }
    return self;
}

-(void)back
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
   // NSLog(@"productid=%@",self.productID);
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backbutton];
    self.view.backgroundColor = [UIColor whiteColor];
    self.productModel = [[ProductModel alloc]init];
    self.conStoreView = [[YHBConnectStoreVeiw alloc] init];
    self.conStoreView.delegate = self;
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.bannerView];
    self.infoView = [[YHBPdtInfoView alloc] init];
    self.infoView.top = self.bannerView.bottom;
    UITapGestureRecognizer *tp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchProductDetailCell)];
    [self.infoView addGestureRecognizer:tp];
    [self.scrollView addSubview:self.infoView];
    [self reloadData];
    self.toolBarView = [[YHBBuytoolBarView alloc] init];
    self.toolBarView.top = self.scrollView.bottom;
    [self.toolBarView.cartButton addTarget:self action:@selector(touchCartButton) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBarView.addButton addTarget:self action:@selector(touchAddButton) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBarView.privateButton addTarget:self action:@selector(touchPrivateBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.toolBarView];
    [self creatSelectColorCell];
}

-(void)reloadData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.productID forKey:@"productId"];
    NSString *adverturl= nil;
    kYHBRequestUrl(@"product/open/productDetail", adverturl);
    [NetworkService postWithURL:adverturl paramters:dic success:^(NSData *receiveData) {
        if (receiveData.length>0) {
            id result=[NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"产品详情＝%@",result);
            if([result isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dictionary = result[@"RESULT"];
               [self.productModel setValuesForKeysWithDictionary:dictionary];
               [self refreshAddView];
               [self creatAddressCell];
               [self creatSimpleCell];
               [self.infoView setTitle:self.productModel.productName price:self.productModel.price sale:@"暂无"];
               [self creatCommentHead];
               [self creatCommentCells];
                self.commentHead.frame = CGRectMake(0, self.infoView.bottom +128 , kMainScreenWidth, kCCellHeight);
                //_currentY = self.commentHead.bottom;
                
                //NSLog(@"_currentY=%f",_currentY);
                self.conStoreView.frame = CGRectMake(0, _currentY+=kBlankHeight, self.conStoreView.width,self.conStoreView.height);
                NSString *bandurl = nil;
                kZXYRequestUrl(self.productModel.storeLogo, bandurl);
                [self.conStoreView setUIWithTitle:self.productModel.storeName imageUrl:bandurl attention:@"1111"];
                //self.conStoreView.backgroundColor = [UIColor blackColor];
                [self.scrollView addSubview:self.conStoreView];
                _currentY = self.conStoreView.bottom;
                
                [self creatConnectCell];
            }
        }
    }failure:^(NSError *error){
        NSLog(@"下载数据失败");
    }];
}

//载入banners的网络数据
- (void)refreshAddView
{
    NSInteger count=self.productModel.productImageList.count;
    NSString *bandurl = nil;
    NSMutableArray *array = [NSMutableArray array];
     for (NSInteger i = 0; i < count ; i++) {
         NSString *url=self.productModel.productImageList[i][@"imageUrl"];
         kZXYRequestUrl(url, bandurl);
         [array addObject:bandurl];
    }
    self.bannerView.isNeedCycle = NO;
    [self.bannerView resetUIWithUrlStrArray:[NSArray arrayWithArray:array]];
}

#pragma mark 点击head的Banner
- (void)touchBannerWithNum:(NSInteger)num;
{
    if (self.photos == nil) {
        self.photos = [NSMutableArray array];
        self.photos = [NSMutableArray arrayWithCapacity:5];
        NSInteger imageNum = self.productModel.productImageList.count;
        for (NSInteger i = 0; i < imageNum; i++) {
            NSString *url=self.productModel.productImageList[i][@"imageUrl"];
            NSString *bandurl = nil;
            kZXYRequestUrl(url, bandurl);
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:bandurl?:@""]];
            self.photos[i] = photo;
        }
    }
    [self showPhotoBrownserWithIndex:num];
}

#pragma mark - 照片浏览
- (void)showPhotoBrownserWithIndex:(NSInteger)num
{
    BOOL displayActionButton = NO;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;//分享按钮,默认是
    browser.displayNavArrows = displayNavArrows;//左右分页切换,默认否
    browser.displaySelectionButtons = displaySelectionButtons;//是否显示选择按钮在图片上,默认否
    browser.alwaysShowControls = displaySelectionButtons;//控制条件控件 是否显示,默认否
    browser.zoomPhotosToFill = NO;//是否全屏,默认是
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;//是否全屏
#endif
    browser.enableGrid = enableGrid;//是否允许用网格查看所有图片,默认是
    browser.startOnGrid = startOnGrid;//是否第一张,默认否
    browser.enableSwipeToDismiss = YES;
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    [browser setCurrentPhotoIndex:num];
    [self.navigationController pushViewController:browser animated:NO];
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id )photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (void)creatSelectColorCell
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.infoView.bottom +2, kMainScreenWidth, 40)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (view.height-kTitlefont)/4.0, kMainScreenWidth-20, 30)];
    textLabel.font = [UIFont systemFontOfSize:kTitlefont];
    textLabel.text = @"规格";
    textLabel.textColor = [UIColor blackColor];
    [view addSubview:textLabel];
  //  self.selectCell = view;
  //  self.selectColorLabel = textLabel;
    UITapGestureRecognizer *tp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchSelectColorCell)];
    [view addGestureRecognizer:tp];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth-25, view.height/2.0 - 9.5, 20, 20)];
    arrowImageView.image = [UIImage imageNamed:@"iconfont-nextpage"];
    [arrowImageView setContentMode:UIViewContentModeScaleAspectFit];
    [view addSubview:arrowImageView];
    _currentY = view.bottom;
    [self.scrollView addSubview:view];
}

-(void)creatAddressCell
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.infoView.bottom +44,kMainScreenWidth , 40)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, (view.height-kTitlefont)/4.0, kMainScreenWidth, 30)];
    textLabel.font = [UIFont systemFontOfSize:kTitlefont];
    textLabel.text = @"发货地  上海";
    textLabel.textColor = [UIColor blackColor];
    [view addSubview:textLabel];
    _currentY = view.bottom;
    [self.scrollView addSubview:view];
    
}

-(void)creatSimpleCell
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.infoView.bottom +86,kMainScreenWidth , 40)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, (view.height-kTitlefont)/4.0, kMainScreenWidth, 30)];
    textLabel.font = [UIFont systemFontOfSize:kTitlefont];
    //NSLog(@"issample=%@",self.productModel.isSample);
    if ([self.productModel.isSample integerValue]) {
        textLabel.text = @"提示  不提供剪样";
    }else
    {
        textLabel.text = @"提示  提供剪样";
    }
    textLabel.textColor = [UIColor blackColor];
    [view addSubview:textLabel];
    _currentY = view.bottom;
    [self.scrollView addSubview:view];
}

-(void)creatConnectCell
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, _currentY+=kBlankHeight,kMainScreenWidth , 30)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, kMainScreenWidth, 30)];
    textLabel.font = [UIFont systemFontOfSize:kTitlefont];
    textLabel.text = @"联系卖家";
    textLabel.textColor = [UIColor blackColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:textLabel];
    UITapGestureRecognizer *tp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchConnectStoreBtn)];
    [view addGestureRecognizer:tp];
    _currentY = view.bottom;
    [self.scrollView addSubview:view];
}

- (void)creatCommentHead
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _currentY+kBlankHeight, kMainScreenWidth,40)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (view.height-kTitlefont)/2.0, kMainScreenWidth-20, kTitlefont)];
    textLabel.font = [UIFont systemFontOfSize:kTitlefont];
    textLabel.text = @"产品评价";
    textLabel.textColor = [UIColor blackColor];
    [view addSubview:textLabel];
    [self.scrollView addSubview:view];
    _commentHead = view;
    _currentY = view.bottom;
}

- (void)creatCommentCells
{
//    if(self.productModel.comment.count){
//        YHBComment *comment;
//        for (int i=0; i < self.productModel.comment.count; i++) {
//            comment = self.productModel.comment[i];
//            YHBCommentCellView *cellView = [[YHBCommentCellView alloc] init];
//            cellView.top = _currentY + 1;
//            [cellView setUIWithName:comment.truename image:comment.avatar comment:comment.comment date:comment.adddate];
//            [self.scrollView addSubview:cellView];
//            _currentY = cellView.bottom;
//        }
//        if (self.productModel.comment.count >= 2) {
//            UIView *moreVeiw = [[UIView alloc] initWithFrame:CGRectMake(0, _currentY+1, kMainScreenWidth, 30)];
//            moreVeiw.backgroundColor = [UIColor whiteColor];
//            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake((kMainScreenWidth-100)/2.0, (moreVeiw.height-13)/2.0, 100, 13)];
//            textLabel.textColor = [UIColor blackColor];
//            textLabel.font = kFont12;
//            textLabel.text = @"查看更多评价";
//            [moreVeiw addSubview:textLabel];
//            [self.scrollView addSubview:moreVeiw];
//            UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchMoreComment)];
//            [moreVeiw addGestureRecognizer:gr];
//            _currentY = moreVeiw.bottom;
//        }
//    }else{
        YHBCommentCellView *cellView = [[YHBCommentCellView alloc] init];
        cellView.top = _currentY -15;
        [cellView isNoComment];
        [self.scrollView addSubview:cellView];
        _currentY = cellView.bottom;
//    }
}

#pragma mark 点击查询店铺详情
- (void)touchShopDetailCell
{
    NSLog(@"点击进入店铺详情页");
//    YHBStoreViewController *vc = [[YHBStoreViewController alloc] initWithShopID:(int)self.productModel.userid];
//    //    YHBStoreDetailViewController *vc = [[YHBStoreDetailViewController alloc] initWithItemID:self.productID];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 点击联系卖家
- (void)touchConnectStoreBtn
{
    NSLog(@"联系卖家");
//    if (self.productModel && [YHBUser sharedYHBUser].isLogin && ([YHBUser sharedYHBUser].userInfo.userid != _productModel.userid)) {
//        NSString *sellerName = self.productModel.truename;//姓名
//        double userID = self.productModel.userid;//用户id
//        double productID = self.productModel.itemid;//产品id
//        NSString *productTitle = self.productModel.title;//产品title
//        NSString *imageUrlStr = ((YHBAlbum *)(self.productModel.album.firstObject)).middle;//图片url str
//        
//        ChatViewController *vc = [[ChatViewController alloc] initWithChatter:[NSString stringWithFormat:@"%d", (int)userID] userid:(int)userID itemid:(int)productID ImageUrl:imageUrlStr Title:productTitle andType:@"product" andChatterAvatar:self.productModel.avatar];
//        vc.title = sellerName;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    else if (self.productModel && ![YHBUser sharedYHBUser].isLogin){
//        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginForUserMessage object:[NSNumber numberWithBool:NO]];
//    }
}


#pragma mark 点击查看产品详情
- (void)touchProductDetailCell
{
    if (self.productModel.productDesc.length) {
        [self.navigationController pushViewController:self.webVc animated:YES];
        [self.webVc sethtmlStr:self.productModel.productDesc];
    }else{
        [SVProgressHUD showErrorWithStatus:@"没有产品详情" cover:YES offsetY:0];
    }
}

#pragma mark 点击选择色块
- (void)touchSelectColorCell
{
    if (self.productModel) {
        [self showSkuView];
    }
}

#pragma mark selView dismiss
- (void)selViewShouldDismissWithSelNum:(double)num andSelSku:(YHBSku *)sku
{
    self.selSku = sku;
    self.number = num;
    [self dismissSkuView];
}

#pragma mark 点击购物车

- (void)touchCartButton
{
    NSLog(@"点击进去购物车");
}

- (void)touchAddButton
{
    if (self.productModel) {
        [self showSkuView];
    }
}

- (void)touchPrivateBtn:(UIButton *)sender
{
    NSLog(@"点击收藏");
}


- (void)dismissSkuView
{
    [UIView animateWithDuration:0.2f animations:^{
        self.selView.top = kMainScreenHeight;
    } completion:^(BOOL finished) {
        self.selView.selSku = nil;
        self.selView.number = 1;
        [self.selView removeFromSuperview];
        
        [UIView animateWithDuration:0.2f animations:^{
            
            self.blurView.alpha = 0;
            
        } completion:^(BOOL finished) {
            self.blurView.alpha = 1;
            [self.blurView removeFromSuperview];
        }];
    }];
}

- (void)selViewShouldPushViewController:(UIViewController *)vc
{
    LSNavigationController *nav = [[LSNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:NO completion:^{
        
    }];
}

- (void)showSkuView
{
    if (!_selView) {
        _selView = [[YHBSelNumColorView alloc] initWithProductModel:self.productModel];
        _selView.delegate = self;
        [_selView setUnit:self.productModel.unit];
    }
    _selView.top = kMainScreenHeight;
    _selView.selSku = self.selSku;
    [_selView registerForKeyboradNotifications];
    
    [self.view addSubview:self.blurView];
    [self.blurView setNeedsDisplay];
    
    [self.view addSubview:_selView];
    [UIView animateWithDuration:0.6f animations:^{
        _selView.bottom =_selView.bottom - _selView.height;
    } completion:^(BOOL finished) {
    }];
}

- (UIButton *)backbutton
{
    if (_backbutton == nil) {
        _backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backbutton.frame = CGRectMake(0, 0, 30, 30);
        [_backbutton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        _backbutton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_backbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backbutton;
}

- (YHBProductWebVC *)webVc
{
    if (!_webVc) {
        _webVc = [[YHBProductWebVC alloc] init];
    }
    return _webVc;
}

- (FXBlurView *)blurView
{
    if (_blurView == nil) {
        _blurView = [[FXBlurView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - self.toolBarView.height - 64)];
        _blurView.blurRadius = 20;
        [_blurView setTintColor:[UIColor clearColor]];
        _blurView.dynamic = NO;
    }
    return _blurView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters and setters
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight -55)];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = kViewBackgroundColor;
        _scrollView.contentSize = CGSizeMake(kMainScreenWidth, 720);
    }
    return _scrollView;
}

- (BannerView *)bannerView
{
    if (_bannerView == nil) {
        _bannerView = [[BannerView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kBannerHeight)];
        _bannerView.delegate = self;
    }
    return _bannerView;
}

@end
