//
//  ShopingCartListHeaderView.m
//  kuaibu
//
//  Created by 朱新余 on 15/9/28.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "ShopingCartListHeaderView.h"

@implementation ShopingCartListHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
        
    }
    return self;
}

- (void)setup{
    _selectAllButton = [MyUtil createButton:CGRectMake(10, 10, 20, 20) title:nil BtnImage:@"weixuanzhong"selectImageName:@"xuanzhong" target:self action:@selector(selectAction)];
    [self addSubview:_selectAllButton];
    
    _storeNameLabel = [MyUtil createLabel:CGRectZero text:@"店铺名" alignment:NSTextAlignmentLeft fontSize:15];
    [self addSubview:_storeNameLabel];
    _storeNameLabel.width = [MyUtil labelAutoCalculateRectWith:_storeNameLabel.text FontSize:15 MaxSize:CGSizeMake(150, 40)];
    _storeNameLabel.frame = CGRectMake(_selectAllButton.right+ 10, 10, _storeNameLabel.width, 20);
    _arrowImageView = [MyUtil createImageView:CGRectMake(_storeNameLabel.right, 10, 20, 20) imageName:@"right"];
    [self addSubview:_arrowImageView];
    _storeNameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStoreNameLabel)];
    [_storeNameLabel addGestureRecognizer:tap];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kMainScreenWidth, 0.5)];
    line.backgroundColor = kLineColor;
    [self addSubview:line];
}

- (void)selectAction{
    if ([_delegate respondsToSelector:@selector(clickAction:)]) {
        [_delegate clickAction:self];
    }
}

- (void)tapStoreNameLabel{
    if ([_delegate respondsToSelector:@selector(tapStoreName:)]) {
        [_delegate tapStoreName:self];
    }
}
@end
