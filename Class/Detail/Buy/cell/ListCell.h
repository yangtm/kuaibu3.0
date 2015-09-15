//
//  ListCell.h
//  kuaibu
//
//  Created by zxy on 15/9/11.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ListCell;
@protocol ListCellDelagate <NSObject>

- (void)cilckOfferManagerBtn;

@end

@interface ListCell : UITableViewCell

@property (nonatomic,strong) UIImageView *rightImageView;
@property (nonatomic,strong) UILabel *cycleLabel;
@property (nonatomic,strong) UILabel *numberLabel;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UILabel *indexLabel;
@property (nonatomic,strong) UIButton *clickBtn;
@property (nonatomic,strong) UILabel *offLabel;

@property (nonatomic,strong) NSString *cycleStr;
@property (assign,nonatomic) double numberStr;
@property (nonatomic,strong) NSString *dataStr;
@property (nonatomic,strong) NSString *typeStr;
@property (nonatomic,strong) NSString *indexStr;
@property (assign, nonatomic) id<ListCellDelagate> delegate;
@end
