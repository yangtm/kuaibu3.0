//
//  OrderFooterView.m
//  kuaibu
//
//  Created by 朱新余 on 15/9/25.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "OrderFooterView.h"

@implementation OrderFooterView


- (instancetype)initWithFrame:(CGRect)frame state:(NSInteger)state
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        if (state == -1) {
            [self setup1];
        }else if (state == 4){
            [self setup2];
        }else if (state == 5){
            [self setup3];
        }else if (state == 6){
            [self setup4];
        }else if (state == 7){
            [self setup5];
        }
    }
    return self;
}

- (void)setup1
{
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, 1 )];
    line.backgroundColor = kNaviTitleColor;
    [self addSubview:line];
    _totalLabel = [MyUtil createLabel:CGRectZero text:@"合计 ¥424.00" alignment:NSTextAlignmentRight fontSize:14];
    [self addSubview:_totalLabel];
    _totalLabel.textColor = kBackgroundColor;
    _totalLabel.width = [MyUtil labelAutoCalculateRectWith:_totalLabel.text FontSize:14 MaxSize:CGSizeMake(100, 40)];
    _totalLabel.frame = CGRectMake(self.right - _totalLabel.width - 15, 10, _totalLabel.width, 20);
    
    _numberLabel = [MyUtil createLabel:CGRectZero text:@"共计10件商品" alignment:NSTextAlignmentRight fontSize:14];
    [self addSubview:_numberLabel];
    _numberLabel.width = [MyUtil labelAutoCalculateRectWith:_numberLabel.text FontSize:14 MaxSize:CGSizeMake(150, 40)];
    _numberLabel.frame = CGRectMake(_totalLabel.left - _numberLabel.width-20, 10, _numberLabel.width, 20);
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kMainScreenWidth, 1 )];
    line1.backgroundColor = kLineColor;
    [self addSubview:line1];
    
    _paymentBtn = [MyUtil createButton:CGRectMake(self.right - 80, line1.bottom + 10, 60, 20) title:@"付款" BtnImage:nil selectImageName:nil target:self action:@selector(clickPayment)];
    [_paymentBtn setTitleColor:kBackgroundColor forState:UIControlStateNormal];
    _paymentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:_paymentBtn];
    
    _cancelOrderBtn = [MyUtil createButton:CGRectMake(self.right - 70 - 80, line1.bottom + 10, 70, 20) title:@"取消订单" BtnImage:nil selectImageName:nil target:self action:@selector(clickCancelOrder)];
    _cancelOrderBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_cancelOrderBtn setTitleColor:kNaviTitleColor forState:UIControlStateNormal];
    [self addSubview:_cancelOrderBtn];
    
    _contactSellerBtn = [MyUtil createButton:CGRectMake(self.right - 70 - 80 - 70-10, line1.bottom + 10, 70, 20) title:@"联系卖家" BtnImage:nil selectImageName:nil target:self action:@selector(clickContactSeller)];
    _contactSellerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_contactSellerBtn setTitleColor:kNaviTitleColor forState:UIControlStateNormal];
    [self addSubview:_contactSellerBtn];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 80, kMainScreenWidth, 10 )];
    line2.backgroundColor = kLineColor;
    [self addSubview:line2];
}

- (void)setup2
{
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, 1 )];
    line.backgroundColor = kNaviTitleColor;
    [self addSubview:line];
    _totalLabel = [MyUtil createLabel:CGRectZero text:@"合计 ¥424.00" alignment:NSTextAlignmentRight fontSize:14];
    [self addSubview:_totalLabel];
    _totalLabel.textColor = kBackgroundColor;
    _totalLabel.width = [MyUtil labelAutoCalculateRectWith:_totalLabel.text FontSize:14 MaxSize:CGSizeMake(100, 40)];
    _totalLabel.frame = CGRectMake(self.right - _totalLabel.width - 15, 10, _totalLabel.width, 20);
    
    _numberLabel = [MyUtil createLabel:CGRectZero text:@"共计10件商品" alignment:NSTextAlignmentRight fontSize:14];
    [self addSubview:_numberLabel];
    _numberLabel.width = [MyUtil labelAutoCalculateRectWith:_numberLabel.text FontSize:14 MaxSize:CGSizeMake(150, 40)];
    _numberLabel.frame = CGRectMake(_totalLabel.left - _numberLabel.width-20, 10, _numberLabel.width, 20);
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kMainScreenWidth, 1 )];
    line1.backgroundColor = kLineColor;
    [self addSubview:line1];
    
    _paymentBtn = [MyUtil createButton:CGRectMake(self.right - 80, line1.bottom + 10, 60, 20) title:@"付款" BtnImage:nil selectImageName:nil target:self action:@selector(clickPayment)];
    [_paymentBtn setTitleColor:kBackgroundColor forState:UIControlStateNormal];
    _paymentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:_paymentBtn];
    
    _cancelOrderBtn = [MyUtil createButton:CGRectMake(self.right - 70 - 80, line1.bottom + 10, 70, 20) title:@"取消订单" BtnImage:nil selectImageName:nil target:self action:@selector(clickCancelOrder)];
    _cancelOrderBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_cancelOrderBtn setTitleColor:kNaviTitleColor forState:UIControlStateNormal];
    [self addSubview:_cancelOrderBtn];
    
    _contactSellerBtn = [MyUtil createButton:CGRectMake(self.right - 70 - 80 - 70-10, line1.bottom + 10, 70, 20) title:@"联系卖家" BtnImage:nil selectImageName:nil target:self action:@selector(clickContactSeller)];
    _contactSellerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_contactSellerBtn setTitleColor:kNaviTitleColor forState:UIControlStateNormal];
    [self addSubview:_contactSellerBtn];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 80, kMainScreenWidth, 10 )];
    line2.backgroundColor = kLineColor;
    [self addSubview:line2];
}

