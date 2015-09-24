//
//  CCTextfieldToolView.m
//  YHB_Prj
//
//  Created by yato_kami on 15/1/14.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "CCTextfieldToolView.h"

#define kBtnWidth 40

@interface CCTextfieldToolView()
{
    unary_operation_cancel _cancelBlock;
    unary_operation_cancel _comfirmBlock;
}
@property (strong, nonatomic) UIButton *comfirmBtn;
@property (strong, nonatomic) UIButton *cancelBtn;
@end
@implementation CCTextfieldToolView

- (UIButton *)comfirmBtn
{
    if (!_comfirmBtn) {
        _comfirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-kBtnWidth-10, 0, kBtnWidth, kTextFieldToolHeight)];
        _comfirmBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _comfirmBtn.titleLabel.font = kFont15;
        _comfirmBtn.backgroundColor = kClearColor;
        [_comfirmBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_comfirmBtn setTitleColor:RGBCOLOR(3, 122, 255) forState:UIControlStateNormal];
        [_comfirmBtn addTarget:self action:@selector(touchComfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _comfirmBtn;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, kBtnWidth, kTextFieldToolHeight)];
        _cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _cancelBtn.titleLabel.font = kFont15;
        _cancelBtn.backgroundColor = [UIColor clearColor];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:RGBCOLOR(3, 122, 255) forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(touchCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

+ (instancetype)toolView
{
    CCTextfieldToolView *tool = [[CCTextfieldToolView alloc] init];
    return tool;
}

- (instancetype)init
{
    self = [super init];
    self.frame = CGRectMake(0, 0, kMainScreenWidth, kTextFieldToolHeight);
    self.backgroundColor = RGBCOLOR(240, 240, 240);
    [self addSubview:self.cancelBtn];
    [self addSubview:self.comfirmBtn];
    self.layer.borderColor = [kLineColor CGColor];
    self.layer.borderWidth = 0.5f;
    
    return self;
}

- (void)showToolComfirmBlock: (unary_operation_confirm)cBlock cancelBlock:(unary_operation_cancel)cancleBlock
{
    _comfirmBlock = nil;
    _cancelBlock = nil;
    _comfirmBlock = cBlock;
    _cancelBlock = cancleBlock;
   // self.top = kMainScreenHeight;
//    [[UIApplication sharedApplication].keyWindow addSubview:self];
//    [UIView animateWithDuration:0.25f animations:^{
//        self.top = y;
//    } completion:^(BOOL finished) {
//        
//    }];
}



#pragma mark - Action
- (void)touchComfirmBtn
{
    if (_comfirmBlock) {
        _comfirmBlock();
    }
    _comfirmBlock = nil;
    _cancelBlock = nil;
   // [self dismiss];
}

- (void)touchCancelBtn
{
    if (_cancelBlock) {
        _cancelBlock();
    }
    _comfirmBlock = nil;
    _cancelBlock = nil;
  //  [self dismiss];
}

//- (void)dismiss
//{
//    [UIView animateWithDuration:0.2f animations:^{
//        self.top = kMainScreenHeight;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
//}

@end
