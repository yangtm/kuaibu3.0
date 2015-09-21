//
//  OfferListCell.m
//  kuaibu
//
//  Created by zxy on 15/9/15.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "OfferListCell.h"
#import "UIImageView+WebCache.h"

@implementation OfferListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configOfferListModel:(OfferModle *)model
{
    [_LogoImageView sd_setImageWithURL:[NSURL URLWithString:model.logoUrl]];
    _LogoImageView.layer.masksToBounds = YES;
    _LogoImageView.layer.cornerRadius = 5;
    
    _nameLabel.text = model.supplier;
    _certLabel.text = model.authenticationName;
    _offLabel.text = model.offer;

    _offTimeLabel.text = model.offerTime;
}

@end
