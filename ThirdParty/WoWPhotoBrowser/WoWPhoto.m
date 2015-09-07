//
//  WoWPhoto.m
//  YHB_Prj
//
//  Created by 童小波 on 15/5/19.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "WoWPhoto.h"

@implementation WoWPhoto

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.image = image;
    }
    return self;
}
- (instancetype)initWithImageUrl:(NSString *)imageUrl
{
    self = [super init];
    if (self) {
        self.imageUrl = imageUrl;
    }
    return self;
}

- (instancetype)initWithFileUrl:(NSURL *)fileUrl
{
    self = [super init];
    if (self) {
        self.fileUrl = fileUrl;
    }
    return self;
}

@end
