//
//  SellerOffCell.m
//  kuaibu
//
//  Created by 朱新余 on 15/9/28.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "SellerOffCell.h"
#import "UIImageView+WebCache.h"
@implementation SellerOffCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configCell:(ProcurementModel *)model
{
    NSString *url = nil;
    kZXYRequestUrl(model.procurementImage, url);
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    _rightImageView.layer.masksToBounds = YES;
    _rightImageView.layer.cornerRadius = 5;
    
    _nameLabel.text = model.productName;
    _numberLabel.text = [NSString stringWithFormat:@"%@",model.amount];
    _timeLabel.text = model.offerLastDate;
}
@end
