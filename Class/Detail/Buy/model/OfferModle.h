//
//  OfferModle.h
//  kuaibu
//
//  Created by zxy on 15/9/16.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OfferModle : NSObject

@property (nonatomic,strong) NSString *supplier; //供应商
@property (nonatomic,strong) NSString *logoUrl;
@property (nonatomic,strong) NSString *authenticationName; //认证资质
@property (nonatomic,strong) NSString *authenticationType;
@property (nonatomic,strong) NSString *offer;
@property (nonatomic,strong) NSString *offerTime;
@property (nonatomic,strong) NSString *procurementId;
@property (nonatomic,strong) NSString *productImage;//图片
@property (nonatomic,strong) NSString *procurementName;
@property (nonatomic,strong) NSString *unit;//单位
@property (nonatomic,strong) NSString *supplyStatus;
@property (nonatomic,strong) NSString *freight;//运费
@property (nonatomic,strong) NSString *isPayFor;//是否到付
@property (nonatomic,strong) NSString *total;//合计
@property (nonatomic,strong) NSString *address;//发货地址
@property (nonatomic,strong) NSString *describe;//描述的星级
@property (nonatomic,strong) NSString *service;//服务
@property (nonatomic,strong) NSString *logistics;//物流
@property (nonatomic,strong) NSString *procurementPriceId;
@property (nonatomic,strong) NSString *amount;
@end
