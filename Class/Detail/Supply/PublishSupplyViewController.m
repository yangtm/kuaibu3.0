//
//  PublishSupplyViewController.m
//  kuaibu
//
//  Created by zxy on 15/9/17.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "PublishSupplyViewController.h"
#import "YHBPictureAdder.h"
#import "YHBVariousView.h"
#import "MyButton.h"
#import "YHBRadioBox.h"
#import "SVProgressHUD.h"
#import "TitleTagViewController.h"
#import "CategoryViewController.h"
#import "YHBCatSubcate.h"
#import "UIScrollView+AvoidingKeyboard.h"
#import "MeasurePicker.h"
#import "NormsViewController.h"

@interface PublishSupplyViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    BOOL _isSelect;
    BOOL _isSpot;
    BOOL _isCut;
    BOOL _isSelectBtn;
    BOOL isClean;
    NSString *catidString;
    float price;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) YHBPictureAdder *pictureAdder;
@property (nonatomic, strong) UIView *editFormView;
@property (nonatomic, strong) UIView *contactView;

@property (nonatomic,strong) UITextField *nameTextField;
@property (nonatomic,strong) UITextField *categoryTextField;
@property (nonatomic,strong) UITextField *priceTextField;
@property (nonatomic,strong) YHBVariousView *variousView;
@property (nonatomic,strong) MeasurePicker *measurePicker;
@property (nonatomic,strong) UITextField *normsTextField;
@property (nonatomic,strong) UITextView *detailTextView;
@property (nonatomic,strong) UITextField *attributesTextField;
@property (nonatomic,strong) MyButton *btn1;
@property (nonatomic,strong) MyButton *btn2;
@property (nonatomic,strong) MyButton *btn3;
@property (nonatomic,strong) MyButton *btn4;
@property (nonatomic,strong) MyButton *btn5;
@property (nonatomic,strong) MyButton *btn6;

@property (nonatomic, strong) UITextField *currentTextField;
@property (nonatomic, strong) UITextField *contactNameTextField;
@property (nonatomic, strong) UITextField *contactPhoneTextField;
@property (nonatomic, strong) YHBRadioBox *publicPhoneRadiBox;
@property (nonatomic, strong) UIButton *publishButton;
@end

@implementation PublishSupplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(dismissSelf)];
    
    self.title = @"发布商品";
    self.view.backgroundColor = RGBCOLOR(241, 241, 241);
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.pictureAdder];
    [self.scrollView addSubview:self.editFormView];
//    [self.scrollView addSubview:self.contactView];
    [self.view addSubview:self.publishButton];
    [self setupFormView];
//    [self setupContactView];
    self.publishButton.frame = CGRectMake(0, kMainScreenHeight - 44, kMainScreenWidth, 44);
    self.scrollView.contentSize = CGSizeMake(kMainScreenWidth, self.editFormView.bottom + 60);
    [self.scrollView autoAdjust];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _nameTextField) {
        [_currentTextField resignFirstResponder];
        _currentTextField = nil;
        [self showTitletTagView];
        return NO;
    }
    else if (textField == _categoryTextField){
        [_currentTextField resignFirstResponder];
        _currentTextField = nil;
        [self showCategoryView];
        return NO;
    }
//    else if (textField == _priceTextField){
//        [_currentTextField resignFirstResponder];
//        _currentTextField = nil;
////        [self showDayPicker];
//        return NO;
//    }
    else if (textField == _normsTextField){
        [_currentTextField resignFirstResponder];
        _currentTextField = nil;
        [self showNormsView];
        return NO;
    }
    _currentTextField = textField;
    return YES;
}

