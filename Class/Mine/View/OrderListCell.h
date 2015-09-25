//
//  OrderListCell.h
//  kuaibu
//
//  Created by 朱新余 on 15/9/25.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@interface OrderListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPirceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNumberLable;

- (void)showModel:(ProductModel *)model;
@end
