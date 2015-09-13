//
//  BuyDetailViewController.h
//  kuaibu
//
//  Created by zxy on 15/9/10.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "BaseViewController.h"

@class BuyDetailViewController;
@protocol BuyDetailViewDelegate <NSObject>

- (void)buyDetailViewDidBeginPalySound:(BuyDetailViewController *)detailView;
- (void)buyDetailViewDidSEndPalySound:(BuyDetailViewController *)detailView;

@end
@interface BuyDetailViewController : BaseViewController

@property (nonatomic, assign) id<BuyDetailViewDelegate> delegate;

@end
