//
//  YHBSkuImage.m
//  YHB_Prj
//
//  Created by 童小波 on 15/4/27.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "YHBSkuImage.h"

@implementation YHBSkuImage

- (instancetype)initWithJsonDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.itemId = [[self objectOrNilForKey:YHBSkuImageItemId fromDictionary:dic] integerValue];
        self.name = [self objectOrNilForKey:YHBSkuImageName fromDictionary:dic];
        NSArray *array = [self objectOrNilForKey:YHBSkuImageUrls fromDictionary:dic];
        if (array.count > 0) {
            self.thumbImage = array[0];
        }
        if (array.count > 1) {
            self.midImage = array[1];
        }
        if (array.count > 2) {
            self.largeImage = array[2];
        }
        NSString *isMainStr = [self objectOrNilForKey:YHBSkuIsMain fromDictionary:dic];
        if ([isMainStr isEqualToString:@"0"]) {
            self.isMain = NO;
        }
        else{
            self.isMain = YES;
        }
    }
    return self;
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end