#pragma mark - 规格界面
- (void)showNormsView
{
    _normsTextField.text = @"";
    NormsViewController *vc = [[NormsViewController alloc] init];
//    [vc.manager deleteAlls];
    [vc strBlock:^(NSString *title) {
        _normsTextField.text = title;
    }];
    [vc useBlock:^(NSArray *normsArray) {
       
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark 键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    if (textField==_priceTextField)
    {
        if ([self isPureFloat:_priceTextField.text])
        {
            price = [textField.text floatValue];
            [textField resignFirstResponder];
            [self keyboardDidDisappear];
        }
        else
        {
            price=0;
            [SVProgressHUD showErrorWithStatus:@"请输入正确价格" cover:YES offsetY:kMainScreenWidth/2.0];
        }
    }
    if (textField==_contactNameTextField)
    {
        NSString *oldstr = _contactNameTextField.text;
        NSString *newStr = [oldstr stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([newStr isEqualToString:@""])
        {
            [SVProgressHUD showErrorWithStatus:@"请输入姓名" cover:YES offsetY:kMainScreenWidth/2.0];
        }
        else
        {
            [_contactNameTextField resignFirstResponder];
            [self keyboardDidDisappear];
        }
    }
    
    if (textField==_contactPhoneTextField)
    {
        if ([self isPureInt:_contactPhoneTextField.text] && _contactPhoneTextField.text.length==11)
        {
            [textField resignFirstResponder];
            [self keyboardDidDisappear];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"请输入正确号码" cover:YES offsetY:kMainScreenWidth/2.0];
        }
    }
    
    return YES;
}

//判断是否为float
- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

//判断是否为int
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        [self keyboardDidDisappear];
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.detailTextView.text = @"";
//    self.detailTextView.textColor = [UIColor blackColor];
    [self keyboardWillAppear];
    return YES;
}




- (void)keyboardWillAppear
{
//    [self pickerPickEnd:nil];
    //注册通知,监听键盘出现
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidShow:)
                                                name:UIKeyboardWillShowNotification
                                              object:nil];
    //注册通知，监听键盘消失事件
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidHidden)
                                                name:UIKeyboardWillHideNotification
                                              object:nil];
}

