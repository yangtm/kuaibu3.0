//
//  CateViewController.h
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/25.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "YHBCatData.h"

@protocol CateViewControllerDelegate;

@interface CateViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (assign, nonatomic) id<CateViewControllerDelegate> delegate;
@end

@protocol CateViewControllerDelegate <NSObject>

- (void)categoryViewController:(CateViewController *)viewController selectCategory:(YHBCatData *)category;

@end