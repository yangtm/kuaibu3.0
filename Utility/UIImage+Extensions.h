//
//  UIImage+Extensions.h
//  YHB_Prj
//
//  Created by 童小波 on 15/3/28.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extensions)

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
- (void)saveToAlbum:(void(^)(NSURL *assetURL, NSError *error))completionBlock;
+ (void)imageWithUrl:(NSURL *)url completed:(void(^)(UIImage *image, NSError *error))completeBk;

@end
