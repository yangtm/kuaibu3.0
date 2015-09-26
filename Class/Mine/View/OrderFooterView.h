//
//  OrderFooterView.h
//  kuaibu
//
//  Created by 朱新余 on 15/9/25.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderFooterView;
@protocol OrderFooterViewDelegate <NSObject>

- (void)clickPaymentBtn:(OrderFooterView *)footerView;
- (void)clickCancelOrderBtn:(OrderFooterView *)footerView;
- (void)clickContactSellerBtn:(OrderFooterView *)footerView;
@end

@interface OrderFooterView : UIView

@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIButton *paymentBtn;
@property (nonatomic, strong) UIButton *cancelOrderBtn;
@property (nonatomic, strong) UIButton *contactSellerBtn;
@property (nonatomic, assign) NSInteger state;

@property (nonatomic, assign) id<OrderFooterViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame state:(NSInteger)state;

@end
