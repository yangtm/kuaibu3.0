//
//  YHBSegmentView.m
//  YHB_Prj
//
//  Created by 童小波 on 15/3/25.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "YHBSegmentView.h"
#import "UIViewAdditions.h"

@interface YHBSegmentView()

@property (assign, nonatomic) SEL action;
@property (assign, nonatomic) id target;
@property (strong, nonatomic) NSArray *buttonArray;
@property (assign, nonatomic) YHBSegmentViewStyle style;
@property (strong, nonatomic) UIView *bottomLineView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *arrowImageView;

@end

@implementation YHBSegmentView

- (instancetype)initWithFrame:(CGRect)frame style:(YHBSegmentViewStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        self.style = style;
        self.price = YES;
        self.contentView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_contentView];
        [self setupBorder];
    }
    return self;
}

- (void) setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    [_buttonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *button = [self customButton];
        [self setupButtonFrame:button itemNum:i];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.tag = i;
        [self.contentView addSubview:button];
        [mutableArray addObject:button];
    }
    self.buttonArray = mutableArray;
    [self setupSeparateLine];
    [self changeSelect:0];
    [self bringSubviewToFront:_bottomLineView];
}
//按钮按下
- (void)buttonClick:(UIButton *)button
{
    if (self.selectItem != button.tag) {
        [self changeSelect:button.tag];
        [self sendAction:_action to:_target forEvent:nil];
    }else{
        if (button.tag == 2) {
            _price = !_price;
            [_segmentViewDelegate getDataWithPageID:1 catIds:nil];
        }
    }
}

- (UIButton *)customButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self switchButtonNormal:button];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//将按钮设为普通状态
- (void)switchButtonNormal:(UIButton *)button
{
    switch (self.style) {
        case YHBSegmentViewStyleNormal:
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = kFont18;
            break;
        case YHBSegmentViewStyleSeparate:
            button.backgroundColor = RGBCOLOR(254, 254, 254);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = kFont16;
            break;
        case YHBSegmentViewStyleBottomLine:
            button.backgroundColor = RGBCOLOR(254, 254, 254);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = kFont16;
            break;
        case YHBSegmentViewStyleArrow:
            button.backgroundColor = [UIColor colorWithRed:0.9725 green:0.9725 blue:0.9725 alpha:1];
            [button setTitleColor:[UIColor colorWithRed:0.7882 green:0.7882 blue:0.7882 alpha:1] forState:UIControlStateNormal];
            button.titleLabel.font = kFont16;
            break;
        case YHBSegmentViewStyleBorder:
            button.backgroundColor = [UIColor clearColor];
            [button setTitleColor:RGBCOLOR(239, 64, 14) forState:UIControlStateNormal];
            button.titleLabel.font = kFont16;
            break;
        default:
            break;
    }
    
}
//将按钮设为选中状态
- (void)switchButtonSelected:(UIButton *)button
{
    switch (self.style) {
        case YHBSegmentViewStyleNormal:
            button.backgroundColor = KColor;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = kFont18;
            break;
        case YHBSegmentViewStyleSeparate:
            button.backgroundColor = RGBCOLOR(254, 254, 254);
            [button setTitleColor:KColor forState:UIControlStateNormal];
            button.titleLabel.font = kFont16;
            break;
        case YHBSegmentViewStyleBottomLine:
            button.backgroundColor = RGBCOLOR(254, 254, 254);
            [button setTitleColor:KColor forState:UIControlStateNormal];
            button.titleLabel.font = kFont16;
            break;
        case YHBSegmentViewStyleArrow:
            button.backgroundColor = [UIColor colorWithRed:0.7882 green:0.7882 blue:0.7882 alpha:1];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = kFont15;
            break;
        case YHBSegmentViewStyleBorder:
            button.backgroundColor = RGBCOLOR(230, 69, 14);
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = kFont16;
            break;
        default:
            break;
    }
}

