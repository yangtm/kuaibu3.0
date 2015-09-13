//
//  HomePageHotProductCell.h
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/11.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageHotProductCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *pruductImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *attention;
@property (strong, nonatomic) UILabel *time;
@property (strong, nonatomic) UILabel *unitLabel;

-(void)configWithPrice:(NSString *)price;
@end
