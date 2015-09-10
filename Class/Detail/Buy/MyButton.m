//
//  MyButton.m
//  kuaibu
//
//  Created by zxy on 15/9/8.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName text:(NSString *)text
{
    if (self = [super initWithFrame:frame]) {
        
        _imageView = [MyUtil createImageView:CGRectMake(0, 12, 15, 15) imageName:imageName];
        [self addSubview:_imageView];
        _imageView.userInteractionEnabled = YES;
        _titleLabel = [MyUtil createLabel:CGRectMake(17, 10, 80, 20) text:text alignment:NSTextAlignmentLeft fontSize:15.0];
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
        _titleLabel.userInteractionEnabled = YES;
    }
    return self;
}

@end
