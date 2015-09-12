//
//  HeaderSectionCell.h
//  kuaibu
//
//  Created by zxy on 15/9/12.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeaderSectionCell;
@protocol HeaderSectionCellDelagate <NSObject>

- (void)clickSettingBtn:(HeaderSectionCell *)cell;
- (void)clickPortraitImageView:(HeaderSectionCell *)cell;
- (void)clickMessageImageView:(HeaderSectionCell *)cell;
@end


@interface HeaderSectionCell : UITableViewCell

@property (nonatomic,strong) UIButton *portraitImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *integralLabel;
@property (nonatomic,strong) UIButton *settingButton;
@property (nonatomic,strong) UIButton *messageImageView;

@property (assign, nonatomic) id<HeaderSectionCellDelagate> delegate;

@end
