//
//  OrderUtil.h
//  kuaibu
//
//  Created by zxy on 15/9/14.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OrderType) {
    OrderTypeWaitConfirm,
    OrderTypeWatiPay,
    OrderTypePaied,     //已支付，待发货
    OrderTypeDelivered,  //已发货，待收货
    OrderTypeSuccess,
    OrderTypeRefunding,
    OrderTypeBuyerClose,
    ORderTypeSellerClose,
    OrderTypeFinished,
    OrderTypeUnfinished
};

typedef NS_ENUM(NSInteger, TradingRole) {
    Buyer,
    Seller
};
@interface OrderUtil : NSObject

@end
