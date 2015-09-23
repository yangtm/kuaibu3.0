//
//  BuyOfferListDetailController.m
//  kuaibu
//
//  Created by zxy on 15/9/16.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "BuyOfferListDetailController.h"

#import "UIImageView+WebCache.h"
#import "OrderSureController.h"

@interface BuyOfferListDetailController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *buyOfferListDetailFormView;
@property (nonatomic,strong) UIImageView *logoImageView;
@property (nonatomic,strong) UILabel *supplyNameLabel;
@property (nonatomic,strong) UIImageView *patternImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *offerLabel;
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UILabel *freightLabel;
@property (nonatomic,strong) UILabel *totalLabel;
@property (nonatomic,strong) UILabel *addressLabel;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UILabel *isPayFor;
@property (nonatomic,strong) UILabel *authenticationLabel;


@end

@implementation BuyOfferListDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settitleLabel:@"报价详情"];
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(back)];
    self.view.backgroundColor = RGBCOLOR(241, 241, 241);
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.buyOfferListDetailFormView];
    [self setupFormView];
    [self showData];
    [self.view addSubview:[self buttonForm:CGRectMake(0, kMainScreenHeight - 44, kMainScreenWidth, 44)]];
    self.scrollView.contentSize = CGSizeMake(kMainScreenWidth, self.buyOfferListDetailFormView.bottom + 60);
}

- (void)showData
{
    NSString *url = nil;
    kYHBRequestUrl(@"procurement/procurementPriceDetail", url);
    NSLog(@"%@",url);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(_buyOfferListDetailId),@"procurementPriceId", nil];
    NSLog(@"%ld",_buyOfferListDetailId);
    [NetworkService postWithURL:url paramters:dic success:^(NSData *receiveData) {
        id result = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = result;
            NSLog(@"dic:%@",dic);
            NSDictionary *subDic = dic[@"RESULT"];
//            [self showAlertWithMessage:dic[@"RESPMSG"] automaticDismiss:YES];
            NSString *url = nil;
            kZXYRequestUrl(subDic[@"logoUrl"], url);
            [_logoImageView sd_setImageWithURL:[NSURL URLWithString:url]];
            NSString *productImageUrl = nil;
            kZXYRequestUrl(subDic[@"productImage"], productImageUrl);
            NSLog(@"%@",productImageUrl);
            [_patternImageView sd_setImageWithURL:[NSURL URLWithString:productImageUrl]];
            _supplyNameLabel.text = subDic[@"supplier"];
            _authenticationLabel.text = subDic[@"authenticationName"];
            _titleLabel.text = [NSString stringWithFormat:@"采购标题 : %@",subDic[@"procurementName"]];
            _offerLabel.text = [NSString stringWithFormat:@"供应商报价 : %@ 元",subDic[@"offer"]];
            _typeLabel.text = [NSString stringWithFormat:@"货源状态 : %@",subDic[@"supplyStatus"]];
            _freightLabel.text = [NSString stringWithFormat:@"运费 : %@ 元",subDic[@"freight"]];
            if ([subDic[@"payFor"]integerValue] == 1) {
                _isPayFor.text = @"是否到付 : 是";
            }else{
                _isPayFor.text = @"是否到付 : 否";
            }
            _totalLabel.text = [NSString stringWithFormat:@"合计 : %@ 元",subDic[@"total"]];
            _addressLabel.text = [NSString stringWithFormat:@"收货地址 : %@",subDic[@"address"]];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 报价详情UI
- (void)setupFormView
{
    UIView *view1 = [self supplierForm:CGRectMake(0, 0, kMainScreenWidth, 160)];
    UIView *view2 = [self detailForm:CGRectMake(0, view1.bottom, kMainScreenWidth, 560)];
//    UIView *view3 = [self buttonForm:CGRectMake(0, view2.bottom, kMainScreenWidth, 44)];
    [self.buyOfferListDetailFormView addSubview:view1];
    [self.buyOfferListDetailFormView addSubview:view2];
//    [self.buyOfferListDetailFormView addSubview:view3];
    self.buyOfferListDetailFormView.frame = CGRectMake(0, 0, kMainScreenWidth, view2.bottom );
}



#pragma mark - supplierUI
- (UIView *)supplierForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = kViewBackgroundColor;
    _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 120, 120)];
    _logoImageView.backgroundColor = [UIColor purpleColor];
    _logoImageView.layer.borderWidth = 5;
    _logoImageView.layer.masksToBounds = YES;
    _logoImageView.layer.cornerRadius = 5;
    [view addSubview:_logoImageView];
    
    _supplyNameLabel = [self formTitleLabel:CGRectMake(_logoImageView.right + 20, 20, kMainScreenWidth - 60 - _logoImageView.width, 20) title:@"供应商名字"];
    _supplyNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    _supplyNameLabel.textColor = [UIColor blackColor];
    [view addSubview:_supplyNameLabel];
    
    UILabel *label1 = [self formTitleLabel:CGRectMake(_logoImageView.right + 20, _supplyNameLabel.bottom + 5, 60, 20) title:@"描述 : "];
    label1.textColor = [UIColor grayColor];
    [view addSubview:label1];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(label1.right-10, _supplyNameLabel.bottom + 7, 65, 23)];
    backImageView.image = [UIImage imageNamed:@"StarsBackground"];
    [view addSubview:backImageView];
    
    UILabel *label2 = [self formTitleLabel:CGRectMake(_logoImageView.right + 20, label1.bottom + 5, 60, 20) title:@"服务 : "];
    label2.textColor = [UIColor grayColor];
    [view addSubview:label2];
    
    UIImageView *backImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(label2.right-10, label1.bottom + 7, 65, 23)];
    backImageView1.image = [UIImage imageNamed:@"StarsBackground"];
    [view addSubview:backImageView1];
    
    UILabel *label3 = [self formTitleLabel:CGRectMake(_logoImageView.right + 20, label2.bottom + 5, 60, 20) title:@"物流 : "];
    label3.textColor = [UIColor grayColor];
    [view addSubview:label3];
    
    UIImageView *backImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(label3.right-10, label2.bottom + 7, 65, 23)];
    backImageView2.image = [UIImage imageNamed:@"StarsBackground"];
    [view addSubview:backImageView2];
    
    
    _authenticationLabel = [self formTitleLabel:CGRectMake(_logoImageView.right + 20, label3.bottom + 5, 100, 20) title:@"认证标识"];
    _authenticationLabel.textColor = kNaviTitleColor;
    _authenticationLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    [view addSubview:_authenticationLabel];
    
    [self addBottomLine:view];
    return view;
}

