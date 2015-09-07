//
//  YHBRadioBox.m
//  YHB_Prj
//
//  Created by 童小波 on 15/5/16.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "YHBRadioBox.h"

@implementation YHBRadioBox

- (instancetype)initWithFrame:(CGRect)frame checkedImage:(UIImage *)checkedImage uncheckedImage:(UIImage *)uncheckedImage title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        _checkedImage = checkedImage;
        _uncheckedImage = uncheckedImage;
        _title = title;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        _imageView.image = _uncheckedImage;
        _imageView.userInteractionEnabled = NO;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 0, self.bounds.size.width - 22, 20)];
        _titleLabel.text = _title;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.userInteractionEnabled = NO;
        [self addSubview:_imageView];
        [self addSubview:_titleLabel];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if (controlEvents & UIControlEventValueChanged) {
        _target = target;
        _action = action;
    }
}

- (void)setIsOn:(BOOL)isOn
{
    if (_isOn != isOn) {
        _isOn = isOn;
        if (_isOn) {
            _imageView.image = _checkedImage;
        }
        else{
            _imageView.image = _uncheckedImage;
        }
    }
}

- (void)viewDidTap:(UITapGestureRecognizer *)tap
{
    if ([_target respondsToSelector:_action]) {
        self.isOn = !_isOn;
        [_target performSelector:_action withObject:self];
    }
}

@end
