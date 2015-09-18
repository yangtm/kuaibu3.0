//
//  PublishSupplyViewController.m
//  kuaibu
//
//  Created by zxy on 15/9/17.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "PublishSupplyViewController.h"
#import "YHBPictureAdder.h"

@interface PublishSupplyViewController ()<UIScrollViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) YHBPictureAdder *pictureAdder;
@property (nonatomic, strong) UIView *editFormView;
@property (nonatomic, strong) UIView *contactView;

@property (nonatomic,strong) UITextField *nameTextField;
@property (nonatomic,strong) UITextField *categoryTextField;

@end

@implementation PublishSupplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(dismissSelf)];
    
    self.title = @"发布供应";
    self.view.backgroundColor = RGBCOLOR(241, 241, 241);
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.pictureAdder];
    [self.scrollView addSubview:self.editFormView];
    [self.scrollView addSubview:self.contactView];
    
    [self setupFormView];
    [self setupContactView];
    // Do any additional setup after loading the view.
}

#pragma mark 返回
- (void)dismissSelf
{
//    if (!webEdit) {
//        [self saveBackup];
//    }
//    [self dismissFlower];
    //    [[CategoryViewController sharedInstancetype] cleanAll];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 编辑部分
- (void)setupFormView{
    UIView *view1 = [self headForm:CGRectMake(0, 0, kMainScreenWidth, 30)];
    [self.editFormView addSubview:view1];
    
    UIView *view2 = [self titleForm:CGRectMake(0, view1.bottom, kMainScreenWidth, 40)];
    [self.editFormView addSubview:view2];
    
    UIView *view3 = [self categoryForm:CGRectMake(0, view2.bottom, kMainScreenWidth, view2.height)];
    [self.editFormView addSubview:view3];
    
    self.editFormView.frame = CGRectMake(0, self.pictureAdder.bottom, kMainScreenWidth, view3.bottom);
    
    
}

- (void)setupContactView{
    
}

- (UIView *)headForm:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = kFont12;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    label.text = @"请上传清晰可辨的布料或成品照片";
    UIView *topLineView = [self lineView:CGRectMake(0, 0, 0, 0)];
    [label addSubview:topLineView];
    [self addBottomLine:label];
    return label;
}

#pragma mark - 布料名称UI
- (UIView *)titleForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 80, view.height) title:@"*布料名称 : "];
    [view addSubview:label];
    
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(label.right, 0, kMainScreenWidth - label.width - 20, view.height)];
    _nameTextField.font = [UIFont systemFontOfSize:15];
    _nameTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _nameTextField.returnKeyType = UIReturnKeyDone;
    _nameTextField.placeholder = @"请选择或输入布料名称";
//    [_nameTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _nameTextField.delegate = self;
    [view addSubview:_nameTextField];
    [self addBottomLine:view];
    
    return view;
}

#pragma mark - 布料分类UI
- (UIView *)categoryForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 80, view.height) title:@"*布料分类 : "];
    [view addSubview:label];
    
    return view;
}


#pragma mark - getters and setters
- (YHBPictureAdder *)pictureAdder
{
    if (_pictureAdder == nil) {
        _pictureAdder = [[YHBPictureAdder alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 120) contentController:self];
        _pictureAdder.enableEdit = YES;
    }
    return _pictureAdder;
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIView *)editFormView
{
    if (_editFormView == nil) {
        _editFormView = [[UIView alloc] initWithFrame:CGRectZero];
        _editFormView.backgroundColor = [UIColor whiteColor];
    }
    return _editFormView;
}

- (UIView *)contactView
{
    if (_contactView == nil) {
        _contactView = [[UIView alloc] initWithFrame:CGRectZero];
        _contactView.backgroundColor = [UIColor whiteColor];
    }
    return _contactView;
}


- (UILabel *)formTitleLabel:(CGRect)frame title:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:15];
    label.text = title;
    [self shadedStar:label];
    return label;
}

- (void)addBottomLine:(UIView *)view
{
    UIView *lineView = [self lineView:CGRectMake(0, view.height - 0.5, 0, 0)];
    lineView.tag = 103;
    [view addSubview:lineView];
}

- (UIView *)lineView:(CGRect)frame
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, kMainScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    return lineView;
}

- (UIImageView *)arrowImageView:(CGRect)frame
{
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:frame];
    arrowImageView.image = [UIImage imageNamed:@"rightArrow"];
    arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    return arrowImageView;
}

//检查照片是否为空
- (BOOL) checkoutImgae
{
    if (self.pictureAdder.imageCount > 0){
        return YES;
    }
    return NO;
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

@end
