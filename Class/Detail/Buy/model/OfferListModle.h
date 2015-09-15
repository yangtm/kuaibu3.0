//
//  OfferListModle.h
//  kuaibu
//
//  Created by zxy on 15/9/15.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OfferListModle : NSObject

@property (nonatomic,strong) NSString *procurement_price_id;//采购报价表ID
@property (nonatomic,strong) NSString *product_price;//报价
@property (nonatomic,strong) NSString *transport_price;//运费
@property (nonatomic,strong) NSString *total_price;//合计价格
@property (nonatomic,strong) NSString *product_status;//货源状态1现货2预定
@property (nonatomic,strong) NSString *seller_member_id;//报价人
@property (nonatomic,strong) NSString *product_image;//报价图片
@property (nonatomic,strong) NSString *remark;//备注
@property (nonatomic,strong) NSString *create_date;
@property (nonatomic,strong) NSString *update_date;
@property (nonatomic,strong) NSString *price_count;//报价次数
@property (nonatomic,strong) NSString *is_enable;//是否有效
@property (nonatomic,strong) NSString *is_cancel;//是否取消
@property (nonatomic,strong) NSString *delivery_district;
@end
