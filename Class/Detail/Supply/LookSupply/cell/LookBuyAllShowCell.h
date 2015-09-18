//
//  LookBuyAllShowCell.h
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/15.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LookBuyAllShowCellDelegate;
@interface LookBuyAllShowCell : UITableViewCell
@property (nonatomic,strong) UIImageView *rightImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *amountLabel;
@property (nonatomic,strong) UILabel *creatdateLabel;
@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) UILabel *unitLabel2;
@property (nonatomic,strong) UIButton *soundButton;
@property (strong, nonatomic) UIImageView *soundPlayImageView;
@property (assign, nonatomic) NSInteger *type;
@property (assign, nonatomic) BOOL hasSound;
@property (assign, nonatomic) id<LookBuyAllShowCellDelegate> delegate;
@property (assign, nonatomic) BOOL isPlay;
-(void)configWithAmount:(NSString *)amount unit:(NSString *)unit type:(NSInteger) type;
@end

@protocol LookBuyAllShowCellDelegate <NSObject>

- (void)cellDidBeginPlaySound:(LookBuyAllShowCell *)cell;
- (void)cellDidEndPlaySound:(LookBuyAllShowCell *)cell;

@end