//
//  CartModel.h
//  kuaibu
//
//  Created by yangtm on 15/8/20.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartModel : NSObject

@property (strong, nonatomic) NSString *cartId;//购物车ID
@property (strong, nonatomic) NSString *buyerMemberId;//用户ID(买家)
@property (strong, nonatomic) NSString *sellerMemberId;//卖家ID
@property (strong, nonatomic) NSString *productId;//商品的ID,取自表product的id
@property (strong, nonatomic) NSString *amount;//数量
@property (strong, nonatomic) NSString *createDatetime;
@property (strong, nonatomic) NSString *lastModifyDatetime;
@property (strong, nonatomic) NSString *specificationId;
@property (strong,nonatomic) NSDictionary *product;
@property (strong,nonatomic) NSDictionary *store;
@end
