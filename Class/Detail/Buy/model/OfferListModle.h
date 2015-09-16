//
//  OfferListModle.h
//  kuaibu
//
//  Created by zxy on 15/9/15.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OfferListModle : NSObject

@property (nonatomic,strong) NSString *procurementPriceId;//采购报价表ID
@property (nonatomic,strong) NSString *productPrice;//报价
@property (nonatomic,strong) NSString *transportPrice;//运费
@property (nonatomic,strong) NSString *totalPrice;//合计价格
@property (nonatomic,strong) NSString *productStatus;//货源状态1现货2预定
@property (nonatomic,strong) NSString *sellerMemberId;//报价人
@property (nonatomic,strong) NSString *productImage;//报价图片
@property (nonatomic,strong) NSString *remark;//备注
@property (nonatomic,strong) NSString *createDate;
@property (nonatomic,strong) NSString *updateDate;
@property (nonatomic,strong) NSString *priceCount;//报价次数
@property (nonatomic,strong) NSString *isEnable;//是否有效
@property (nonatomic,strong) NSString *isCancel;//是否取消
@property (nonatomic,strong) NSString *deliveryDistrict;
@end
