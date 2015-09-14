//
//  HeaderSectionCell.m
//  kuaibu
//
//  Created by zxy on 15/9/12.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "HeaderSectionCell.h"

@implementation HeaderSectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    _portraitImageView.frame = CGRectMake(20, 20, 60, 60);
    _nameLabel.frame = CGRectMake(_portraitImageView.right+10, 25, kMainScreenWidth-_portraitImageView.width-_messageImageView.width-_settingButton.width-20, 20);
    _integralLabel.frame = CGRectMake(_portraitImageView.right+10, _nameLabel.bottom+15, kMainScreenWidth-_portraitImageView.width-_settingButton.width -20, 20);
    _settingButton.frame = CGRectMake(self.right - 65, 20, 50, 30);
    _messageImageView.frame = CGRectMake(self.right - _settingButton.width-60, 20, 25, 25);
    
}


- (void)setup
{
    _portraitImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    _portraitImageView.layer.cornerRadius = 30;
    _portraitImageView.layer.masksToBounds = YES;
    _portraitImageView.backgroundColor = [UIColor orangeColor];
    [_portraitImageView addTarget:self action:@selector(clickPortraitBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_portraitImageView];
    
    _nameLabel = [self formTitleLabel:CGRectZero title:@"用户名 : "];
    [self.contentView addSubview:_nameLabel];
    
    _integralLabel = [self formTitleLabel:CGRectZero title:@"积分 : "];
    [self.contentView addSubview:_integralLabel];
    
    _messageImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_messageImageView setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [_messageImageView addTarget:self action:@selector(clickMessageBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_messageImageView];
    
    _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_settingButton setTitle:@"设置" forState:UIControlStateNormal];
    [_settingButton setTitleColor:kBackgroundColor forState:UIControlStateNormal];
    [_settingButton addTarget:self action:@selector(settingBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_settingButton];
}

- (void)settingBtn
{
    if ([_delegate respondsToSelector:@selector(clickSettingBtn:)]) {
        [_delegate clickSettingBtn:self];
    }
}

- (void)clickPortraitBtn
{
    if ([_delegate respondsToSelector:@selector(clickPortraitImageView:)]) {
        [_delegate clickPortraitImageView:self];
    }
}

- (void)clickMessageBtn
{
    if ([_delegate respondsToSelector:@selector(clickMessageImageView:)]) {
        [_delegate clickMessageImageView:self];
    }
}


- (UILabel *)formTitleLabel:(CGRect)frame title:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:14];
    label.text = title;
    return label;
}


@end
