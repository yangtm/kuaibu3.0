//
//  OfferListCell.h
//  kuaibu
//
//  Created by zxy on 15/9/15.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfferModle.h"

@interface OfferListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *LogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *certLabel;
@property (weak, nonatomic) IBOutlet UILabel *offLabel;
@property (weak, nonatomic) IBOutlet UILabel *offTimeLabel;

- (void)configOfferListModel:(OfferModle *)model;

@end
