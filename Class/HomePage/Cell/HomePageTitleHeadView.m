//
//  HomePageTitleHeadView.m
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/10.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "HomePageTitleHeadView.h"

@implementation HomePageTitleHeadView

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)moreButtonClick:(id)sender {
    switch (self.collectViewNum) {
        case 1:
            NSLog(@"精品店铺列表");
            break;
        case 2:
            NSLog(@"热门列表");
            break;
        case 3:
            NSLog(@"精品店铺列表");
            break;
        case 4:
            NSLog(@"精品店铺列表");
            break;
        default:
            break;
    }
    
}

@end