//监听事件
- (void)handleKeyboardDidShow:(NSNotification*)paramNotification
{
    //获取键盘高度
    NSValue *keyboardRectAsObject=[[paramNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    [keyboardRectAsObject getValue:&keyboardRect];
    
    if (![_priceTextField isFirstResponder])
    {
        float offY = 0;
        MLOG(@"%f", kMainScreenHeight);
        if (kMainScreenHeight>200)
        {
            offY=kMainScreenHeight;
        }
        else
        {
            offY=330;
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.scrollView.contentOffset = CGPointMake(0, offY);
        }];
        CGRect temFrame = self.scrollView.frame;
        temFrame.size.height = self.view.frame.size.height - keyboardRect.size.height+60;
        self.scrollView.frame = temFrame;
    }
    
}

- (void)handleKeyboardDidHidden
{
    [UIView animateWithDuration:0.2 animations:^{
        self.scrollView.frame = self.view.bounds;
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }];
}

- (void)keyboardDidDisappear
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 点击标题
- (void)showTitletTagView
{
    TitleTagViewController *vc = [[TitleTagViewController alloc] init];
    vc.type = 1;
    [vc useBlock:^(NSString *title) {
        if ([title isEqualToString:@""])
        {
            _nameTextField.placeholder = @"请输入您要发布的名称";
        }
        else
        {
            _nameTextField.text = title;

            [self setupVariousViewWithTitle];
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) setupVariousViewWithTitle
{
    NSString *titleStr = _nameTextField.text;
    if ([titleStr isEqual:@"样板"]) {
//        NSArray *array = _measurePicker.dataArray[_measurePicker.selectItem];
    
        _variousView.itemLabel.text = @"元/本";
    }
    else if ([titleStr isEqual:@"壁纸墙布"] ||
             [titleStr isEqual:@"真皮"] ||
             [titleStr isEqual:@"遮阳"] ){
        _variousView.itemLabel.text = @"元/平方";
    }
    else if ([titleStr isEqual:@"绒布"] ||
             [titleStr isEqual:@"窗帘布"] ||
             [titleStr isEqual:@"绣花"] ||
             [titleStr isEqual:@"窗纱"] ||
             [titleStr isEqual:@"辅料"] ||
             [titleStr isEqual:@"沙发布"] ||
             [titleStr isEqual:@"工程布"] ||
             [titleStr isEqual:@"人造革"]){
        _variousView.itemLabel.text = @"元/米";
    }
}


#pragma mark 类目
- (void)showCategoryView
{
        CategoryViewController *vc = [[CategoryViewController alloc] init];
        if (!isClean) {
            isClean = YES;
            [vc cleanAll];
        }
        vc.isPushed = YES;
        [vc setBlock:^(NSArray *aArray) {
            if (aArray.count>0)
            {
                NSString *str = @"";
                catidString = @"";
                for (YHBCatSubcate *subModel in aArray) {
                    str = [str stringByAppendingString:[NSString stringWithFormat:@" %@", subModel.categoryName]];
                    catidString = [catidString stringByAppendingString:[NSString stringWithFormat:@",%d", (int)subModel.categoryId]];
                }
                catidString = [catidString substringFromIndex:1];
                _categoryTextField.text = str;
            }
            else
            {
//                _categoryTextField.text = @"";
            }
            
        }];
        [self.navigationController pushViewController:vc animated:YES];
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
    
    UIView *view = [self attributesFrom:CGRectMake(0, view3.bottom, kMainScreenWidth, view3.height)];
    [self.editFormView addSubview:view];
    
    UIView *view4 = [self priceForm:CGRectMake(0, view.bottom, kMainScreenWidth, view.height)];
    [self.editFormView addSubview:view4];
    
    UIView *view5 = [self normsForm:CGRectMake(0, view4.bottom, kMainScreenWidth, view4.height)];
    [self.editFormView addSubview:view5];
    
    
    UIView *view6 = [self detailForm:CGRectMake(0, view5.bottom, kMainScreenWidth, 120)];
    [self.editFormView addSubview:view6];
    
    UIView *view7 = [self deliveryStatusForm:CGRectMake(0, view6.bottom, kMainScreenWidth, 40)];
    [self.editFormView addSubview:view7];
    
    UIView *view8 = [self isSalesPromotionForm:CGRectMake(0, view7.bottom, kMainScreenWidth, 40)];
    [self.editFormView addSubview:view8];
    
    UIView *view9 = [self isCutForm:CGRectMake(0, view8.bottom, kMainScreenWidth, 40)];
    [self.editFormView addSubview:view9];
//    _variousView = [[YHBVariousView alloc] initWithFrame:CGRectMake(self.view.right - 100, view3.bottom + 10, 60 + 10, 20) andItemArray:@[@"元/米",@"元/本",@"元/码",@"元/平方",@"元/卷"] andSelectedItem:0];
//    self.variousView.frame = CGRectMake(self.view.right - 100, view3.bottom, 70, 20);
//    _variousView.layer.borderColor = [KColor CGColor];
//    _variousView.layer.borderWidth=0.5;
//    _variousView.layer.cornerRadius = 10;
//    _variousView.clipsToBounds = YES;
    [self.editFormView addSubview:self.variousView];
    
    self.editFormView.frame = CGRectMake(0, self.pictureAdder.bottom, kMainScreenWidth, view9.bottom);
    
    
}

- (MeasurePicker *)measurePicker
{
    if (_measurePicker == nil) {
        NSArray *array = @[@"元/米",@"元/本",@"元/码",@"元/平方",@"元/卷"];
        _measurePicker = [[MeasurePicker alloc] initWithFrame:CGRectMake(0, 0, 70, 20) attachView:self.scrollView dataArray:array];
    }
    return _measurePicker;
}

- (void)setupContactView
{
    UIView *form0 = [self contactNameForm:CGRectMake(0, 0, kMainScreenWidth, 40)];
    UIView *form1 = [self contactPhoneForm:CGRectMake(0, form0.bottom, form0.width, form0.height)];
 
    [self.contactView addSubview:form0];
    [self.contactView addSubview:form1];

    self.contactView.frame = CGRectMake(0, self.editFormView.bottom + 10, kMainScreenWidth, form1.bottom);
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
    
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(label.right, 0, kMainScreenWidth - label.width - 20 - 40, view.height)];
    _nameTextField.font = [UIFont systemFontOfSize:15];
    _nameTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _nameTextField.returnKeyType = UIReturnKeyDone;
    _nameTextField.placeholder = @"请选择或输入布料名称";
    [_nameTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _nameTextField.delegate = self;
    [view addSubview:_nameTextField];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.right - 40, 10, 20, 20)];
    imageView.image = [UIImage imageNamed:@"iconfont-nextpage"];
    [view addSubview:imageView];
    
    [self addBottomLine:view];
    
    return view;
}

#pragma mark - 布料分类UI
- (UIView *)categoryForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 80, view.height) title:@"*布料分类 : "];
    [view addSubview:label];
    
    _categoryTextField = [[UITextField alloc] initWithFrame:CGRectMake(label.right, 0, kMainScreenWidth - label.width - 20 - 40, view.height)];
    _categoryTextField.font = [UIFont systemFontOfSize:15];
    _categoryTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _categoryTextField.returnKeyType = UIReturnKeyDone;
    _categoryTextField.placeholder = @"请选择布料所属类目";
    [_categoryTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _categoryTextField.delegate = self;
    [view addSubview:_categoryTextField];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.right - 40, 10, 20, 20)];
    imageView.image = [UIImage imageNamed:@"iconfont-nextpage"];
    [view addSubview:imageView];
    
    [self addBottomLine:view];
    return view;
}

