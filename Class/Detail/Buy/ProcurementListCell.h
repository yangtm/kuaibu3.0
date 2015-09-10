//
//  ProcurementListCell.h
//  kuaibu
//
//  Created by zxy on 15/9/10.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProcurementModel.h"
@interface ProcurementListCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *cycleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;

@property (weak, nonatomic) IBOutlet UIButton *clickBtn;

- (void)configModel:(ProcurementModel *)model;
@end
