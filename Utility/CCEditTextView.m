//
//  CCEditTextView.m
//  YHB_Prj
//
//  Created by yato_kami on 14/12/2.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "CCEditTextView.h"
#define kIWidth (kMainScreenWidth-40)

@interface CCEditTextView()<UITextFieldDelegate,UITextViewDelegate>
{
//    unary_operation_comfirm _comfirmblock;
    BOOL(^_comfirmblock)(NSString *text);
    unary_operation_cancel _cancelblock;
}
@property (strong, nonatomic) UIView *inputView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UITextField *textfield;
@property (strong, nonatomic) UIButton *cancalButton;
@property (strong, nonatomic) UIButton *confirmButton;
@property (strong, nonatomic) UIView *dimView;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UILabel *reminderLabel;
@end

@implementation CCEditTextView

- (UIView *)dimView
{
    if (!_dimView) {
        _dimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        _dimView.backgroundColor = [UIColor blackColor];
        _dimView.alpha = 0.75;
    }
    return _dimView;
}

- (UIView *)inputView
{
    if (!_inputView) {
        _inputView = [[UIView alloc] initWithFrame:CGRectMake((kMainScreenWidth - kIWidth)/2.0, 60, kIWidth, 160)];
        _inputView.backgroundColor = RGBCOLOR(248, 248, 248);
        _inputView.alpha = 1.0f;
        _inputView.layer.borderWidth = 0.6;
        _inputView.layer.cornerRadius = 4.0f;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, kIWidth-20, 15)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = kFont16;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_inputView addSubview:_titleLabel];
        
        _textfield = [[UITextField alloc] initWithFrame:CGRectMake(10, _titleLabel.bottom+20, kIWidth-20, 40)];
        _textfield.backgroundColor = [UIColor whiteColor];
        _textfield.layer.cornerRadius = 4.0;
        _textfield.layer.borderWidth = 0.5;
        _textfield.delegate = self;
        [_textfield setClearButtonMode:UITextFieldViewModeAlways];;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, _textfield.height)];
        view.backgroundColor = [UIColor clearColor];
        _textfield.leftView = view;
        _textfield.leftViewMode = UITextFieldViewModeAlways;
        
        _textfield.layer.borderColor = [kLineColor CGColor];
        [_inputView addSubview:_textfield];
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, _titleLabel.bottom+10, kIWidth-20, 60)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.layer.cornerRadius = 4.0;
        _textView.layer.borderWidth = 0.5;
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:12];
        _textView.layer.borderColor = [kLineColor CGColor];
        [_inputView addSubview:_textView];
        
        //错误提示
        _reminderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _textView.bottom, kIWidth-20, 10)];
        _reminderLabel.textColor = [UIColor redColor];
        _reminderLabel.font = [UIFont systemFontOfSize:10.0];
        [_inputView addSubview:_reminderLabel];
        
        _cancalButton = [[UIButton alloc] initWithFrame:CGRectMake(10, _textfield.bottom + 20, (kIWidth-20-10)/2.0, 30)];
        [_cancalButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancalButton.layer.borderWidth = 0.5f;
        _cancalButton.layer.borderColor = [kLineColor CGColor];
        [_cancalButton setTitle:@" 取消" forState:UIControlStateNormal];
        _cancalButton.titleLabel.font = kFont14;
        [_cancalButton setBackgroundColor:[UIColor whiteColor]];
        [_cancalButton addTarget:self action:@selector(touchCancelButton) forControlEvents:UIControlEventTouchUpInside];
        [_inputView addSubview:_cancalButton];
        
        _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(_cancalButton.right+10, _textfield.bottom + 20, (kIWidth-20-10)/2.0, 30)];
        [_confirmButton setBackgroundColor:[UIColor whiteColor]];
        [_confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _confirmButton.layer.borderWidth = 0.5f;
        _confirmButton.layer.borderColor = [kLineColor CGColor];
        [_confirmButton setTitle:@" 确定" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = kFont14;
        [_confirmButton addTarget:self action:@selector(touchConfirmButton) forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton setTitleColor:KColor forState:UIControlStateNormal];
        [_inputView addSubview:_confirmButton];
        
    }
    return _inputView;
}

+ (instancetype )sharedView
{
    static dispatch_once_t once;
    static CCEditTextView *sharedView;
    //dispatch_once_t(&once,^{ sharedView = [[CCEditTextView alloc] init]})
    dispatch_once(&once, ^{
        sharedView = [[CCEditTextView alloc] init];
    });
    return sharedView;
}

- (instancetype)init
{
    self = [super init];
    self.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.inputView];
    
    return self;
}
- (void)showEditTextViewWithTitle:(NSString *)title textfieldText:(NSString *)text comfirmBlock: (BOOL(^)(NSString *txt))cBlock cancelBlock:(CANCELBLOCK)cancleBlock
{
    _comfirmblock = nil;
    _cancelblock = nil;
    [[UIApplication sharedApplication].keyWindow addSubview:self.dimView];
    self.titleLabel.text = title ? :@"";
    self.textfield.text = text ? :@"";
    self.textView.hidden = YES;
    self.textfield.hidden = NO;
    self.reminderLabel.frame = CGRectMake(10, _textfield.bottom + 5, kIWidth-20, 10);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.textfield becomeFirstResponder];
    
    _comfirmblock = cBlock;
    _cancelblock = cancleBlock;
    
}

- (void)showLargeEditTextViewWithTitle:(NSString *)title textfieldText:(NSString *)text comfirmBlock: (BOOL(^)(NSString *txt))cBlock cancelBlock:(CANCELBLOCK)cancleBlock
{
    _comfirmblock = nil;
    _cancelblock = nil;
    [[UIApplication sharedApplication].keyWindow addSubview:self.dimView];
    self.titleLabel.text = title ? :@"";
    self.textView.text = text ? :@"";
    self.textView.hidden = NO;
    self.textfield.hidden = YES;
    self.reminderLabel.frame = CGRectMake(10, _textView.bottom, kIWidth-20, 10);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.textView becomeFirstResponder];
    
    _comfirmblock = cBlock;
    _cancelblock = cancleBlock;
}

#pragma mark - action
- (void)touchCancelButton
{
    self.reminderLabel.text = @"";
    [self.textfield resignFirstResponder];
    [self.textView resignFirstResponder];
    [self removeFromSuperview];
    [self.dimView removeFromSuperview];
    if (_cancelblock) {
        _cancelblock();
    }
}

- (void)touchConfirmButton
{
    BOOL ret = YES;
    if (_comfirmblock) {
        NSString *text = self.textView.isHidden ? [self.textfield.text copy] : [self.textView.text copy];
        ret = _comfirmblock(text);
    }
    if (ret) {
        self.reminderLabel.text = @"";
        [self.textfield resignFirstResponder];
        [self.textView resignFirstResponder];
        [self removeFromSuperview];
        [self.dimView removeFromSuperview];
    }
    else{
        self.reminderLabel.text = self.reminderStr;
    }
}

#pragma mark - delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self touchConfirmButton];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.reminderLabel.text = @"";
    return YES;
}


@end
