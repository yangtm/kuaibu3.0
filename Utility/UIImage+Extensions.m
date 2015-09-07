//
//  UIImage+Extensions.m
//  YHB_Prj
//
//  Created by 童小波 on 15/3/28.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "UIImage+Extensions.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation UIImage (Extensions)

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

- (void)saveToAlbum:(void(^)(NSURL *assetURL, NSError *error))completionBlock
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:self.CGImage orientation:(ALAssetOrientation)self.imageOrientation completionBlock:completionBlock];
}

+ (void)imageWithUrl:(NSURL *)url completed:(void(^)(UIImage *image, NSError *error))completeBk
{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
        
        UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
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
