//
//  UIImageView+Extensions.h
//  YHB_Prj
//
//  Created by 童小波 on 15/5/20.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extensions)

- (void) setThumbImageWithUrl:(NSURL *)url completed:(void(^)(UIImage *image, NSError *error))completeBk;
- (void) setFullScreenWithUrl:(NSURL *)url completed:(void(^)(UIImage *image, NSError *error))completeBk;

@end
