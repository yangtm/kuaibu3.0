//
//  YHBRadioBox.h
//  YHB_Prj
//
//  Created by 童小波 on 15/5/16.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHBRadioBox : UIControl{
    UIImage *_checkedImage;
    UIImage *_uncheckedImage;
    NSString *_title;
    UIImageView *_imageView;
    UILabel *_titleLabel;
    id _target;
    SEL _action;
}

@property (assign, nonatomic) BOOL isOn;

- (instancetype)initWithFrame:(CGRect)frame checkedImage:(UIImage *)checkedImage uncheckedImage:(UIImage *)uncheckedImage title:(NSString *)title;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
