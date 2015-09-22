//
//  NormsModle.h
//  kuaibu
//
//  Created by zxy on 15/9/22.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NormsModle : NSObject

+ (instancetype)shareNormsModle;

@property (nonatomic, copy) NSString * specificationName;
@property (nonatomic, copy) NSString * price;
@end
