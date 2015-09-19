//
//  HistoryCell.h
//  kuaibu
//
//  Created by zxy on 15/9/19.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@interface HistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *praiseLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

- (void)configModel:(ProductModel *)model;

@end
