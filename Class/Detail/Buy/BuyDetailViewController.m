//
//  BuyDetailViewController.m
//  kuaibu
//
//  Created by zxy on 15/9/10.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "BuyDetailViewController.h"
#import "YHBPictureAdder.h"

#define kBottomLineTag 99
@interface BuyDetailViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic, strong) YHBPictureAdder *pictureAdder;
@property (nonatomic, strong) UIView *detailFormView;

@property (nonatomic,strong) UILabel *nameLabel;
@end

@implementation BuyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settitleLabel:@"采购详情"];
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(back)];
    self.view.backgroundColor = RGBCOLOR(241, 241, 241);
    
    [self.view addSubview:self.scrollView];

    [self.scrollView addSubview:self.pictureAdder];

    [self.scrollView addSubview:self.detailFormView];
    self.scrollView.contentSize = CGSizeMake(kMainScreenWidth, _detailFormView.bottom + 20);
    [self setupFormView];
}

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UI
- (void)setupFormView
{
    UIView *view1 = [self productNameForm:CGRectMake(0, 0, kMainScreenWidth, 60)];
    UIView *view2 = [self typeForm:CGRectMake(0, view1.bottom, kMainScreenWidth, 40)];
    [_detailFormView addSubview:view1];
    [_detailFormView addSubview:view2];
    _detailFormView.frame = CGRectMake(0, self.pictureAdder.bottom, kMainScreenWidth, view2.bottom);
}

#pragma mark -标题UI
- (UIView *)productNameForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    UIView *topLineView = [[UIView alloc]
                           initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.5)];
    topLineView.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:topLineView];
    UILabel *nameLabel = [self formTitleLabel:CGRectMake(10, topLineView.bottom+10, 80 , 18) title:@"商品名"];
//    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, topLineView.bottom+10, kMainScreenWidth-80, 18)];
//    nameLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:nameLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom+10, 130, 15)];
    timeLabel.font = kFont12;
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.text = @"发布时间 : ";
    [view addSubview:timeLabel];
    [self addBottomLine:view];
    return view;
}

#pragma mark - 状态UI
- (UIView *)typeForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 80, view.height) title:@"状态："];
    [view addSubview:label];
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

- (UILabel *)formTitleLabel:(CGRect)frame title:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:15];
    label.text = title;
    [self shadedStar:label];
    return label;
}

- (void) shadedStar:(UILabel *)label
{
    if ([label.text hasPrefix:@"*"]) {
        NSMutableAttributedString *attrubuteStr = [[NSMutableAttributedString alloc] initWithString:label.text];
        [attrubuteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
        [attrubuteStr addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:-2.0] range:NSMakeRange(0, 1)];
        label.attributedText = attrubuteStr;
    }
}

- (void)addBottomLine:(UIView *)view
{
    UIView *lineView = [self lineView:CGRectMake(0, view.height - 0.5, 0, 0)];
    lineView.tag = kBottomLineTag;
    [view addSubview:lineView];
}

- (UIView *)lineView:(CGRect)frame
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, kMainScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    return lineView;
}
@end
