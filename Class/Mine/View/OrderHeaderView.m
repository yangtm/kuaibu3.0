//
//  OrderHeaderView.m
//  kuaibu
//
//  Created by 朱新余 on 15/9/25.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "OrderHeaderView.h"

@implementation OrderHeaderView
{
    UIImageView *_selectImageView;
    UIImageView *_arrowImageView;
    UILabel *_storeNameLabel;
    UILabel *_payLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _selectImageView = [MyUtil createImageView:CGRectMake(10, 10, 20, 20) imageName:@"weixuanzhong"];
    [self addSubview:_selectImageView];
    
    
    _storeNameLabel = [MyUtil createLabel:CGRectZero text:@"店铺名" alignment:NSTextAlignmentLeft fontSize:15];
    [self addSubview:_storeNameLabel];
    _storeNameLabel.width = [MyUtil labelAutoCalculateRectWith:_storeNameLabel.text FontSize:15 MaxSize:CGSizeMake(150, 44)];
    _storeNameLabel.frame = CGRectMake(_selectImageView.right+ 10, 10, _storeNameLabel.width, 20);
    _arrowImageView = [MyUtil createImageView:CGRectMake(_storeNameLabel.right, 10, 20, 20) imageName:@"right"];
    [self addSubview:_arrowImageView];
    
    _payLabel = [MyUtil createLabel:CGRectZero text:@"等待买家付款" alignment:NSTextAlignmentRight fontSize:13];
    _payLabel.width = [MyUtil labelAutoCalculateRectWith:_payLabel.text FontSize:15 MaxSize:CGSizeMake(100, 44)];
    _payLabel.frame = CGRectMake(self.right - _payLabel.width - 20, 10, _payLabel.width, 20);
    _payLabel.textColor = kBackgroundColor;
    [self addSubview:_payLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 44, kMainScreenWidth-30, 1 )];
    line.backgroundColor = kNaviTitleColor;
    [self addSubview:line];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
