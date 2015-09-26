//
//  MyUtil.h
//  小猪TV
//
//  Created by yinpeng on 15/6/23.
//  Copyright (c) 2015年 YinPeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyUtil : NSObject

//创建label
+ (UILabel*)createLabel:(CGRect)frame text:(NSString*)title alignment:(NSTextAlignment)alignment fontSize:(CGFloat)Size;

//创建imageView
+ (UIImageView*)createImageView:(CGRect)frame imageName:(NSString*)imagename;

//创建button
+ (UIButton*)createButton:(CGRect)frame title:(NSString*)title BtnImage:(NSString*)imageName selectImageName:(NSString*)selectImageName target:(id)target action:(SEL)action;

#pragma mark - 自动适配文字宽度／高度
+ (CGFloat)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize;

@end
