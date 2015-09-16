//
//  LookBuyAllShowCell.h
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/15.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LookBuyAllShowCell : UITableViewCell
@property (nonatomic,strong) UIImageView *rightImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *lastdateLabel;
@property (nonatomic,strong) UILabel *amountLabel;
@property (nonatomic,strong) UILabel *creatdateLabel;
@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) UILabel *unitLabel1;
@property (nonatomic,strong) UILabel *unitLabel2;
-(void)configWithLastdate:(NSString *)Lastdate amount:(NSString *)amount unit:(NSString *)unit;
@end