#pragma mark - 属性
- (UIView *)attributesFrom:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 50, view.height) title:@"*属性 : "];
    [view addSubview:label];
    
    _attributesTextField = [[UITextField alloc] initWithFrame:CGRectMake(label.right, 0, kMainScreenWidth - label.width - 20 - 40, view.height)];
    _attributesTextField.font = [UIFont systemFontOfSize:15];
    _attributesTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _attributesTextField.returnKeyType = UIReturnKeyDone;
    _attributesTextField.placeholder = @"请选择属性";
    [_attributesTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _attributesTextField.delegate = self;
    [view addSubview:_attributesTextField];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.right - 40, 10, 20, 20)];
    imageView.image = [UIImage imageNamed:@"iconfont-nextpage"];
    [view addSubview:imageView];
    
    [self addBottomLine:view];
    return view;
}

#pragma mark - 价格UI
- (UIView *)priceForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 50, view.height) title:@"*价格 : "];
    [view addSubview:label];
    
    _priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(label.right,0,120, view.height)];
    _priceTextField.font = [UIFont systemFontOfSize:15];
    _priceTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _priceTextField.returnKeyType = UIReturnKeyDone;
    _priceTextField.placeholder = @"请填写价格";
    [_priceTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _priceTextField.delegate = self;
    [view addSubview:_priceTextField];
    self.measurePicker.frame = CGRectMake(self.view.right - 100, 10, 70, 20);
    [view addSubview:self.measurePicker];
    [self addBottomLine:view];
    return view;
}


- (YHBVariousView *)variousView
{
    if (_variousView == nil) {
        NSArray *array = @[@"元/米",@"元/本",@"元/码",@"元/平方",@"元/卷"];
        _variousView = [[YHBVariousView alloc] initWithFrame:CGRectZero andItemArray:array andSelectedItem:0];
        _variousView.layer.borderColor = [KColor CGColor];
        _variousView.layer.borderWidth=0.5;
        _variousView.layer.cornerRadius = 10;
        _variousView.clipsToBounds = YES;
    }
    return _variousView;
}

#pragma mark - 规格UI
- (UIView *)normsForm:(CGRect)frame
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 50, view.height) title:@"*规格 : "];
    [view addSubview:label];
    
    _normsTextField = [[UITextField alloc] initWithFrame:CGRectMake(label.right,0,kMainScreenWidth - 120 , view.height)];
    _normsTextField.font = [UIFont systemFontOfSize:15];
    _normsTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _normsTextField.returnKeyType = UIReturnKeyDone;
    _normsTextField.placeholder = @"选择产品规格";
    [_normsTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _normsTextField.delegate = self;
    [view addSubview:_normsTextField];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.right - 40, 10, 20, 20)];
    imageView.image = [UIImage imageNamed:@"iconfont-nextpage"];
    [view addSubview:imageView];
    
    [self addBottomLine:view];
    return view;
}

