//
//  OrderHeaderView.h
//  kuaibu
//
//  Created by 朱新余 on 15/9/25.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, OrderState) {
    NOTCOMPLETE = 1,//未处理
    AUDIT,          //已审核
    SHUTDOWNORDER,  //已关闭
    NOTPAYMENT,     //未付款
    PAYMENT,        //待发货
    DELIVERED,      //待收货
    COMPLETE        //已完成、待评价
};
@class OrderHeaderView;
@protocol OrderHeaderViewDelegate <NSObject>

- (BOOL)clickAction:(OrderHeaderView *)headerView;
- (void)tapStoreName:(OrderHeaderView *)headerView;
@end


@interface OrderHeaderView : UIView

@property (nonatomic,strong) UIButton *selectImageView;
@property (nonatomic,strong) UIImageView *arrowImageView;
@property (nonatomic,strong) UILabel *storeNameLabel;
@property (nonatomic,strong) UILabel *payLabel;
@property (nonatomic,assign) NSInteger state;

@property (nonatomic,assign) id<OrderHeaderViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame orderType:(NSInteger)tpye;
@end
