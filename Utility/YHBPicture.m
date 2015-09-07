//
//  YHBPicture.m
//  YHB_Prj
//
//  Created by 童小波 on 15/5/15.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "YHBPicture.h"

NSString *const kYHBPictureType = @"type";
NSString *const kImage = @"image";
NSString *const kYHBSupplyDetailPic = @"supply_detail_pic";

@implementation YHBPicture

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.type = [coder decodeIntegerForKey:kYHBPictureType];
        self.localImageUrl = [coder decodeObjectForKey:kImage];
        self.webImage = [coder decodeObjectForKey:kYHBSupplyDetailPic];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInteger:self.type forKey:kYHBPictureType];
    [coder encodeObject:self.localImageUrl forKey:kImage];
    [coder encodeObject:self.webImage forKey:kYHBSupplyDetailPic];
}

@end
