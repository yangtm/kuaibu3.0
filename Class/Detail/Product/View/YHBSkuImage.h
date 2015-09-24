//
//  YHBSkuImage.h
//  YHB_Prj
//
//  Created by 童小波 on 15/4/27.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define YHBSkuImageItemId @"itemid"
#define YHBSkuImageName @"name"
#define YHBSkuImageUrls @"url"
#define YHBSkuIsMain @"is_main"

@interface YHBSkuImage : NSObject

@property (assign, nonatomic) NSInteger itemId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *thumbImage;
@property (strong, nonatomic) NSString *midImage;
@property (strong, nonatomic) NSString *largeImage;
@property (assign, nonatomic) BOOL isMain;

- (instancetype)initWithJsonDic:(NSDictionary *)dic;

@end