#pragma mark - 面料详情UI
- (UIView *)detailForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 80, 40) title:@"布料详情 : "];
    [view addSubview:label];
    
    self.detailTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, label.bottom-5, kMainScreenWidth-40, 80)];
    self.detailTextView.textColor = [UIColor lightGrayColor];
    self.detailTextView.font = [UIFont fontWithName:@"Arial" size:15.0];
    self.detailTextView.delegate = self;
    self.detailTextView.backgroundColor = [UIColor whiteColor];
    self.detailTextView.text = @"请输入您要卖的产品的织法、成分、颜色、厚薄、弹力、手感、宽幅、克重、用途等，尽可能填写您所知道的全部信息。";
    
    self.detailTextView.returnKeyType = UIReturnKeyDefault;
    self.detailTextView.keyboardType = UIKeyboardTypeDefault;
    self.detailTextView.scrollEnabled = YES;
    self.detailTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [view addSubview:self.detailTextView];
    [self addBottomLine:view];
    return view;
}





#pragma mark - 供货状态UI
- (UIView *)deliveryStatusForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 100, frame.size.height) title:@"供货状态 : "];
    label.userInteractionEnabled = YES;
    _btn1 = [[MyButton alloc] initWithFrame:CGRectMake(label.right+15, 0, 60, view.height) imageName:@"check_off" text:@"现货"];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedBtn1:)];
    [_btn1 addGestureRecognizer:tap1];
    
    _btn2 = [[MyButton alloc] initWithFrame:CGRectMake(_btn1.right+20, 0, 60, view.height) imageName:@"check_off" text:@"期货"];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedBtn2:)];
    [_btn2 addGestureRecognizer:tap2];
  
    [view addSubview:_btn1];
    [view addSubview:_btn2];
    [view addSubview:label];
//    [self addBottomLine:view];
    return view;
}
- (void)selectedBtn1:(UIGestureRecognizer *)tap
{
    if (_btn1) {
        _isSpot = YES;
        _btn1.imageView.image =[UIImage imageNamed:@"check_on"];
        _btn2.imageView.image =[UIImage imageNamed:@"check_off"];
    }
}

- (void)selectedBtn2:(UIGestureRecognizer *)tap
{
    if (_btn2) {
        _isSpot = NO;
        _btn2.imageView.image =[UIImage imageNamed:@"check_on"];
        _btn1.imageView.image =[UIImage imageNamed:@"check_off"];
    }
}


#pragma mark - 是否促销UI
- (UIView *)isSalesPromotionForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 100, frame.size.height) title:@"是否促销 : "];
    label.userInteractionEnabled = YES;
    _btn3 = [[MyButton alloc] initWithFrame:CGRectMake(label.right+15, 0, 60, view.height) imageName:@"check_off" text:@"是"];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedBtn3:)];
    [_btn3 addGestureRecognizer:tap1];
    
    _btn4 = [[MyButton alloc] initWithFrame:CGRectMake(_btn1.right+20, 0, 60, view.height) imageName:@"check_off" text:@"否"];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedBtn4:)];
    [_btn4 addGestureRecognizer:tap2];
    
    [view addSubview:_btn3];
    [view addSubview:_btn4];
    [view addSubview:label];
//    [self addBottomLine:view];
    return view;
}

- (void)selectedBtn3:(UIGestureRecognizer *)tap
{
    if (_btn3) {
        _isSelect = YES;
        _btn3.imageView.image =[UIImage imageNamed:@"check_on"];
        _btn4.imageView.image =[UIImage imageNamed:@"check_off"];
    }
}

- (void)selectedBtn4:(UIGestureRecognizer *)tap
{
    if (_btn4) {
        _isSelect = NO;
        _btn4.imageView.image =[UIImage imageNamed:@"check_on"];
        _btn3.imageView.image =[UIImage imageNamed:@"check_off"];
    }
}


#pragma mark - 剪样UI
- (UIView *)isCutForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 100, frame.size.height) title:@"是否提供剪样 : "];
    label.userInteractionEnabled = YES;
    _btn5 = [[MyButton alloc] initWithFrame:CGRectMake(label.right+15, 0, 60, view.height) imageName:@"check_off" text:@"是"];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedBtn5:)];
    [_btn5 addGestureRecognizer:tap1];
    
    _btn6 = [[MyButton alloc] initWithFrame:CGRectMake(_btn1.right+20, 0, 60, view.height) imageName:@"check_off" text:@"否"];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedBtn6:)];
    [_btn6 addGestureRecognizer:tap2];
    
    //    _myModel.isSampleCut = _isCut;
    
    [view addSubview:_btn5];
    [view addSubview:_btn6];
    [view addSubview:label];
    [self addBottomLine:view];
    return view;
}

