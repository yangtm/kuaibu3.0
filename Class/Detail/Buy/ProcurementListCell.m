//
//  ProcurementListCell.m
//  kuaibu
//
//  Created by zxy on 15/9/10.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "ProcurementListCell.h"
#import "UIImageView+WebCache.h"
@implementation ProcurementListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configModel:(ProcurementModel *)model
{
//    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrls]];
    _numberLabel.text = [NSString stringWithFormat:@"%@米",model.amount];
    _cycleLabel.text = model.takeDeliveryLastDate;
    _dateLabel.text = model.offerLastDate;
}

@end
