//
//  YHBPhotoImageView.m
//  YHB_Prj
//
//  Created by Johnny's on 14/12/1.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "YHBPhotoImageView.h"

@interface YHBPhotoImageView()

@property (strong, nonatomic) UIImageView *selectOffImageView;
@property (strong, nonatomic) UIImageView *selectOnImageView;

@end

@implementation YHBPhotoImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectOffImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 18, 0, 18, 18)];
        _selectOffImageView.image = [UIImage imageNamed:@"selectOff"];
        [self addSubview:_selectOffImageView];
        _selectOffImageView.hidden = YES;
        _selectOnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 18, 0, 18, 18)];
        _selectOnImageView.image = [UIImage imageNamed:@"selectOn"];
        [self addSubview:_selectOnImageView];
        _selectOnImageView.hidden = YES;
    }
    return self;
}

- (void) setImage:(UIImage *)image
{
    [super setImage:image];
    if (image != nil) {
        _selectOffImageView.hidden = NO;
    }
    else{
        _selectOffImageView.hidden = YES;
        _selectOnImageView.hidden = YES;
    }
}

- (void) setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (isSelected) {
        _selectOnImageView.hidden = NO;
    }
    else{
        _selectOnImageView.hidden =YES;
    }
}

- (void)changeSelected
{
    self.isSelected = !self.isSelected;
    _selectOnImageView.hidden = !self.isSelected;
}

@end
