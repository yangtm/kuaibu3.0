//
//  ProcurementModel.h
//  kuaibu
//
//  Created by zxy on 15/8/21.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProcurementModel : NSObject

@property (strong,nonatomic) NSString *memberId;//会员ID（发起采购信息的人
@property (strong,nonatomic) NSString *procurementId;
@property (strong,nonatomic) NSString *productName;
@property (strong,nonatomic) NSString *amount;//数量
@property (strong,nonatomic) NSString *amountUnit;//单位
@property (strong,nonatomic) NSString *lastDate;
@property (strong,nonatomic) NSString *createDate;
@property (strong,nonatomic) NSString *phone;
@property (strong,nonatomic) NSString *catId;//采购的类型
@property (strong,nonatomic) NSString *contactor;//联系人
@property (assign,nonatomic) BOOL *isPhonePublic;
@property (strong,nonatomic) NSString *imageUrl;
@property (strong,nonatomic) NSString *ProcurementPrice;//报价
@property (strong,nonatomic) NSString *recording;//录音
//@property (strong,nonatomic) NSString *// 供货状态
//@property (assign,nonatomic) BOOL *//是否提供剪样



@end
