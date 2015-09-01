//
//  WoWTabBarItem.h
//  WoWMusiPlayer
//
//  Created by 童小波 on 15/6/10.
//  Copyright (c) 2015年 tongxiaobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WoWTabBarItem : UIView{
    UIImageView *_imageView;
    UILabel *_label;
}

@property (assign, nonatomic) BOOL resposeEnable;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title;

- (void)setSelect;
- (void)setUnselect;

@end
