//
//  HomePagePavilionCell.m
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/10.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "HomePagePavilionCell.h"

@implementation HomePagePavilionCell

- (void)awakeFromNib {
    self.pavilionImageView.layer.masksToBounds = YES;
    self.pavilionImageView.layer.cornerRadius = 5;
}

@end
