//
//  SellerDetailController.m
//  kuaibu
//
//  Created by zxy on 15/9/17.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "SellerDetailController.h"
#import "YHBPictureAdder.h"


@interface SellerDetailController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) YHBPictureAdder *pictureAdder;
@property (nonatomic,strong) UIView *detailFormView;
@property (nonatomic,strong) UILabel *namaLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *freightLabel;
@property (nonatomic,strong) UILabel *isPayFor;
@property (nonatomic,strong) UILabel *totalLabel;
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UITextView *noteview;
@property (nonatomic,strong) UIView *footFormView;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;

@end

@implementation SellerDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settitleLabel:@"报价详情"];
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(back)];
    self.view.backgroundColor = RGBCOLOR(241, 241, 241);
    
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.pictureAdder];
    
    [self.scrollView addSubview:self.detailFormView];
    [self.scrollView addSubview:self.footFormView];
    [self setupFormView];
    [self setFootView];
//    self.footFormView.backgroundColor = [UIColor redColor];
    self.scrollView.contentSize = CGSizeMake(kMainScreenWidth, kMainScreenHeight-64-44 );
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupFormView{
    UIView *view1 = [self namaLabelForm:CGRectMake(0, 0, kMainScreenWidth, 340)];
    [self.detailFormView addSubview:view1];
    self.detailFormView.frame = CGRectMake(0, _pictureAdder.bottom, kMainScreenWidth, 340);
}

- (void)setFootView
{
    UIView *view = [self footViewFrom:CGRectMake(0,0, kMainScreenWidth, 44)];
    [_footFormView addSubview:view];
    _footFormView.frame = CGRectMake(0, kMainScreenHeight -44-64, kMainScreenWidth, 44);
    
}


#pragma mark - detailUI
- (UIView *)namaLabelForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UIView *topLineView = [[UIView alloc]
                           initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.5)];
    topLineView.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:topLineView];
    _namaLabel = [self formTitleLabel:CGRectMake(30, 10, kMainScreenWidth, 40) title:@"采购标题 : XXXXXXX"];
    [view addSubview:_namaLabel];
    
    _priceLabel = [self formTitleLabel:CGRectMake(30, _namaLabel.bottom, kMainScreenWidth, 40) title:@"单价 : $$$$$$ 元"];
    [view addSubview:_priceLabel];
    
    _freightLabel = [self formTitleLabel:CGRectMake(30, _priceLabel.bottom, kMainScreenWidth, 40) title:@"运费 : $$$$$$$ 元"];
    [view addSubview:_freightLabel];
    
    _isPayFor = [self formTitleLabel:CGRectMake(30, _freightLabel.bottom, kMainScreenWidth, 40) title:@"是否到付 : yes/no"];
    [view addSubview:_isPayFor];
    
    _totalLabel = [self formTitleLabel:CGRectMake(0, _isPayFor.bottom, kMainScreenWidth, 50) title:@"合计 : $$$$$$ 元"];
    _totalLabel.textAlignment = NSTextAlignmentCenter;
    _totalLabel.font = [UIFont systemFontOfSize:17];
    [view addSubview:_totalLabel];
    
    _typeLabel = [self formTitleLabel:CGRectMake(30, _totalLabel.bottom, kMainScreenWidth, 40) title:@"货源状态 : 现货／预定"];
    [view addSubview:_typeLabel];
    
    _noteview = [[UITextView alloc] initWithFrame:CGRectMake(30, _typeLabel.bottom, kMainScreenWidth - 60, 65)];
    _noteview.backgroundColor = [UIColor cyanColor];
    _noteview.textColor = [UIColor grayColor];
    _noteview.text = @"备注  : ";
    [view addSubview:_noteview];
    [self addBottomLine:view];
    
    
    return view;
    
}

#pragma mark - footView
- (UIView *)footViewFrom:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(0, 0, kMainScreenWidth/2, view.height);
    [_leftBtn setTitle:@"取消报价" forState:UIControlStateNormal];
    [_leftBtn setTitleColor:kNaviTitleColor forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_leftBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(_leftBtn.right, 12, 1, 20)];
    line.backgroundColor = kNaviTitleColor;
    [view addSubview:line];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(_leftBtn.right, 0, kMainScreenWidth/2, view.height);
    [_rightBtn setTitle:@"联系买家" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:kNaviTitleColor forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_rightBtn];
    
    return view;
}

- (void)clickLeftBtn{
    
}

- (void)clickRightBtn{
    
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

- (YHBPictureAdder *)pictureAdder
{
    if (_pictureAdder == nil) {
        _pictureAdder = [[YHBPictureAdder alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 120) contentController:self];
        _pictureAdder.enableEdit = NO;
        _pictureAdder.enableSaveImage = YES;
    }
    return _pictureAdder;
}

- (UIView *)detailFormView
{
    if (_detailFormView == nil) {
        _detailFormView = [[UIView alloc] initWithFrame:CGRectZero];
        _detailFormView.backgroundColor = [UIColor whiteColor];
    }
    return _detailFormView;
}

- (UIView *)footFormView
{
    if (_footFormView == nil) {
        _footFormView = [[UIView alloc] initWithFrame:CGRectZero];
        _footFormView.backgroundColor = [UIColor whiteColor];
    }
    return _footFormView;
}

- (UILabel *)formTitleLabel:(CGRect)frame title:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:15];
    label.text = title;
    return label;
}


- (void)addBottomLine:(UIView *)view
{
    UIView *lineView = [self lineView:CGRectMake(0, view.height - 0.5, 0, 0)];
    lineView.tag = 102;
    [view addSubview:lineView];
}

- (UIView *)lineView:(CGRect)frame
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, kMainScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    return lineView;
}

@end
