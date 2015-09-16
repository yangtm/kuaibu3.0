//
//  HomePageTitleHeadView.h
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/10.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HomePageTitleHeadViewDelegate <NSObject>
-(void)selectTag:(NSInteger ) tag;
@end

@interface HomePageTitleHeadView : UICollectionReusableView

@property (assign, nonatomic) NSInteger collectViewNum;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@property(strong,nonatomic) id<HomePageTitleHeadViewDelegate>HomePageTitleHeadViewDelegate;

@end
