//
//  OrderModel.h
//  kuaibu
//
//  Created by zxy on 15/8/21.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject

@property (strong, nonatomic) NSString *orderId;
@property (strong, nonatomic) NSString *orderSn;//订单编号
@property (strong, nonatomic) NSString *createDate;//创建时间
@property (strong, nonatomic) NSString *lastModifyDatetime;//修改时间
@property (strong, nonatomic) NSString *address;//地址
@property (strong, nonatomic) NSString *consignee;//收货人
@property (strong, nonatomic) NSString *memo;//附言
@property (strong, nonatomic) NSString *orderStatus;//订单状态1 未处理 2 已审核 3 已关闭 4未付款 5 已付款 6已发货7已完成
@property (strong, nonatomic) NSString *paymentMethodName;//支付方式名称
@property (strong, nonatomic) NSString *paymentStatus;//支付状态
@property (strong, nonatomic) NSString *phone;//手机
@property (strong, nonatomic) NSString *shippingMethodSn;//配送单号
@property (strong, nonatomic) NSString *shippingMethodName;//配送方式名称
@property (strong, nonatomic) NSString *memberBuyId;//买家ID
@property (strong, nonatomic) NSString *memberSellId;//卖家ID
@property (strong, nonatomic) NSString *operators;//操作员
@property (strong, nonatomic) NSString *countPrice;//订单总价
@property (strong, nonatomic) NSString *orderType;//订单类型0普通订单，1一键下单3采购订单
@property (strong, nonatomic) NSString *storeName;//店铺名称
@property (strong, nonatomic) NSString *storeId;//店铺ID
@end
