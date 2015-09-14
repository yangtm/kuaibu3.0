//
//  MyheaderCell.h
//  kuaibu
//
//  Created by zxy on 15/9/14.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyheaderCell;
@protocol MyheaderCellDelagate <NSObject>

- (void)clickSettingBtn:(MyheaderCell *)cell;
- (void)clickPortraitImageView:(MyheaderCell *)cell;
- (void)clickMessageImageView:(MyheaderCell *)cell;
@end


@interface MyheaderCell : UITableViewCell

@property (nonatomic,strong) UIButton *portraitImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *integralLabel;
@property (nonatomic,strong) UIButton *settingButton;
@property (nonatomic,strong) UIButton *messageImageView;

@property (assign, nonatomic) id<MyheaderCellDelagate> delegate;

@end
