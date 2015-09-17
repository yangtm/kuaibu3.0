//
//  YHBLookBuyManage.h
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/16.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHBSupplyDataSource.h"
@interface YHBLookBuyManage : NSObject
- (void)getBuyArray:(void(^)(YHBSupplyDataSource *dataSource))aSuccBlock andFail:(void(^)(NSString *aStr))aFailBlock isVip:(BOOL)aBool;
//关键字搜索
- (void)getBuyArrayWithKeyword:(NSString *)keyword typeId:(NSInteger)typeId catIds:(NSArray *)catIds complete:(void(^)(YHBSupplyDataSource *dataSource))aSuccBlock andFail:(void(^)(NSString *aStr))aFailBlock isVip:(BOOL)aBool;
- (void)getNextBuyArrayWithKeyword:(NSString *)keyword typeId:(NSInteger)typeId complete:(void (^)(YHBSupplyDataSource *dataSource))aSuccBlock andFail:(void (^)(NSString *aStr))aFailBlock;
//关键字搜索
@end
