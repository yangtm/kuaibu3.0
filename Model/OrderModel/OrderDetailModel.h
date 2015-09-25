//
//  OrderDetailModel.h
//  kuaibu
//
//  Created by zxy on 15/8/21.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailModel : NSObject

@property (strong, nonatomic) NSString *orderItemId;//订单项ID
@property (strong, nonatomic) NSString *createDate;//创建时间
@property (strong, nonatomic) NSString *lastModifyDatetime;//修改时间
@property (strong, nonatomic) NSString *fullName;//商品全称
@property (strong, nonatomic) NSString *productSn;//商品编号
@property (strong, nonatomic) NSString *productName;//商品名称
@property (strong, nonatomic) NSString *price;//商品价格
@property (strong, nonatomic) NSString *quantity;//数量
@property (strong, nonatomic) NSString *orderId;//订单ID
@property (strong, nonatomic) NSString *thumbnail;//商品缩略图
@property (strong, nonatomic) NSString *specificationId;//规格ID 与specification 表对应
@end
