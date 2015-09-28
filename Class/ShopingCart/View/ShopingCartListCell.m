//
//  ShopingCartListCell.m
//  kuaibu
//
//  Created by 朱新余 on 15/9/28.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "ShopingCartListCell.h"
#import "CCTextfieldToolView.h"
@implementation ShopingCartListCell
{
    CCTextfieldToolView *_toolView;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        _number = 1;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _selectButton.frame = CGRectMake(10, 40, 20, 20);
    _productImage.frame = CGRectMake(45, 10, 80, 80);
    _detailLabel.frame = CGRectMake(_productImage.right+5, 10, kMainScreenWidth - _selectButton.width - _productImage.width - 40, 40);
    _priceLabel.frame = CGRectMake(_productImage.right+5, _detailLabel.bottom, 80, 20);
    _reduceButton.frame = CGRectMake(_detailLabel.right - 90, _priceLabel.bottom, 20, 20);
//    _numControl.frame = CGRectMake(self.right - 120, _priceLabel.bottom - 5, 60, 15);
    _showTextField.frame = CGRectMake(_reduceButton.right, _priceLabel.bottom, 30, 20);
    _increaseButton.frame = CGRectMake(_showTextField.right, _priceLabel.bottom, 20, 20);
}

- (void)setup{
    
    _selectButton = [MyUtil createButton:CGRectZero title:nil BtnImage:@"weixuanzhong" selectImageName:nil target:self action:@selector(clickAction)];
    [self.contentView addSubview:_selectButton];
    
    _productImage = [MyUtil createImageView:CGRectZero imageName:@"iconfont-tupian"];
    _productImage.layer.cornerRadius = 5;
    _productImage.layer.masksToBounds = YES;
    [self.contentView addSubview:_productImage];
    
    _detailLabel = [MyUtil createLabel:CGRectZero text:@"产品描述产品描述产品描述产品描述产品描述产品描述产品描述产品描述产品描述" alignment:NSTextAlignmentLeft fontSize:14];
    _detailLabel.numberOfLines = 2;
    [self.contentView addSubview:_detailLabel];
    
    _priceLabel = [MyUtil createLabel:CGRectZero text:@"¥3434" alignment:NSTextAlignmentLeft fontSize:14];
    _priceLabel.textColor = kBackgroundColor;
    [self.contentView addSubview:_priceLabel];
    
    _reduceButton = [MyUtil createButton:CGRectZero title:@"-" BtnImage:nil selectImageName:nil target:self action:@selector(clickReduceBtn)];
    _reduceButton.layer.borderWidth = 0.5;
    [_reduceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _reduceButton.layer.borderColor = [UIColor grayColor].CGColor;
    [self.contentView addSubview:_reduceButton];
    
    _showTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _showTextField.font = [UIFont systemFontOfSize:14];
    _showTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _showTextField.returnKeyType = UIReturnKeyDone;
//    _showTextField.placeholder = @"1";
    _showTextField.text = @"1";
    _showTextField.delegate = self;
    _showTextField.layer.borderWidth = 0.5f;
    _showTextField.layer.borderColor = [UIColor grayColor].CGColor;
    _showTextField.textAlignment = NSTextAlignmentCenter;
    if (!_toolView) {
        _toolView = [CCTextfieldToolView toolView];
    }
    _showTextField.inputAccessoryView = _toolView;
    _showTextField.textColor = [UIColor blackColor];

    [self.contentView addSubview:_showTextField];
//    _numControl = [[YHBNumControl alloc] init];
    
    _increaseButton = [MyUtil createButton:CGRectZero title:@"+" BtnImage:nil selectImageName:nil target:self action:@selector(clickIncreaseBtn)];
    _increaseButton.layer.borderWidth = 0.5;
    [_increaseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _increaseButton.layer.borderColor = [UIColor grayColor].CGColor;
    [self.contentView addSubview:_increaseButton];

}

- (void)clickAction{
    if ([_delegate respondsToSelector:@selector(clickSelectBtn:)]) {
        [_delegate clickSelectBtn:self];
    }
}

- (void)clickReduceBtn{
    if ([_delegate respondsToSelector:@selector(clickReduceBtn:)]) {
        [_delegate clickReduceBtn:self];
    }
}

- (void)clickIncreaseBtn{
    if ([_delegate respondsToSelector:@selector(clickIncreaseBtn:)]) {
        [_delegate clickIncreaseBtn:self];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSString *oldText = _showTextField.text;
    [_toolView showToolComfirmBlock:^{
        [_showTextField resignFirstResponder];
        [self endEditing:YES];
        double thNum = [_showTextField.text doubleValue];
        self.number = ((int)(thNum *10))/10.0f;
//        if ([self.delegate respondsToSelector:@selector(numberControlValueDidChanged)]) {
//            [self.delegate numberControlValueDidChanged:self];
//        }
    } cancelBlock:^{
        [_showTextField resignFirstResponder];
        _showTextField.text = [oldText copy];
    }];
    
    if ([self.delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        [self.delegate textFieldShouldBeginEditing:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        [self.delegate textFieldShouldEndEditing:textField];
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_showTextField resignFirstResponder];
}

@end
