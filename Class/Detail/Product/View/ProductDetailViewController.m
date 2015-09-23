//
//  ProductDetailViewController.m
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/22.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "BannerView.h"

#define kBlankHeight 15
#define kCCellHeight 35
#define kBannerHeight (kMainScreenWidth * 625/1080.0f)

@interface ProductDetailViewController ()<UIScrollViewDelegate,BannerDelegate>
{
    BOOL _isBuy; //yes代表点击了购买 no代表点击了购物车
}
@property (strong, nonatomic) NSString * productID;
@property (assign, nonatomic) double number;
@property (strong, nonatomic) UIButton *backbutton;
@property (strong, nonatomic) BannerView *bannerView;
@property (strong, nonatomic) UIScrollView *scrollView;
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
    NSLog(@"productid=%@",self.productID);
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backbutton];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.bannerView];
    // Do any additional setup after loading the view.
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters and setters
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = kViewBackgroundColor;
        _scrollView.contentSize = CGSizeMake(kMainScreenWidth, 700);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
