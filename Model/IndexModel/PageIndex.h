//
//  PageIndex.h
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/7.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageIndex : NSObject

@property (strong, nonatomic) NSArray *banners;
@property (strong, nonatomic) NSArray *pavilions;
@property (strong, nonatomic) NSArray *hotProduct;
@property (strong, nonatomic) NSArray *bands;
@property (strong, nonatomic) NSArray *latestBuy;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
