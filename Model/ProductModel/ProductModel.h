//
//  ProductModel.h
//  kuaibu
//
//  Created by zxy on 15/8/21.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject

@property (strong,nonatomic) NSString *productId;//产品ID
@property (strong,nonatomic) NSString *categoryId;//产品分类
@property (strong,nonatomic) NSString *memberCategoryId;//自定义分类
@property (strong,nonatomic) NSString *memberId;//所属会员
@property (strong,nonatomic) NSString *productNumber;//库存
@property (strong,nonatomic) NSString *productSku;//货号
@property (strong,nonatomic) NSString *productBrief;//商品简介
@property (strong,nonatomic) NSString *productThumb;//缩略图
@property (strong,nonatomic) NSString *productImage;//原图
@property (strong,nonatomic) NSString *unit;//单位
@property (strong,nonatomic) NSString *price;//价格
@property (strong,nonatomic) NSString *productDesc;//商品详情
@property (strong,nonatomic) NSString *salesAmount;//销量
@property (strong,nonatomic) NSString *isPromotion;//是否促销
@property (strong,nonatomic) NSString *isSample;//是否提供剪样
@property (strong,nonatomic) NSString *supplyState;//供货状态  0 现货 1期货
@property (strong,nonatomic) NSString *productName;//商品名称
@property (strong,nonatomic) NSString *PhonePublic; //公开
@property (strong,nonatomic) NSString *authenticationType; //认证类型（1：个人；2：企业）
@property (strong,nonatomic) NSString *authenticationName; //认证类型名称
@property (strong,nonatomic) NSString *storeId;//店铺ID
@property (strong,nonatomic) NSString *storeLogo;//店铺Logo
@property (strong,nonatomic) NSString *storeName;//店铺名称
@property (strong,nonatomic) NSArray *productSpecificationList;//规格集合
@property (strong,nonatomic) NSArray *productImageList;//图片集合
@property (strong,nonatomic) NSArray *attributes;//产品属性
@property (strong,nonatomic) NSString *collect;
@end

