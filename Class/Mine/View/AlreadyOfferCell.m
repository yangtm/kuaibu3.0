//
//  AlreadyOfferCell.m
//  kuaibu
//
//  Created by zxy on 15/9/23.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "AlreadyOfferCell.h"
#import "UIImageView+WebCache.h"

@implementation AlreadyOfferCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configAlreadyOfferCell:(OfferModle *)model
{
    NSString *url = nil;
    kZXYRequestUrl(model.logoUrl, url);
//    NSLog(@"%@",url);
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    _rightImageView.layer.masksToBounds = YES;
    _rightImageView.layer.cornerRadius = 5;
    
    _titleLabel.text = model.procurementName;
    _numberLabel.text = model.amount;
    _timeLabel.text = model.offerTime;
    
}

@end
