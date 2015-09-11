//
//  HomeMainPageViewController.h
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/8.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol HomeMainPageViewControllerDelegate <NSObject>
-(void)advertUrl:(NSString *)advertUrl  advertTitle:(NSString *)advertTitle;
@end

@interface HomeMainPageViewController : BaseViewController
@property(strong,nonatomic) id<HomeMainPageViewControllerDelegate>homeMainPageViewDelegate;
@end
