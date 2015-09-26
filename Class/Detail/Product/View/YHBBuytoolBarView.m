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

- (UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setBackgroundColor:KColor];
        [_addButton setTitle:@"加入购物车" forState:UIControlStateNormal];
        _addButton.titleLabel.font = [UIFont systemFontOfSize:ktitleFont];
        [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addButton.frame = CGRectMake(kMainScreenWidth-kBtnWidth,(ktoolHeight-kBtnHeight)/2.0, kBtnWidth, kBtnHeight);
    }
    return _addButton;
}

- (UIButton *)cartButton
{
    if (!_cartButton) {
        _cartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cartButton setBackgroundColor:[UIColor colorWithRed:0.8471 green:0.8471 blue:0.8471 alpha:1]];
        [_cartButton setTitle:@"购物车" forState:UIControlStateNormal];
        _cartButton.titleLabel.font = [UIFont systemFontOfSize:ktitleFont];
        [_cartButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cartButton.frame = CGRectMake(100, (ktoolHeight-kBtnHeight)/2.0, kBtnWidth, kBtnHeight);
    }
    return _cartButton;
}

-(UIButton *)privateButton
{
    if (!_privateButton) {
        _privateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _privateButton.frame = CGRectMake(0, 10, kBtnWidth-40, kBtnHeight);
        [_privateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_privateButton setBackgroundColor:[UIColor colorWithRed:0.8471 green:0.8471 blue:0.8471 alpha:1]];
        //[_privateButton setBackgroundColor:[UIColor redColor]];
        [_privateButton setBackgroundImage:[UIImage imageNamed:@"privateImg"] forState:UIControlStateNormal];
        [_privateButton setBackgroundImage:[UIImage imageNamed:@"privateHighImg"] forState:UIControlStateSelected];
        _privateButton.selected = NO;
    }
    return _privateButton;
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
        [self addSubview:self.addButton];
        [self addSubview:self.privateButton];
    }
    return self;
}

@end
