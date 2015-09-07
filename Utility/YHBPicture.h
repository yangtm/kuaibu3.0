//
//  YHBPicture.h
//  YHB_Prj
//
//  Created by 童小波 on 15/5/15.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YHBSupplyDetailPic.h"

typedef NS_ENUM(NSInteger, YHBPictureType) {
    YHBPictureTypeLocal,
    YHBPictureTypeWeb
};

@interface YHBPicture : NSObject

@property (assign, nonatomic) YHBPictureType type;
@property (strong, nonatomic) NSURL *localImageUrl;
@property (strong, nonatomic) YHBSupplyDetailPic *webImage;

@end
