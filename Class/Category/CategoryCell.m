//
//  CategoryCell.m
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/18.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell
- (void)awakeFromNib {
    _titleLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _titleLabel.layer.borderWidth = 0.5;
    _titleLabel.layer.cornerRadius = 4.0;
    _titleLabel.layer.masksToBounds = YES;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (_isSelected) {
        _titleLabel.layer.borderColor = KColor.CGColor;
        _titleLabel.textColor = KColor;
    }
    else{
        _titleLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _titleLabel.textColor = [UIColor lightGrayColor];
    }
}


@end
