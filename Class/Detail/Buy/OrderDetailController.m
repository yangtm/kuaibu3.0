//
//  OrderDetailController.m
//  kuaibu
//
//  Created by zxy on 15/9/17.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "OrderDetailController.h"

@interface OrderDetailController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *headerFormView;
@property (nonatomic,strong) UIView *userFormView;
@property (nonatomic,strong) UIView *supplyFormView;

@property (nonatomic,strong) UILabel *orderPriceLabel;
@property (nonatomic,strong) UILabel *freightLabel;
@property (nonatomic,strong) UILabel *userName;
@property (nonatomic,strong) UILabel *userPhone;
@property (nonatomic,strong) UILabel *userAddress;

@property (nonatomic,strong) UILabel *supplyName;
@property (nonatomic,strong) UIImageView *logoImageView;
@property (nonatomic,strong) UILabel *orderTitleLabel;
@property (nonatomic,strong) UILabel *orderNumberLabel;
@property (nonatomic,strong) UILabel *timeLabel;



@end

@implementation OrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self showAlertWithMessage:@"订单生成成功" automaticDismiss:YES];

    [self settitleLabel:@"采购订单详情"];
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(back)];
    self.view.backgroundColor = RGBCOLOR(241, 241, 241);
    [self.view addSubview:self.scrollView];
    [self setupFormView];
    [self.scrollView addSubview:self.headerFormView];
    [self.scrollView addSubview:self.userFormView];
    [self.scrollView addSubview:self.supplyFormView];
    
}

- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupFormView{
    UIView *view1 = [self headerFormView:CGRectMake(0, 0, kMainScreenWidth, 70)];
    [self.headerFormView addSubview:view1];
    self.headerFormView.frame = CGRectMake(0, 10, kMainScreenWidth, view1.bottom);
    
    UIView *view2 = [self userFormView:CGRectMake(0, 0, kMainScreenWidth, 70)];
    [self.userFormView addSubview:view2];
    self.userFormView.frame = CGRectMake(0, self.headerFormView.bottom + 5, kMainScreenWidth, view2.bottom);
    
    UIView *view3 = [self supplyFormView:CGRectMake(0, 0, kMainScreenWidth, 150)];
    [self.supplyFormView addSubview:view3];
    self.supplyFormView.frame = CGRectMake(0, self.userFormView.bottom + 5, kMainScreenWidth, view3.bottom);
   
}

#pragma mark -headerFormViewUI
- (UIView *)headerFormView:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UIView *topLineView = [[UIView alloc]
                           initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.5)];
    topLineView.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:topLineView];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 5, kMainScreenWidth, 20) title:@"待付款"];
    [view addSubview:label];
    
    UILabel *label1 = [self formTitleLabel:CGRectMake(10, label.bottom, 80, 20) title:@"订单金额 : "];
    [view addSubview:label1];
    
    _orderPriceLabel = [self formTitleLabel:CGRectMake(label1.right, label.bottom, 100, 20) title:@"¥¥¥¥ 元"];
    _orderPriceLabel.textColor = [UIColor redColor];
    [view addSubview:_orderPriceLabel];
    
    UILabel *label2 = [self formTitleLabel:CGRectMake(10, label1.bottom, 60, 20) title:@"运费 : "];
    [view addSubview:label2];
    
    _freightLabel = [self formTitleLabel:CGRectMake(label2.right, label1.bottom, 100, 20) title:@"¥¥¥¥¥ 元"];
    _freightLabel.textColor = [UIColor redColor];
    [view addSubview:_freightLabel];
    [self addBottomLine:view];
    
    return view;
}

#pragma mark - userView
- (UIView *)userFormView:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    UILabel *label = [self formTitleLabel:CGRectMake(10, 10, 50, 20) title:@"收货人 : "];
    [view addSubview:label];
    
    _userName = [self formTitleLabel:CGRectMake(label.right, 10, 100, 20) title:@"XXXX"];
    [view addSubview:_userName];
//    _userName.backgroundColor = kNaviTitleColor;
    _userPhone = [self formTitleLabel:CGRectMake(view.right -140, 10, 100, 20) title:@"13917638167"];
    [view addSubview:_userPhone];
    
    UILabel *label1 = [self formTitleLabel:CGRectMake(10, _userName.bottom + 10,70, 20) title:@"收货地址 : "];
    [view addSubview:label1];
    
    _userAddress = [self formTitleLabel:CGRectMake(label1.right, _userName.bottom + 10, kMainScreenWidth - label1.width - 20, 20) title:@"XXXXXXXXXXXXXX"];
    [view addSubview:_userAddress];
    [self addBottomLine:view];
    
    return view;
}

#pragma mark - supply
- (UIView *)supplyFormView:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label1 = [self formTitleLabel:CGRectMake(10,10, 60, 20) title:@"供应商 : "];
    label1.font = [UIFont boldSystemFontOfSize:16.0f];
    [view addSubview:label1];
    
    _supplyName = [self formTitleLabel:CGRectMake(label1.right + 10, 10, kMainScreenWidth - label1.width - 30, 20) title:@"XXXXXXXXXXXXXX"];
    _supplyName.font = [UIFont boldSystemFontOfSize:16.0f];
    [view addSubview:_supplyName];
    
    _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, _supplyName.bottom + 10, 100, 100)];
    _logoImageView.layer.masksToBounds = YES;
    _logoImageView.layer.cornerRadius = 5;
    _logoImageView.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:_logoImageView];
    
    _orderTitleLabel = [self formTitleLabel:CGRectMake(_logoImageView.right + 10, _supplyName.bottom + 10, kMainScreenWidth - _logoImageView.width - 40, 20) title:@"采购咖啡色窗帘布"];
    [view addSubview:_orderTitleLabel];
    
    [self addBottomLine:view];
    return view;
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

- (UIView *)headerFormView
{
    if (_headerFormView == nil) {
        _headerFormView = [[UIView alloc] initWithFrame:CGRectZero];
        _headerFormView.backgroundColor = [UIColor whiteColor];
    }
    return _headerFormView;
}

- (UIView *)userFormView
{
    if (_userFormView == nil) {
        _userFormView = [[UIView alloc] initWithFrame:CGRectZero];
        _userFormView.backgroundColor = [UIColor whiteColor];
    }
    return _userFormView;
}

- (UIView *)supplyFormView
{
    if (_supplyFormView == nil) {
        _supplyFormView = [[UIView alloc] initWithFrame:CGRectZero];
        _supplyFormView.backgroundColor = [UIColor whiteColor];
    }
    return _supplyFormView;
}

- (UILabel *)formTitleLabel:(CGRect)frame title:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:13];
    label.text = title;
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
