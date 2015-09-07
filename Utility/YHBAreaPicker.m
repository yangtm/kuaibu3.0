//
//  YHBAreaPicker.m
//  YHB_Prj
//
//  Created by 童小波 on 15/6/4.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "YHBAreaPicker.h"
#import "Public.h"
#import "AppDelegate.h"
#import "UIViewAdditions.h"

static YHBAreaPicker *areaPicker = nil;
const CGFloat HeightOfAreaView = 160;

@interface YHBAreaPicker()

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIToolbar *toolBar;
@property (strong, nonatomic) UIPickerView *pickerView;

@end

@implementation YHBAreaPicker

+ (void)showPicker
{
    if (areaPicker == nil) {
        areaPicker = [[YHBAreaPicker alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    }
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    UIWindow *window = appDelegate.window;
    
    [window addSubview:areaPicker];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.toolBar];
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    _contentView.layer.transform = CATransform3DTranslate(_contentView.layer.transform, 0, HeightOfAreaView, 0);
    [UIView animateWithDuration:0.6 animations:^{
        
        _contentView.layer.transform = CATransform3DIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (UIView *)contentView
{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - HeightOfAreaView, self.width, HeightOfAreaView)];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UIToolbar *)toolBar
{
    if (_toolBar == nil) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
        _toolBar.backgroundColor = RGBCOLOR(240, 240, 240);
        UIButton *cancelButton;
    }
    return _toolBar;
}

@end
