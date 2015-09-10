//
//  BuyDetailViewController.m
//  kuaibu
//
//  Created by zxy on 15/9/10.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "BuyDetailViewController.h"
#import "YHBPictureAdder.h"

@interface BuyDetailViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic, strong) YHBPictureAdder *pictureAdder;
@property (nonatomic, strong) UIView *detailFormView;
@end

@implementation BuyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settitleLabel:@"采购详情"];
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(back)];
    self.view.backgroundColor = RGBCOLOR(241, 241, 241);
    
    [self.view addSubview:_scrollView];
    [_scrollView addSubview:_pictureAdder];
}

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark -getter&setter
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (YHBPictureAdder *)pictureAdder
{
    if (_pictureAdder == nil) {
        _pictureAdder = [[YHBPictureAdder alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 120) contentController:self];
        _pictureAdder.enableEdit = YES;
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

@end
