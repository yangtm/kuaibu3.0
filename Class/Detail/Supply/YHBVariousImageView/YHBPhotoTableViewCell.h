//
//  YHBPhotoTableViewCell.h
//  YHB_Prj
//
//  Created by Johnny's on 14/11/30.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YHBPhotoTableViewCell;
@protocol YHBPhotoCellDelegate <NSObject>

- (void)selectCellWithRow:(int)aRow index:(int)aIndex andCell:(YHBPhotoTableViewCell *)aCell;

@end

@interface YHBPhotoTableViewCell : UITableViewCell

@property (nonatomic, strong) id<YHBPhotoCellDelegate>delegate;

@property (nonatomic, assign) int imgcount;
@property (nonatomic, assign) int row;
@property (nonatomic, assign) int index;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end