//
//  YHBSupplyModel.h
//
//  Created by  C陈政旭 on 14/12/6
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface YHBSupplyModel : NSObject <NSCoding, NSCopying>

@property (strong,nonatomic) NSString *memberId;//会员ID（发起采购信息的人
@property (strong,nonatomic) NSString *procurementId;
@property (strong,nonatomic) NSString *productName;//标题
@property (assign,nonatomic) double amount;//数量
@property (strong,nonatomic) NSString *amountUnit;//单位
@property (strong,nonatomic) NSString *takeDeliveryLastDate;//收货
@property (strong,nonatomic) NSString *offerLastDate; //报价时间
@property (strong,nonatomic) NSString *phone;//电话
@property (strong,nonatomic) NSString *catId;//采购的类型
@property (strong,nonatomic) NSString *contactor;//联系人
@property (assign,nonatomic) NSInteger PhonePublic; //公开
@property (strong,nonatomic) NSString *ProcurementPrice;//报价
@property (strong,nonatomic) NSString *recording;//录音
@property (strong,nonatomic) NSString *details; //面料详情
@property (assign,nonatomic) BOOL isSampleCut; //是否裁剪
@property (assign,nonatomic) NSInteger billingType; //发票类型
@property (strong,nonatomic) NSArray *imageUrls;
@property (strong,nonatomic) NSString *procurementStatus;
@property (strong,nonatomic) NSString *district;
@property (strong,nonatomic) NSString *imageurl;
@property (strong,nonatomic) NSDate *date;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end