- (void)setup3
{
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, 1 )];
    line.backgroundColor = kNaviTitleColor;
    [self addSubview:line];
    _totalLabel = [MyUtil createLabel:CGRectZero text:@"合计 ¥424.00" alignment:NSTextAlignmentRight fontSize:14];
    [self addSubview:_totalLabel];
    _totalLabel.textColor = kBackgroundColor;
    _totalLabel.width = [MyUtil labelAutoCalculateRectWith:_totalLabel.text FontSize:14 MaxSize:CGSizeMake(100, 40)];
    _totalLabel.frame = CGRectMake(self.right - _totalLabel.width - 15, 10, _totalLabel.width, 20);
    
    _numberLabel = [MyUtil createLabel:CGRectZero text:@"共计10件商品" alignment:NSTextAlignmentRight fontSize:14];
    [self addSubview:_numberLabel];
    _numberLabel.width = [MyUtil labelAutoCalculateRectWith:_numberLabel.text FontSize:14 MaxSize:CGSizeMake(150, 40)];
    _numberLabel.frame = CGRectMake(_totalLabel.left - _numberLabel.width-20, 10, _numberLabel.width, 20);
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kMainScreenWidth, 1 )];
    line1.backgroundColor = kLineColor;
    [self addSubview:line1];
    
    _paymentBtn = [MyUtil createButton:CGRectMake(self.right - 80, line1.bottom + 10, 70, 20) title:@"提醒卖家" BtnImage:nil selectImageName:nil target:self action:@selector(clickPayment)];
    [_paymentBtn setTitleColor:kNaviTitleColor forState:UIControlStateNormal];
    _paymentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:_paymentBtn];
    
    _cancelOrderBtn = [MyUtil createButton:CGRectMake(self.right - 70 - 90, line1.bottom + 10, 70, 20) title:@"取消订单" BtnImage:nil selectImageName:nil target:self action:@selector(clickCancelOrder)];
    _cancelOrderBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_cancelOrderBtn setTitleColor:kNaviTitleColor forState:UIControlStateNormal];
    [self addSubview:_cancelOrderBtn];
    
    _contactSellerBtn = [MyUtil createButton:CGRectMake(self.right - 70 - 90 - 70-10, line1.bottom + 10, 70, 20) title:@"联系卖家" BtnImage:nil selectImageName:nil target:self action:@selector(clickContactSeller)];
    _contactSellerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_contactSellerBtn setTitleColor:kNaviTitleColor forState:UIControlStateNormal];
    [self addSubview:_contactSellerBtn];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 80, kMainScreenWidth, 10 )];
    line2.backgroundColor = kLineColor;
    [self addSubview:line2];
}

