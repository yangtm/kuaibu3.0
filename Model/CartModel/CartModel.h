//
//  CartModel.h
//  kuaibu
//
//  Created by yangtm on 15/8/20.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartModel : NSObject

@property (strong, nonatomic) NSString *cartId;
@property (strong, nonatomic) NSString *productId;
@property (strong, nonatomic) NSString *productName;
@property (strong, nonatomic) NSString *productImage;
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *storeLogo;
@property (strong, nonatomic) NSString *amount;
@property (strong, nonatomic) NSString *specificationId;
@property (strong, nonatomic) NSString *price;

@end
