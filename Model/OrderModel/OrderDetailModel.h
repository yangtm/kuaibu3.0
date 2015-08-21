//
//  OrderDetailModel.h
//  kuaibu
//
//  Created by zxy on 15/8/21.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailModel : NSObject

@property (strong, nonatomic) NSString *orderItemId;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *productSn;
@property (strong, nonatomic) NSString *productName;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *quantity;
@property (strong, nonatomic) NSString *orderId;
@property (strong, nonatomic) NSString *thumbnail;
@property (strong, nonatomic) NSString *specificationId;

@end
