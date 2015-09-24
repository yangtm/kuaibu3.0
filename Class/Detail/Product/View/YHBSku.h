//
//  YHBSku.h
//
//  Created by   on 15/1/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface YHBSku : NSObject 

@property (nonatomic, assign) double price;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *specificationImage;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) double typePrice;
@property (nonatomic, strong) NSString *specificationName;

@end