- (void)selectedBtn5:(UIGestureRecognizer *)tap
{
    if (_btn5) {
        _isCut = YES;
        _btn5.imageView.image =[UIImage imageNamed:@"check_on"];
        _btn6.imageView.image =[UIImage imageNamed:@"check_off"];
    }
}

- (void)selectedBtn6:(UIGestureRecognizer *)tap
{
    if (_btn6) {
        _isCut = NO;
        _btn6.imageView.image =[UIImage imageNamed:@"check_on"];
        _btn5.imageView.image =[UIImage imageNamed:@"check_off"];
    }
}


#pragma mark - 联系人UI
- (UIView *)contactNameForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 80, frame.size.height) title:@"*联 系 人 : "];
    self.contactNameTextField.frame = CGRectMake(label.right + 5, 0, view.width - label.right, view.height);
    [view addSubview:label];
    [view addSubview:self.contactNameTextField];
    [self addBottomLine:view];
    return view;
}

#pragma mark - 联系电话UI
- (UIView *)contactPhoneForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 80, frame.size.height) title:@"*联系电话 : "];
    self.contactPhoneTextField.frame = CGRectMake(label.right + 5, 0, view.width - label.right - 80, view.height);
    //    self.publicPhoneRadiBox.frame = CGRectMake(_contactPhoneTextField.right, 10, 60, view.height);
    _publicPhoneRadiBox = [[YHBRadioBox alloc] initWithFrame:CGRectMake(view.right - 80, 0, 60, view.height) checkedImage:[UIImage imageNamed:@"check_on"] uncheckedImage:[UIImage imageNamed:@"check_off"] title:@"公开"];
    [_publicPhoneRadiBox addTarget:self action:@selector(publicPhoneRadioBoxValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:label];
    [view addSubview:self.contactPhoneTextField];
    [view addSubview:_publicPhoneRadiBox];
    [self addBottomLine:view];
    return view;
}

