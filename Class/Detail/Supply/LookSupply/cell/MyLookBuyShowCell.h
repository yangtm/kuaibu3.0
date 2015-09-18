//
//  MyLookBuyShowCell.h
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/15.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyLookBuyShowCellDelegate;

@interface MyLookBuyShowCell : UITableViewCell
@property (nonatomic,strong) UIImageView *rightImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *amountLabel;
@property (nonatomic,strong) UILabel *amountStoreLabel;
@property (nonatomic,strong) UILabel *creatdateLabel;
@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) UILabel *unitLabel1;
@property (nonatomic,strong) UILabel *unitLabel2;
@property (assign, nonatomic) BOOL hasSound;
@property (nonatomic,strong) UIButton *soundButton;
@property (strong, nonatomic) UIImageView *soundPlayImageView;
@property (assign, nonatomic) NSInteger *type;
@property (assign, nonatomic) BOOL isPlay;
@property (assign, nonatomic) id<MyLookBuyShowCellDelegate> delegate;
-(void)configWithAmount:(NSString *)amount storenum:(NSString *)number unit:(NSString *)unit type:(NSInteger) type;
@end

@protocol MyLookBuyShowCellDelegate <NSObject>

- (void)MycellDidBeginPlaySound:(MyLookBuyShowCell *)cell;
- (void)MycellDidEndPlaySound:(MyLookBuyShowCell *)cell;

@end