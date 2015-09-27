//
//  AlreadyOfferCell.h
//  kuaibu
//
//  Created by zxy on 15/9/23.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProcurementModel.h"

@interface AlreadyOfferCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

- (void)configCell:(ProcurementModel *)model;
@end
