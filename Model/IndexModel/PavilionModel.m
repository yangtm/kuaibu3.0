//
//  PavilionModel.m
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/10.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "PavilionModel.h"

@implementation PavilionModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"memberId": @"id",
             @"storeName": @"name"};
}

@end