- (void)setup4
{
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, 1 )];
    line.backgroundColor = kNaviTitleColor;
    [self addSubview:line];
    _totalLabel = [MyUtil createLabel:CGRectZero text:@"合计 ¥424.00" alignment:NSTextAlignmentRight fontSize:14];
    [self addSubview:_totalLabel];
    _totalLabel.textColor = kBackgroundColor;
    _totalLabel.width = [MyUtil labelAutoCalculateRectWith:_totalLabel.text FontSize:14 MaxSize:CGSizeMake(100, 40)];
    _totalLabel.frame = CGRectMake(self.right - _totalLabel.width - 15, 10, _totalLabel.width, 20);
    
    _numberLabel = [MyUtil createLabel:CGRectZero text:@"共计10件商品" alignment:NSTextAlignmentRight fontSize:14];
    [self addSubview:_numberLabel];
    _numberLabel.width = [MyUtil labelAutoCalculateRectWith:_numberLabel.text FontSize:14 MaxSize:CGSizeMake(150, 40)];
    _numberLabel.frame = CGRectMake(_totalLabel.left - _numberLabel.width-20, 10, _numberLabel.width, 20);
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kMainScreenWidth, 1 )];
    line1.backgroundColor = kLineColor;
    [self addSubview:line1];
    
    _paymentBtn = [MyUtil createButton:CGRectMake(self.right - 80, line1.bottom + 10, 70, 20) title:@"确认收货" BtnImage:nil selectImageName:nil target:self action:@selector(clickPayment)];
    [_paymentBtn setTitleColor:kNaviTitleColor forState:UIControlStateNormal];
    _paymentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:_paymentBtn];
    
    _cancelOrderBtn = [MyUtil createButton:CGRectMake(self.right - 70 - 90, line1.bottom + 10, 70, 20) title:@"删除订单" BtnImage:nil selectImageName:nil target:self action:@selector(clickCancelOrder)];
    _cancelOrderBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_cancelOrderBtn setTitleColor:kNaviTitleColor forState:UIControlStateNormal];
    [self addSubview:_cancelOrderBtn];
    
    _contactSellerBtn = [MyUtil createButton:CGRectMake(self.right - 70 - 90 - 70-10, line1.bottom + 10, 70, 20) title:@"联系卖家" BtnImage:nil selectImageName:nil target:self action:@selector(clickContactSeller)];
    _contactSellerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_contactSellerBtn setTitleColor:kNaviTitleColor forState:UIControlStateNormal];
    [self addSubview:_contactSellerBtn];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 80, kMainScreenWidth, 10 )];
    line2.backgroundColor = kLineColor;
    [self addSubview:line2];
}

- (void)setup5
{
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, 1 )];
    line.backgroundColor = kNaviTitleColor;
    [self addSubview:line];
    _totalLabel = [MyUtil createLabel:CGRectZero text:@"合计 ¥424.00" alignment:NSTextAlignmentRight fontSize:14];
    [self addSubview:_totalLabel];
    _totalLabel.textColor = kBackgroundColor;
    _totalLabel.width = [MyUtil labelAutoCalculateRectWith:_totalLabel.text FontSize:14 MaxSize:CGSizeMake(100, 40)];
    _totalLabel.frame = CGRectMake(self.right - _totalLabel.width - 15, 10, _totalLabel.width, 20);
    
    _numberLabel = [MyUtil createLabel:CGRectZero text:@"共计10件商品" alignment:NSTextAlignmentRight fontSize:14];
    [self addSubview:_numberLabel];
    _numberLabel.width = [MyUtil labelAutoCalculateRectWith:_numberLabel.text FontSize:14 MaxSize:CGSizeMake(150, 40)];
    _numberLabel.frame = CGRectMake(_totalLabel.left - _numberLabel.width-20, 10, _numberLabel.width, 20);
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kMainScreenWidth, 1 )];
    line1.backgroundColor = kLineColor;
    [self addSubview:line1];
    
    _paymentBtn = [MyUtil createButton:CGRectMake(self.right - 80, line1.bottom + 10, 70, 20) title:@"评价订单" BtnImage:nil selectImageName:nil target:self action:@selector(clickPayment)];
    [_paymentBtn setTitleColor:kNaviTitleColor forState:UIControlStateNormal];
    _paymentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:_paymentBtn];
    
    _cancelOrderBtn = [MyUtil createButton:CGRectMake(self.right - 70 - 90, line1.bottom + 10, 70, 20) title:@"删除订单" BtnImage:nil selectImageName:nil target:self action:@selector(clickCancelOrder)];
    _cancelOrderBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_cancelOrderBtn setTitleColor:kNaviTitleColor forState:UIControlStateNormal];
    [self addSubview:_cancelOrderBtn];
    
    _contactSellerBtn = [MyUtil createButton:CGRectMake(self.right - 70 - 90 - 70-10, line1.bottom + 10, 70, 20) title:@"联系卖家" BtnImage:nil selectImageName:nil target:self action:@selector(clickContactSeller)];
    _contactSellerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_contactSellerBtn setTitleColor:kNaviTitleColor forState:UIControlStateNormal];
    [self addSubview:_contactSellerBtn];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 80, kMainScreenWidth, 10 )];
    line2.backgroundColor = kLineColor;
    [self addSubview:line2];
}

- (void)clickPayment{
    if ([_delegate respondsToSelector:@selector(clickPaymentBtn:)]) {
        [_delegate clickPaymentBtn:self];
    }
}

- (void)clickCancelOrder{
    if ([_delegate respondsToSelector:@selector(clickCancelOrderBtn:)]) {
        [_delegate clickCancelOrderBtn:self];
    }
}

- (void)clickContactSeller{
    if ([_delegate respondsToSelector:@selector(clickContactSellerBtn:)]) {
        [_delegate clickContactSellerBtn:self];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
