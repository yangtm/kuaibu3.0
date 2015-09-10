//
//  AdvertModel.h
//  kuaibu
//
//  Created by zxy on 15/8/21.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//  广告数据

#import <Foundation/Foundation.h>

@interface AdvertModel : NSObject

@property (strong,nonatomic) NSString *advertId;
@property (strong,nonatomic) NSString *advertImage;
@property (strong,nonatomic) NSString *advertSpaceId;
@property (strong,nonatomic) NSString *advertTitle;
@property (strong,nonatomic) NSString *advertUrl;
@property (strong,nonatomic) NSString *createDatetime;
@property (strong,nonatomic) NSString *endDatetime;
@property (strong,nonatomic) NSString *lastUpdateDatetime;
@property (strong,nonatomic) NSString *memberName;
@property (strong,nonatomic) NSString *startDatetime;

@end
