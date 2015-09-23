//
//  YHBProductListsCell.m
//  YHB_Prj
//
//  Created by yato_kami on 15/1/17.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "YHBProductListsCell.h"
#import "UIImageView+WebCache.h"
#define kCellHeight 80
#define kTitleFont 16
#define kPriceFont 15
#define kImageWidth (kCellHeight-20)*11/10.0

@interface YHBProductListsCell ()

@property (strong, nonatomic) UIImageView *prodImgeView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *typeLabel;

@end

@implementation YHBProductListsCell

- (UIImageView *)prodImgeView
{
    if (!_prodImgeView) {
        _prodImgeView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 90, 90)];
        _prodImgeView.layer.borderColor = [kLineColor CGColor];
        _prodImgeView.layer.borderWidth = 0.5;
        _prodImgeView.backgroundColor = [UIColor whiteColor];
        _prodImgeView.clipsToBounds = YES;
        _prodImgeView.layer.cornerRadius = 3.0;
        _prodImgeView.layer.masksToBounds = YES;
        [_prodImgeView setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _prodImgeView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.prodImgeView.right+10, self.prodImgeView.top, kMainScreenWidth-self.prodImgeView.right-10, self.prodImgeView.height*2/3.0)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:kTitleFont];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.left, self.titleLabel.bottom+2, self.titleLabel.width, self.prodImgeView.height/3.0)];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.font = [UIFont systemFontOfSize:kPriceFont];
    }
    return _priceLabel;
}
- (UILabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.left +100, self.titleLabel.bottom, 60, self.prodImgeView.height/3.5)];
        _typeLabel.backgroundColor = [UIColor clearColor];
        _typeLabel.textColor = [UIColor blackColor];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.layer.masksToBounds = YES;
        _typeLabel.layer.cornerRadius = 8;
        _typeLabel.font = [UIFont systemFontOfSize:kPriceFont];
    }
    return _typeLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.prodImgeView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.typeLabel];
    }
    return self;
}

- (void)setUIWithImage:(NSString *)urlStr Title:(NSString *)title Price: (NSString *)price Type:(NSInteger)Type
{
    [self.prodImgeView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    self.titleLabel.text = title;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",price];
    
    if (Type == 1) {
        _typeLabel.text = @"个人";
        _typeLabel.backgroundColor = [UIColor colorWithRed:0.5961 green:0.4157 blue:0.9725 alpha:1];
    }else
    {
        _typeLabel.text = @"企业";
        _typeLabel.backgroundColor = [UIColor colorWithRed:0.0118 green:0.5059 blue:0.1255 alpha:1];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
