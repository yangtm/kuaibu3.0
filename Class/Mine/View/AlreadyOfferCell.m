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


- (void)configAlreadyOfferCell:(ProcurementModel *)model
{
    NSString *url = nil;
    kZXYRequestUrl(model.procurementImage, url);
//    NSLog(@"%@",url);
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    _rightImageView.layer.masksToBounds = YES;
    _rightImageView.layer.cornerRadius = 5;
    
    _titleLabel.text = model.productName;
    _numberLabel.text = [NSString stringWithFormat:@"%f",model.amount ];
    _timeLabel.text = model.offerLastDate;
//    NSLog(@"**%ld",[model.procurementStatus integerValue]);
//    if ([model.procurementStatus integerValue]) {
//        
//        _typeLabel.text = @"寻找中";
//    }else{
//        _typeLabel.text = @"已采纳";
//    }
    
}

@end
