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
@property (strong, nonatomic) NSString *memberBuyId;
@property (strong, nonatomic) NSString *memberSellId;
@property (strong, nonatomic) NSString *orderSn;
@property (strong, nonatomic) NSString *consignee;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *mobileNumber;
@property (strong, nonatomic) NSString *orderStatus;
@property (strong, nonatomic) NSString *countPrice;
@property (strong, nonatomic) NSString *createDatetime;
@property (strong, nonatomic) NSString *lastModifyDatetime;
@property (strong, nonatomic) NSString *payDateTime;
@property (strong, nonatomic) NSString *deliveryDateTime;
@property (strong, nonatomic) NSString *receiptGoodsDateTime;

@end
