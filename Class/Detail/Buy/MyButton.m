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
        
        _shareImageView = [MyUtil createImageView:CGRectMake(0, 3, 15, 15) imageName:imageName];
        [self addSubview:_shareImageView];
        
        _titleLabel = [MyUtil createLabel:CGRectMake(0, 22, 100, 20) text:text alignment:NSTextAlignmentCenter fontSize:10];
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
    }
    return self;
}

@end
