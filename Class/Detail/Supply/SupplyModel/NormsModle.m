//
//  NormsModle.m
//  kuaibu
//
//  Created by zxy on 15/9/22.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "NormsModle.h"

@implementation NormsModle
static  NormsModle* norms;
+ (instancetype)shareNormsModle
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        norms = [[NormsModle alloc] init];
    });
    
    return norms;
}

- (NSString *)description
{
    NSString * str = [NSString stringWithFormat:@"%@, %@", norms.specificationName,norms.price];
    return str;
}
@end
