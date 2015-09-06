//
//  MineHeadView.m
//  YHB_Prj
//
//  Created by 童小波 on 15/5/18.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "MineHeadView.h"
#import "UIImageView+WebCache.h"
#import "UIViewAdditions.h"
#import "Public.h"

@interface MineHeadView()

@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) NSArray *buttonTitles;
@property (strong, nonatomic) NSMutableArray *footItemLabelArray;

@end

@implementation MineHeadView

- (instancetype)initWithFrame:(CGRect)frame type:(MineHeadViewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        if (_type == MineHeadViewTypeBuyer) {
            self.buttonTitles = @[@"待付款", @"待发货", @"待收货", @"退款中"];
        }
        else if (_type == MineHeadViewTypeSeller){
            self.buttonTitles = @[@"待付款", @"待发货", @"待确认收货", @"退款中"];
        }
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _backgroudImageView.frame = self.bounds;
    if (self.type != MineHeadViewTypeWithTitle) {
        _portraitImageView.frame = CGRectMake(self.width / 2.0 - 40.0, 30, 60, 60);
        _nameLabel.frame = CGRectMake(_portraitImageView.left - 60, _portraitImageView.bottom + 10, _portraitImageView.width + 120, 20);
    }
    else{
        _titleImageView.frame = CGRectMake(0, 60, self.width, 45);
    }
    _footerView.frame = CGRectMake(0, self.bottom - 55, self.width, 55);
}

- (void)setup
{
    self.footItemLabelArray = [NSMutableArray array];
    [self addSubview:self.backgroudImageView];
    if (self.type != MineHeadViewTypeWithTitle) {
        [self addSubview:self.portraitImageView];
        [self addSubview:self.nameLabel];
    }
    else{
        [self addSubview:self.titleImageView];
    }
    [self addSubview:self.footerView];
    
    self.backgroudImageView.image = [UIImage imageNamed:@"userBannerDefault"];
    self.portraitImageView.backgroundColor = [UIColor whiteColor];
}

- (void)tapPortraitHandle:(UITapGestureRecognizer *)tap
{
    if ([_delegate respondsToSelector:@selector(mineHeadViewPortraitDidTap:)]) {
        [_delegate mineHeadViewPortraitDidTap:self];
    }
}

- (void)itemButtonClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(mineHeadViewButtonDidTap:buttonNum:)]) {
        [_delegate mineHeadViewButtonDidTap:self buttonNum:button.tag - 10];
    }
}

- (UIButton *)customButtonFrame:(CGRect)rect title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    button.backgroundColor = [UIColor clearColor];
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 30)];
    numLabel.textColor = [UIColor whiteColor];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.font = [UIFont systemFontOfSize:18.0];
    numLabel.text = @"-";
    [self.footItemLabelArray addObject:numLabel];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, numLabel.bottom, numLabel.width, 20)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.text = title;
    [button addSubview:numLabel];
    [button addSubview:titleLabel];
    [button addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - setters and getters
- (UIImageView *)backgroudImageView
{
    if (_backgroudImageView == nil) {
        _backgroudImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backgroudImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroudImageView;
}

- (UIImageView *)portraitImageView
{
    if (_portraitImageView == nil) {
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _portraitImageView.layer.cornerRadius = 30.0;
        _portraitImageView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPortraitHandle:)];
        [_portraitImageView addGestureRecognizer:tap];
        _portraitImageView.userInteractionEnabled = YES;
        _portraitImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        imageView.layer.borderWidth = 1.0;
        imageView.backgroundColor = [UIColor lightGrayColor];
        [imageView addSubview:_portraitImageView];
    }
    return _portraitImageView;
}

- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont systemFontOfSize:16.0];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectZero];
        _footerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        CGFloat width = kMainScreenWidth / _buttonTitles.count;
        for (int i = 0; i < _buttonTitles.count; i++) {
            CGRect rect = CGRectMake(width * i, 0, width, 55);
            UIButton *button = [self customButtonFrame:rect title:_buttonTitles[i]];
            button.tag = 10 + i;
            [_footerView addSubview:button];
        }
    }
    return _footerView;
}

- (UIImageView *)titleImageView
{
    if (_titleImageView == nil) {
        _titleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _titleImageView.image = [UIImage imageNamed:@"wait-public"];
        _titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _titleImageView;
}

- (void)setNumOfOrderArray:(NSArray *)numOfOrderArray
{
    _numOfOrderArray = numOfOrderArray;
    for (int i = 0; i < numOfOrderArray.count && i < _footItemLabelArray.count; i++) {
        UILabel *label = (UILabel *)_footItemLabelArray[i];
        label.text = _numOfOrderArray[i];
    }
}

- (void)setIsLogin:(BOOL)isLogin
{
    _isLogin = isLogin;
    if (!_isLogin) {
        _backgroudImageView.image = [UIImage imageNamed:@"userBannerDefault"];
        _portraitImageView.image = [UIImage imageNamed:@"Icon"];
        _nameLabel.text = @"点此登录";

        for (int i = 0; i < _footItemLabelArray.count; i++) {
            UILabel *label = (UILabel *)_footItemLabelArray[i];
            label.text = @"-";
        }
    }
}

@end
