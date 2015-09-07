//
//  WoWPhoto.h
//  YHB_Prj
//
//  Created by 童小波 on 15/5/19.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WoWPhoto : NSObject

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSURL *fileUrl;

- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithImageUrl:(NSString *)imageUrl;
- (instancetype)initWithFileUrl:(NSURL *)fileUrl;

@end