- (void)changeSelect:(NSInteger)tag
{
    UIButton *button = _buttonArray[_selectItem];
    [self switchButtonNormal:button];
    button = _buttonArray[tag];
    [self switchButtonSelected:button];
    self.selectItem = tag;
    [self setupArrow];
}

- (void) addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if (controlEvents == UIControlEventValueChanged) {
        self.target = target;
        self.action = action;
    }
}
//设置边框
- (void) setupBorder
{
    if (self.style == YHBSegmentViewStyleSeparate) {
        self.layer.borderColor = [kLineColor CGColor];
        self.layer.borderWidth = 1.0f;
    }
    else if (self.style == YHBSegmentViewStyleBottomLine){
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 0.5, self.width, 0.5)];
        _bottomLineView.backgroundColor = kLineColor;
        [self addSubview:_bottomLineView];
    }
    else if (self.style == YHBSegmentViewStyleArrow){
        _contentView.frame = CGRectMake(0, 0, self.width, self.height);
        _contentView.layer.borderColor = [UIColor colorWithRed:0.7882 green:0.7882 blue:0.7882 alpha:1].CGColor;
        //_contentView.layer.borderWidth = 1.0;
        //_contentView.layer.cornerRadius = 4.0;
        _contentView.layer.masksToBounds = YES;
    }
    else if (self.style == YHBSegmentViewStyleBorder){
        _contentView.frame = CGRectMake(3, 4, self.width - 6, self.height - 8);
        _contentView.layer.borderColor = RGBCOLOR(230, 69, 14).CGColor;
        _contentView.layer.borderWidth = 1.0;
        _contentView.layer.cornerRadius = 4.0;
        _contentView.layer.masksToBounds = YES;
    }
}

//设置分隔线
- (void) setupSeparateLine
{
    if (self.style == YHBSegmentViewStyleSeparate || self.style == YHBSegmentViewStyleBottomLine) {
        [self removeSepareteLine];
        CGFloat width = kMainScreenWidth / self.titleArray.count;
        for (int i = 1; i < _titleArray.count; i++) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(i * width , 3, 0.5, self.height-6)];
            line.backgroundColor = kLineColor;
            line.tag = 30 + i;
            [self.contentView addSubview:line];
        }
    }
    else if (self.style == YHBSegmentViewStyleArrow){
        [self removeSepareteLine];
        CGFloat width = self.contentView.width / self.titleArray.count;
        for (int i = 1; i < _titleArray.count; i++) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(i * width , 0, 1.0, self.height)];
            line.backgroundColor = [UIColor colorWithRed:0.7882 green:0.7882 blue:0.7882 alpha:1];
            line.tag = 30 + i;
            [self.contentView addSubview:line];
        }
    }
}
- (void)setupButtonFrame:(UIButton *)button itemNum:(NSInteger)num
{
    CGFloat widthOfItem;
    CGFloat heightOfItem;
    widthOfItem = self.contentView.width / _titleArray.count;
    heightOfItem = self.contentView.height;
    button.frame = CGRectMake(num * widthOfItem, 0, widthOfItem, heightOfItem);
}

- (void)setupArrow
{
    if (self.style != YHBSegmentViewStyleArrow) {
        return;
    }
    if (_arrowImageView == nil) {
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 8)];
        _arrowImageView.image = [UIImage imageNamed:@"segment-arrow"];
        [self addSubview:_arrowImageView];
    }
    UIButton *selectButton = _buttonArray[_selectItem];
    _arrowImageView.frame = CGRectMake(selectButton.right - selectButton.width / 2.0 - 8, selectButton.bottom, 16, 8);
}

//将原来的分隔线移除
- (void) removeSepareteLine
{
    NSArray *array = self.subviews;
    for (int i = 0; i < array.count; i++) {
        UIView *view = array[i];
        if (view.tag >= 30 && view.tag < 40) {
            [view removeFromSuperview];
        }
    }
}

@end