#pragma mark - 公开按钮
- (YHBRadioBox *)publicPhoneRadiBox
{
    if (_publicPhoneRadiBox == nil) {
        _publicPhoneRadiBox = [[YHBRadioBox alloc] initWithFrame:CGRectMake(0, 0, 60, 20) checkedImage:[UIImage imageNamed:@"check_on"] uncheckedImage:[UIImage imageNamed:@"check_off"] title:@"公开"];
        [_publicPhoneRadiBox addTarget:self action:@selector(publicPhoneRadioBoxValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _publicPhoneRadiBox;
}

- (void)publicPhoneRadioBoxValueDidChanged:(YHBRadioBox *)radioBox
{
    
    switch (radioBox.tag) {
        case 1001:
            if (_isSelectBtn) {
                _isSelectBtn = !_isSelectBtn;
            }
            //            NSLog(@"%d",radioBox.tag);
            break;
        case 1002:
            if (_isSelectBtn) {
                _isSelectBtn = !_isSelectBtn;}
            //            NSLog(@"%d",radioBox.tag);
            break;
        default:
            break;
    }
    
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

- (UIButton *)publishButton
{
    if (_publishButton == nil) {
        _publishButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _publishButton.layer.cornerRadius = 2.5;
        _publishButton.backgroundColor = KColor;
        [_publishButton setTitle:@"立 即 发 布" forState:UIControlStateNormal];
        [_publishButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        [_publishButton addTarget:self action:@selector(TouchPublish)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishButton;
}

- (UITextField *)contactNameTextField
{
    if (_contactNameTextField == nil) {
        _contactNameTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _contactNameTextField.font = [UIFont systemFontOfSize:15.0];
        _contactNameTextField.delegate = self;
    }
    return _contactNameTextField;
}


- (UITextField *)contactPhoneTextField
{
    if (_contactPhoneTextField == nil) {
        _contactPhoneTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _contactPhoneTextField.font = [UIFont systemFontOfSize:15.0];
        _contactPhoneTextField.delegate = self;
    }
    return _contactPhoneTextField;
}


#pragma mark 发布
- (void)TouchPublish
{
    if (![self checkMandatory]) {
        [SVProgressHUD showErrorWithStatus:@"带星号的为必填项!!" cover:YES offsetY:kMainScreenHeight/2.0];
        return;
    }
//    if (![self checkoutImgae]) {
//        [SVProgressHUD showErrorWithStatus:@"请选择要上传的图片!!" cover:YES offsetY:kMainScreenHeight/2.0];
//        return;
//    }
    
//    [SVProgressHUD showWithStatus:@"图片正在上传中，请稍等..." cover:YES offsetY:kMainScreenHeight / 2.0];
    
//    if ([self isAllWebImage]) {
//        [self deleteDiscardPhoto];
//    }
//    else{
//        [self updatePhoto];
//    }
    
    NSString *productUrl = nil;
    kYHBRequestUrl(@"product/addProduct", productUrl);
    NSDictionary *dic = [self createDictionary];
    
    NSString *str = [self dictionaryToJson:dic];
    //    NSLog(@"****%@",str);
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:str,@"product", nil];
    
    //    NSLog(@"%@",dict);
    //    [FGGProgressHUD showLoadingOnView:self.view];
    __weak typeof(self) weakSelf=self;
    [NetworkService postWithURL:productUrl paramters:dict success:^(NSData *receiveData) {
        if(receiveData.length>0)
        {
            id result=[NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
            if([result isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dictionary=result;
                NSString *msg = dictionary[@"RESPMSG"];
                NSString *status = dictionary[@"RESPCODE"];
                
                NSLog(@"%@",result);
                if([status integerValue] == 0)
                {
                    [weakSelf showAlertWithMessage:msg automaticDismiss:YES];
                    
                }
                else if ([status integerValue] != 0)
                {
                    //                    [FGGProgressHUD hideLoadingFromView:weakSelf.view];
                    [weakSelf showAlertWithMessage:msg automaticDismiss:NO];
                }
            }
        }
    } failure:^(NSError *error) {
        [FGGProgressHUD hideLoadingFromView:weakSelf.view];
        [self showAlertWithMessage:error.localizedDescription automaticDismiss:NO];
    }];
    
}



- (NSMutableDictionary *)createDictionary
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:_nameTextField.text forKey:@"productName"];
    [dic setObject:@3 forKey:@"categoryId"];
    [dic setObject:_measurePicker.dataArray[_measurePicker.selectItem] forKey:@"unit"];
    [dic setObject:_priceTextField.text forKey:@"price"];
    [dic setObject:_normsTextField.text forKey:@"productSpecificationList"];//规格
//    [dic setObject: @3 forKey:@"catId"];
    [dic setObject:@(_isSpot) forKey:@"supplyState"];
    [dic setObject:_detailTextView.text forKey:@"productDesc"];
    [dic setObject:@(_isSelect) forKey:@"isPromotion"];
    [dic setObject:@(_isCut) forKey:@"isSample"];
//    [dic setObject:@(_isSelectBtn) forKey:@"PhonePublic"];
    [dic setObject:_pictureAdder.imageArray forKey:@"productImageList"];
//    [dic setObject:_contactNameTextField.text forKey:@"name"];
//    [dic setObject:_contactPhoneTextField.text forKey:@"phone"];
    return dic;
    
}


- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


//检查必填项是否不为空
- (BOOL) checkMandatory
{
    if ([self isTextNotNil:_nameTextField.text]&&[self isTextNotNil:_categoryTextField.text]&&[self isTextNotNil:_contactNameTextField.text]&&[self isTextNotNil:_contactPhoneTextField.text]&&[self isTextNotNil:_priceTextField.text]){
        return YES;
    }
    return NO;
}

//检查照片是否为空
- (BOOL) checkoutImgae
{
    if (self.pictureAdder.imageArray.count > 0){
        return YES;
    }
    return NO;
}

- (BOOL)isTextNotNil:(NSString *)aStr
{
    if (aStr.length==0 || aStr==nil || [aStr isEqualToString:@" "] || [aStr isEqualToString:@"请输入您要发布的名称"])
    {
        return NO;
    }
    else
    {
        return YES;
    }
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
