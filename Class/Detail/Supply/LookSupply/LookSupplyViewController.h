//
//  LookSupplyViewController.h
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/15.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface LookSupplyViewController : BaseViewController
@property (nonatomic, strong) NSString *keyword;

- (instancetype)initWithIsSupply:(BOOL)aIsSupply;
@end
