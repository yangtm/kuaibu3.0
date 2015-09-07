//
//  UIImageView+Extensions.m
//  YHB_Prj
//
//  Created by 童小波 on 15/5/20.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "UIImageView+Extensions.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation UIImageView (Extensions)

- (void) setThumbImageWithUrl:(NSURL *)url completed:(void(^)(UIImage *image, NSError *error))completeBk
{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
        
        self.image = [UIImage imageWithCGImage:[asset thumbnail]];
        if (completeBk) {
            completeBk(self.image, nil);
        }
        
    } failureBlock:^(NSError *error) {
        
        if (completeBk) {
            completeBk(nil, error);
        }
        
    }];
}

- (void) setFullScreenWithUrl:(NSURL *)url completed:(void(^)(UIImage *image, NSError *error))completeBk
{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
        
        UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
        self.image = image;
        if (completeBk) {
            completeBk(image, nil);
        }
        
    } failureBlock:^(NSError *error) {
        
        if (completeBk) {
            completeBk(nil, error);
        }
        
    }];
}

@end
