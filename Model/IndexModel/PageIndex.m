//
//  PageIndex.m
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/7.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "PageIndex.h"

@implementation PageIndex

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"banners": @"slidelist",
             @"pavilions": @"coliseum",
             @"hotProduct": @"industry_areas",
             @"band": @"hotmalls",
             @"latestBuy":@"buymalls"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"banners": @"BannerModel",
             @"pavilions":@"",
             @"hotProduct":@"",
             @"band": @"",
             @"latestBuy": @""};
}

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        //        NSDictionary *
    }
    return self;
}


@end
