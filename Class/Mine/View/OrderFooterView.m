//
//  OrderFooterView.m
//  kuaibu
//
//  Created by 朱新余 on 15/9/25.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "OrderFooterView.h"

@implementation OrderFooterView
{
    UILabel *_totalLabel;
    UILabel *numberLabel;
    UIButton *paymentBtn;
    UIButton *cancelOrderBtn;
    UIButton *contactSellerBtn;
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
    _totalLabel = [MyUtil createLabel:CGRectZero text:@"合计 ¥424.00" alignment:NSTextAlignmentRight fontSize:14];
    [self addSubview:_totalLabel];
    _totalLabel.textColor = kBackgroundColor;
    _totalLabel.width = [MyUtil labelAutoCalculateRectWith:_totalLabel.text FontSize:14 MaxSize:CGSizeMake(100, 40)];
    _totalLabel.frame = CGRectMake(self.right - _totalLabel.width - 20, 10, _totalLabel.width, 20);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
