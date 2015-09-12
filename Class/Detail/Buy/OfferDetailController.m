//
//  OfferDetailController.m
//  kuaibu
//
//  Created by zxy on 15/9/12.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "OfferDetailController.h"

#define kLineTag 80

@interface OfferDetailController ()<UIScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *offerDetailFormView;

@property (nonatomic,strong) UIButton *uploadButton;
@property (nonatomic,strong) UITextField *priceTextField;

@end

@implementation OfferDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settitleLabel:@"我要报价"];
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(back)];
    self.view.backgroundColor = RGBCOLOR(241, 241, 241);
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.offerDetailFormView];
    [self setupFormView];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 报价详情UI
- (void)setupFormView
{
    UIView *view1 = [self samplePhotoForm:CGRectMake(0, 0, kMainScreenWidth, 100)];
    [self.offerDetailFormView addSubview:view1];
    self.offerDetailFormView.frame = CGRectMake(0, 10, kMainScreenWidth, 100);
}

#pragma mark - 样张UI
- (UIView *)samplePhotoForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 60, 60) title:@"样张 : "];
    [view addSubview:label];
    
    _uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_uploadButton setTitle:@"上传一张图片" forState:UIControlStateNormal];
    _uploadButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_uploadButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _uploadButton.layer.masksToBounds = YES;
    _uploadButton.layer.borderColor = kNaviTitleColor.CGColor;
    _uploadButton.layer.borderWidth = 1;
    _uploadButton.layer.cornerRadius = 5;
    _uploadButton.frame = CGRectMake(label.right + 10, 5, 90, 90);
    [_uploadButton addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_uploadButton];
//    [self addBottomLine:view];
    return view;
}

#pragma mark - 单价UI
- (UIView *)priceForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 60, view.height) title:@"样张 : "];
//    _priceTextField
    [view addSubview:label];
    return view;
}

#pragma mark - 上传图片
- (void)clickBtn
{
    NSLog(@"上传图片");
}

#pragma mark -getter&setter
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64)];
        //        _scrollView.backgroundColor = [UIColor redColor];
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIView *)offerDetailFormView
{
    if (_offerDetailFormView == nil) {
        _offerDetailFormView = [[UIView alloc] initWithFrame:CGRectZero];
        _offerDetailFormView.backgroundColor = [UIColor whiteColor];
    }
    return _offerDetailFormView;
}

- (UITextField *)priceTextField
{
    if (_priceTextField ==nil) {
        _priceTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _priceTextField.font = [UIFont systemFontOfSize:15.0];
        _priceTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _priceTextField.returnKeyType = UIReturnKeyDone;
        _priceTextField.placeholder = @"请输入你的单价";
        _priceTextField.delegate = self;
    }
    return _priceTextField;
}


- (UILabel *)formTitleLabel:(CGRect)frame title:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:15];
    label.text = title;
    [self shadedStar:label];
    return label;
}

- (void) shadedStar:(UILabel *)label
{
    if ([label.text hasPrefix:@"*"]) {
        NSMutableAttributedString *attrubuteStr = [[NSMutableAttributedString alloc] initWithString:label.text];
        [attrubuteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
        [attrubuteStr addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:-2.0] range:NSMakeRange(0, 1)];
        label.attributedText = attrubuteStr;
    }
}

- (void)addBottomLine:(UIView *)view
{
    UIView *lineView = [self lineView:CGRectMake(0, view.height - 0.5, 0, 0)];
    lineView.tag = kLineTag;
    [view addSubview:lineView];
}

- (UIView *)lineView:(CGRect)frame
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, kMainScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    return lineView;
}
@end
