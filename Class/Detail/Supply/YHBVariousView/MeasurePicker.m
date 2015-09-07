//
//  MeasurePicker.m
//  YHB_Prj
//
//  Created by 童小波 on 15/6/1.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "MeasurePicker.h"
#import "UIViewAdditions.h"

@implementation MeasurePickerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:14.0];
        _label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_label];
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"indicate-arrow"];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_lineView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [self.contentView addGestureRecognizer:tap];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_isHead) {
        self.contentView.backgroundColor = [UIColor redColor];
        _label.frame = CGRectMake(0, 0, self.width - 15, self.height);
        _label.textColor = [UIColor whiteColor];
        _imageView.frame = CGRectMake(self.width - 15, 0, 8, self.height);
        _imageView.hidden = NO;
    }
    else{
        self.contentView.backgroundColor = [UIColor whiteColor];
        _label.frame = self.bounds;
        _label.textColor = [UIColor blackColor];
        _imageView.hidden = YES;
    }
    _lineView.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
}

- (void)didTap:(UITapGestureRecognizer *)tap
{
    [_delegate measurePickerCellDidTap:self];
}

- (void)setIsHead:(BOOL)isHead
{
    _isHead = isHead;
    [self layoutSubviews];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _label.text = title;
}

@end

/******************************************************************************/

@implementation MeasurePicker

- (instancetype)initWithFrame:(CGRect)frame attachView:(UIView *)attachView dataArray:(NSArray *)dataArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        _attachView = attachView;
        _dataArray = dataArray;
        [self setup];
    }
    return self;
}

#pragma mark - event resposne
- (void)viewDidTap:(UITapGestureRecognizer *)tap
{
    if (_extended) {
        CGRect frame = _tableView.frame;
        frame.size.height = self.height;
        [UIView animateWithDuration:0.2 animations:^{
            _tableView.frame = frame;
        } completion:^(BOOL finished) {
            _tableView.frame = self.bounds;
            [_tableView removeFromSuperview];
            [self addSubview:_tableView];
        }];
    }
    else{
        CGRect frame = [self convertRect:CGRectMake(0, 0, self.width, self.height) toView:_attachView];
        _tableView.frame = frame;
        [_tableView removeFromSuperview];
        [_attachView addSubview:_tableView];
        frame.size.height = self.height * (_dataArray.count + 1);
        [UIView animateWithDuration:0.3 animations:^{
            _tableView.frame = frame;
        }];
    }
    _extended = !_extended;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeasurePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell == nil) {
        cell = [[MeasurePickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        cell.delegate = self;
    }
    if (indexPath.row == 0) {
        cell.title = _dataArray[_selectItem];
        cell.isHead = YES;
    }
    else{
        cell.title = _dataArray[indexPath.row - 1];
        cell.isHead = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.height;
}

- (void)measurePickerCellDidTap:(MeasurePickerCell *)cell
{
    if (_extended) {
        CGRect frame = _tableView.frame;
        frame.size.height = self.height;
        [UIView animateWithDuration:0.2 animations:^{
            _tableView.frame = frame;
        } completion:^(BOOL finished) {
            _tableView.frame = self.bounds;
            [_tableView removeFromSuperview];
            [self addSubview:_tableView];
        }];
    }
    else{
        CGRect frame = [self convertRect:CGRectMake(0, 0, self.width, self.height) toView:_attachView];
        _tableView.frame = frame;
        [_tableView removeFromSuperview];
        [_attachView addSubview:_tableView];
        frame.size.height = self.height * (_dataArray.count + 1);
        [UIView animateWithDuration:0.3 animations:^{
            _tableView.frame = frame;
        }];
    }
    _extended = !_extended;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if (indexPath.row != 0) {
        _selectItem = indexPath.row - 1;
        [_tableView reloadData];
    }
}

#pragma mark - private methods
- (void)setup
{
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableView.layer.borderColor = [UIColor redColor].CGColor;
    _tableView.layer.borderWidth = 1.0;
    _tableView.layer.cornerRadius = self.height / 2.0;
    _tableView.layer.masksToBounds = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;
    [self addSubview:_tableView];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _tableView.frame = self.bounds;
    [self bringSubviewToFront:_tableView];
}

- (void)setSelectItem:(NSInteger)selectItem
{
    _selectItem = selectItem;
    
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [_tableView reloadData];
}

@end
