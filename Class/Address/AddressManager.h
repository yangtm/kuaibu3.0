//
//  AddressManager.h
//  kuaibu
//
//  Created by zxy on 15/9/7.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AddressModel;
@interface AddressManager : NSObject
//获取默认地址
- (void)getDefaultAddressWithToken:(NSString *)token WithSuccess:(void(^)(AddressModel *model))sBlock failure:(void(^)(NSString *error))fBlock;
//获取地址列表
- (void)getAddresslistWithToken:(NSString *)token WithSuccess:(void(^)(NSMutableArray *modelList))sBlock failure:(void(^)(NSString *error))fBlock;
//新增/编辑地址
- (void)addOrEditAddressWithAddModel:(AddressModel *)model Token:(NSString *)token isNew:(BOOL)isNew WithSuccess:(void(^)())sBlock failure:(void(^)(NSString *error))fBlock;

//获取城市地区列表
- (void)getAreaListWithSuccess:(void(^)(NSMutableArray *areaArray))sBlock failure:(void(^)(NSString *error))fBlock;

//删除常用地址 delAddress.php
- (void)deleteAddressWithToken:(NSString *)token AndItemID:(int)itemid WithSuccess:(void(^)())sBlock failure:(void(^)(NSString *error))fBlock;
@end
