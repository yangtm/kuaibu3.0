//
//  HomePageSearchViewController.h
//  kuaibu
//
//  Created by zxy on 15/9/1.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomePageSearchViewControllerDelegate;

@interface HomePageSearchViewController : UIViewController

@property (assign, nonatomic) id<HomePageSearchViewControllerDelegate> delegate;

@end

@protocol HomePageSearchViewControllerDelegate <NSObject>

- (void)searchViewControllerDidSelectKeyword:(NSString *)keyword;

@end