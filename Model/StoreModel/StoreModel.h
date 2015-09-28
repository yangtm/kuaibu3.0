//
//  StoreModel.h
//  kuaibu
//
//  Created by zxy on 15/8/21.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//  店铺数据

#import <Foundation/Foundation.h>

@interface StoreModel : NSObject

@property (strong,nonatomic) NSString *storeId;
@property (strong,nonatomic) NSString *memberId;
@property (strong,nonatomic) NSString *storeName;
@property (strong,nonatomic) NSString *logo;
@property (strong,nonatomic) NSString *authenticationType; //认证类型（1：个人；2：企业）
@end