#pragma mark - detailUI
- (UIView *)detailForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = kViewBackgroundColor;
    _patternImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 20, kMainScreenWidth - 120, 200)];
    _patternImageView.backgroundColor = [UIColor orangeColor];
    _patternImageView.layer.masksToBounds = YES;
    _patternImageView.layer.cornerRadius = 5;
    _patternImageView.image = [UIImage imageNamed:@"快布3［方案二］_39"];
    [view addSubview:_patternImageView];
    
    _titleLabel = [self formTitleLabel:CGRectMake(40, _patternImageView.bottom + 20, kMainScreenWidth, 40) title:@"采购标题 : XXXXXXXXXXXXX"];
    [view addSubview:_titleLabel];
    
    _offerLabel = [self formTitleLabel:CGRectMake(40, _titleLabel.bottom + 5, kMainScreenWidth, 40) title:@"供应商的报价 : $$$$$$$$$$$"];
    [view addSubview:_offerLabel];
    
    _typeLabel = [self formTitleLabel:CGRectMake(40, _offerLabel.bottom + 5, kMainScreenWidth, 40) title:@"货源状态 : 现货／期货"];
    [view addSubview:_typeLabel];
    
    _freightLabel = [self formTitleLabel:CGRectMake(40, _typeLabel.bottom + 5 , kMainScreenWidth, 40) title:@"运费 : $$$$$$$$$$$$$"];
    [view addSubview:_freightLabel];
    
    _isPayFor = [self formTitleLabel:CGRectMake(40, _freightLabel.bottom+5, kMainScreenWidth, 40) title:@"是否到付 : "];
    [view addSubview:_isPayFor];
    
    _totalLabel = [self formTitleLabel:CGRectMake(40, _isPayFor.bottom + 5, kMainScreenWidth, 40) title:@"费用合计 : $$$$$$$$$$$"];
    [view addSubview:_totalLabel];
    
    _addressLabel = [self formTitleLabel:CGRectMake(40, _totalLabel.bottom + 5, kMainScreenWidth, 40) title:@"收货地址 : 只显示省市"];
    [view addSubview:_addressLabel];
    
    [self addBottomLine:view];
    
    return view;
}

#pragma mark - ButtonUI
- (UIView *)buttonForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = KColor;
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBtn setTitle:@"采纳报价" forState:UIControlStateNormal];
//    [_leftBtn setTitleColor:kNaviTitleColor forState:UIControlStateNormal];
    [_leftBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    _leftBtn.frame = CGRectMake(0, 0, kMainScreenWidth/2, 44);
    [_leftBtn addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_leftBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(_leftBtn.right + 1, 12, 1, 20)];
    line.backgroundColor = kNaviTitleColor;
    [view addSubview:line];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setTitle:@"联系卖家" forState:UIControlStateNormal];
    _rightBtn.frame = CGRectMake(line.right, 0, kMainScreenWidth/2, 44);
//    [_rightBtn setTitleColor:kNaviTitleColor forState:UIControlStateNormal];
    [_rightBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    [_rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_rightBtn];
    
    return view;
}

#pragma mark - 点击事件
- (void)clickLeftBtn
{
//    [self showAlertWithMessage:@"生成订单中..." automaticDismiss:YES];
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"订单生成中..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [view show];
    [view dismissWithClickedButtonIndex:1 animated:YES];
//    OrderDetailController *vc = [[OrderDetailController alloc] init];
    OrderSureController *vc = [[OrderSureController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
//     [NSThread sleepForTimeInterval:2.0f];
}

- (void)clickRightBtn
{
    
}

#pragma mark -getter&setter
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64)];
        //        _scrollView.backgroundColor = [UIColor redColor];
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
- (UIView *)buyOfferListDetailFormView
{
    if (_buyOfferListDetailFormView == nil) {
        _buyOfferListDetailFormView = [[UIView alloc] initWithFrame:CGRectZero];
        _buyOfferListDetailFormView.backgroundColor = [UIColor whiteColor];
    }
    return _buyOfferListDetailFormView;
}



- (UILabel *)formTitleLabel:(CGRect)frame title:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:15];
    label.text = title;
    label.textColor = [UIColor grayColor];
    return label;
}

- (void)addBottomLine:(UIView *)view
{
    UIView *lineView = [self lineView:CGRectMake(0, view.height - 0.5, 0, 0)];
    lineView.tag = 101;
    [view addSubview:lineView];
}

- (UIView *)lineView:(CGRect)frame
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, kMainScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    return lineView;
}

@end
