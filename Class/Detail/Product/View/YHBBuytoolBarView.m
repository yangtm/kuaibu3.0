//
//  YHBBuytoolBarView.m
//  YHB_Prj
//
//  Created by yato_kami on 15/1/3.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "YHBBuytoolBarView.h"
#define ktitleFont 16
#define kBtnHeight 35
#define kBtnWidth 140
@implementation YHBBuytoolBarView

- (UIButton *)buyButton
{
    if (!_buyButton) {
        _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyButton setBackgroundColor:KColor];
        [_buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        _buyButton.titleLabel.font = [UIFont systemFontOfSize:ktitleFont];
        [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _buyButton.frame = CGRectMake(kMainScreenWidth-10-kBtnWidth,(ktoolHeight-kBtnHeight)/2.0, kBtnWidth, kBtnHeight);
    }
    return _buyButton;
}

- (UIButton *)cartButton
{
    if (!_cartButton) {
        _cartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cartButton setBackgroundColor:KColor];
        [_cartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
        _cartButton.titleLabel.font = [UIFont systemFontOfSize:ktitleFont];
        [_cartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cartButton.frame = CGRectMake(10, (ktoolHeight-kBtnHeight)/2.0, kBtnWidth, kBtnHeight);
    }
    return _cartButton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kMainScreenWidth, ktoolHeight);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [kLineColor CGColor];
        [self addSubview:self.cartButton];
        [self addSubview:self.buyButton];
    }
    return self;
}

@end
