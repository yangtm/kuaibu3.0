//
//  HistoryCell.m
//  kuaibu
//
//  Created by zxy on 15/9/19.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "HistoryCell.h"
#import "UIImageView+WebCache.h"

@implementation HistoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configModel:(ProductModel *)model
{
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
    _rightImageView.backgroundColor = [UIColor grayColor];
    _titleLable.text = model.productThumb;
    _priceLabel.text = [NSString stringWithFormat:@"¥ : %@",model.price];
    _praiseLabel.text = [NSString stringWithFormat:@"好评 : %@",model.praise];
    _numberLabel.text = [NSString stringWithFormat:@"人次 : %@",model.numbers];
}


@end
