//
//  HomePageBannerCell.m
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/7.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "HomePageBannerCell.h"
#import "Public.h"

@implementation HomePageBannerCell

- (void)awakeFromNib {
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.bannerView = [[BannerView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 150 * kRatio)];
    [self.contentView addSubview:_bannerView];
    
}

@end
