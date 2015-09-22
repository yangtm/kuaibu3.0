//
//  ProductModel.h
//  kuaibu
//
//  Created by zxy on 15/8/21.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject

@property (strong,nonatomic) NSString *productId;
@property (strong,nonatomic) NSString *categoryId;
@property (strong,nonatomic) NSString *productThumb;
@property (strong,nonatomic) NSString *productImage;
@property (strong,nonatomic) NSString *productDesc;
@property (strong,nonatomic) NSString *productBrief;
@property (strong,nonatomic) NSString *price;
@property (strong,nonatomic) NSString *salesAmout;
@property (strong,nonatomic) NSString *imageUrl;
@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *praise;
@property (strong,nonatomic) NSString *comments;
@property (strong,nonatomic) NSString *specificationName;
@property (strong,nonatomic) NSString *specificationImage;
@property (strong,nonatomic) NSString *numbers;
@property (strong,nonatomic) NSString *productName;
@property (assign,nonatomic) NSInteger PhonePublic; //公开
@property (assign,nonatomic) BOOL isSampleCut; //是否裁剪
@property (assign,nonatomic) NSInteger billingType; //发票类型
@property (assign,nonatomic) NSInteger salesPromotion;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *phone;
@end

