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
            self.buttonTitles = @[@"待审核", @"待付款", @"待发货", @"待收货"];
        }
        else if (_type == MineHeadViewTypeSeller){
            self.buttonTitles = @[@"待审核", @"待付款", @"待发货", @"待收货"];
        }
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _footerView.frame = CGRectMake(0, 0, self.width, 60);
}

- (void)setup
{
    self.footItemLabelArray = [NSMutableArray array];

    [self addSubview:self.footerView];

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
//    button.backgroundColor = [UIColor grayColor];
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 30)];
    numLabel.textColor = kBackgroundColor;
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.font = [UIFont systemFontOfSize:18.0];
    numLabel.text = @"0";
    [self.footItemLabelArray addObject:numLabel];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, numLabel.bottom, numLabel.width, 20)];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.text = title;
    [button addSubview:numLabel];
    [button addSubview:titleLabel];
    [button addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - setters and getters
- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectZero];
//        _footerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
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


- (void)setNumOfOrderArray:(NSArray *)numOfOrderArray
{
    _numOfOrderArray = numOfOrderArray;
    for (int i = 0; i < numOfOrderArray.count && i < _footItemLabelArray.count; i++) {
        UILabel *label = (UILabel *)_footItemLabelArray[i];
        label.text = _numOfOrderArray[i];
    }
}


@end
