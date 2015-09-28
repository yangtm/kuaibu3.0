//
//  StoreListTableViewCell.m
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/27.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "StoreListTableViewCell.h"
#import "UIImageView+WebCache.h"

#define kCellHeight 150
#define kTitleFont 16
#define kPriceFont 15
#define kImageWidth (kCellHeight-20)*11/10.0

@interface StoreListTableViewCell ()
@property (strong, nonatomic) UIImageView *logo;
@property (strong, nonatomic) UILabel *amountLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *attentionLabel;
@property (strong, nonatomic) UILabel *typeLabel;
@end

@implementation StoreListTableViewCell

- (UIImageView *)logo
{
    if (!_logo) {
        _logo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 100, 45)];
        _logo.layer.borderColor = [kLineColor CGColor];
        _logo.layer.borderWidth = 0.5;
        _logo.backgroundColor = [UIColor whiteColor];
        _logo.clipsToBounds = YES;
        //_logo.layer.cornerRadius = 3.0;
        _logo.layer.masksToBounds = YES;
        [_logo setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _logo;
}

- (UILabel *)amountLabel
{
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,90, 100, 20)];
        _amountLabel.backgroundColor = [UIColor clearColor];
        _amountLabel.font = [UIFont systemFontOfSize:11];
        _amountLabel.textColor = [UIColor colorWithRed:0.6824 green:0.6824 blue:0.6834 alpha:1];
        _amountLabel.numberOfLines = 2;
    }
    return _amountLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 15, 200, 30)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)attentionLabel
{
    if (!_attentionLabel) {
        _attentionLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 45, 100, 20)];
                _titleLabel.backgroundColor = [UIColor clearColor];
        _attentionLabel.font = [UIFont systemFontOfSize:11];
        _attentionLabel.textColor = [UIColor colorWithRed:0.6824 green:0.6824 blue:0.6834 alpha:1];;
        _attentionLabel.numberOfLines = 2;
    }
    return _attentionLabel;
}

- (UILabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 80, 20, 20)];
        _typeLabel.backgroundColor = [UIColor clearColor];
        _typeLabel.textColor = [UIColor whiteColor];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.layer.masksToBounds = YES;
        _typeLabel.layer.cornerRadius = 2;
        _typeLabel.font = [UIFont systemFontOfSize:kPriceFont];
    }
    return _typeLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.logo];
        [self.contentView addSubview:self.amountLabel];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.attentionLabel];
        [self.contentView addSubview:self.typeLabel];
    }
    return self;
}

- (void)setUIWithImage:(NSString *)logo amount: (NSString *)amount Title:(NSString *)title attention:(NSString *)attention Type:(NSInteger )Type;
{
    [self.logo sd_setImageWithURL:[NSURL URLWithString:logo]];
    self.amountLabel.text = [NSString stringWithFormat:@"在售商品: %@件",amount];
    self.titleLabel.text = title;
    self.attentionLabel.text = [NSString stringWithFormat:@"%@ 人关注",attention];
    
    if (Type == 1) {
        _typeLabel.text = @"个";
        _typeLabel.backgroundColor = [UIColor colorWithRed:0.5961 green:0.4157 blue:0.9725 alpha:1];
    }else
    {
        _typeLabel.text = @"商";
        _typeLabel.backgroundColor = [UIColor colorWithRed:0.0118 green:0.5059 blue:0.1255 alpha:1];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
