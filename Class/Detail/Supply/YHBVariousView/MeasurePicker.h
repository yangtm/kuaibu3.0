//
//  MeasurePicker.h
//  YHB_Prj
//
//  Created by 童小波 on 15/6/1.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MeasurePickerCell;

@protocol MeasurePickerCellDelegate <NSObject>

- (void)measurePickerCellDidTap:(MeasurePickerCell *)cell;

@end

@interface MeasurePickerCell : UITableViewCell{
    UILabel *_label;
    UIImageView *_imageView;
    UIView *_lineView;
}

@property (assign, nonatomic) id<MeasurePickerCellDelegate> delegate;
@property (assign, nonatomic) BOOL isHead;
@property (strong, nonatomic) NSString *title;

@end


@interface MeasurePicker : UIView<UITableViewDataSource, UITableViewDelegate, MeasurePickerCellDelegate>{
    UILabel *_label;
    UIImageView *_imageView;
    UITableView *_tableView;
    UIView *_attachView;
    BOOL _extended;
}
//@property (strong,nonatomic) UILabel *label;
@property (assign, nonatomic) NSInteger selectItem;
@property (strong, nonatomic) NSArray *dataArray;

- (instancetype)initWithFrame:(CGRect)frame attachView:(UIView *)attachView dataArray:(NSArray *)dataArray;

@end
