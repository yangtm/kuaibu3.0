//
//  HomePageLatestBuyCell.h
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/12.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageLatestBuyCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *pruductImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *lengthLabel;
@property (strong, nonatomic) UILabel *unitLabel;
-(void)configWithLength:(NSString *)length;
@end


