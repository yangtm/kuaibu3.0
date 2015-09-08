//
//  BannerView.h
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/7.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BannerDelegate <NSObject>

- (void)touchBannerWithNum:(NSInteger)num;

@optional
- (void)didScrollOverRight;

@end

@interface BannerView : UIView<UIScrollViewDelegate>

//是否需要循环滚动
@property (assign, nonatomic) BOOL isNeedCycle;
//是否需要自动滚动
@property (assign, nonatomic) BOOL autoRoll;
//自动滚动时间间隔
@property (assign, nonatomic) NSInteger duration;
//是否隐藏分页控制器
@property (assign, nonatomic) BOOL hidePageControl;

@property (weak, nonatomic) id<BannerDelegate> delegate;

- (void)resetUIWithUrlStrArray:(NSArray *)urlArray;

//开始滚动
- (void)startRoll;
//停止滚动
- (void)stopRoll;

@end
