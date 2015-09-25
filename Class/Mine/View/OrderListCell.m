//
//  OrderListCell.m
//  kuaibu
//
//  Created by 朱新余 on 15/9/25.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "OrderListCell.h"
#import "UIImageView+WebCache.h"

@implementation OrderListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showModel:(ProductModel *)model
{
    NSString *url = nil;
    kZXYRequestUrl(model.productImage, url);
    [_productImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    _productImageView.layer.masksToBounds = YES;
    _productImageView.layer.cornerRadius = 5;
    _productDetailLabel.text = model.productBrief;
    _productPirceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
//    _productNumberLable.text = [NSString stringWithFormat:@"x%@",model.]
}

@end
