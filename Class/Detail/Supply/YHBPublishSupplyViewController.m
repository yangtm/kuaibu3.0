//
//  YHBPublishSupplyViewController.m
//  YHB_Prj
//
//  Created by Johnny's on 14/11/30.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "YHBPublishSupplyViewController.h"
//#import "YHBSupplyDetailViewController.h"
//#import "TitleTagViewController.h"
#import "SVProgressHUD.h"
//#import "YHBPublishSupplyManage.h"
//#import "CategoryViewController.h"
//#import "YHBCatSubcate.h"
//#import "YHBUser.h"
//#import "YHBUploadImageManage.h"
//#import "NetManager.h"
#import "YHBSupplyDetailPic.h"
#import "YHBVariousView.h"
#import "YHBPictureAdder.h"
#import "YHBPicture.h"
#import "UIImage+Extensions.h"

#define kButtonTag_Yes 100
@interface YHBPublishSupplyViewController ()<UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIScrollView *scrollView;
    UITextField *nameTextField;
    UITextField *phoneTextField;
    
    NSString *content;
    int typeId;
    float price;
    int pickViewSelected;
    
    UILabel *titleLabel;
    UITextField *_larghezzaTextField;
    UITextField *priceTextField;
    UILabel *dayLabel;
    UIView *dayView;
    UILabel *catNameLabel;
    UITextView *contentTextView;
    UITapGestureRecognizer *tapTitleGesture;
    UITapGestureRecognizer *tapDayGesture;
//    YHBSupplyDetailModel *myModel;
    BOOL isClean;
    
    NSString *catidString;
    
    UILabel *titlePlaceHolder;
    UILabel *dayPlaceHolder;
    UILabel *catPlaceHolder;
    UILabel *detailPlaceHolder;
    
    BOOL webEdit;
    YHBVariousView *variousView;
    BOOL _isPublicPhone;
    BOOL _sampleCutting;
    BOOL _samplePost;
    BOOL _isPushed;
    NSArray *categoryArray;
}

@property (nonatomic, strong) YHBPictureAdder *pictureAdder;
@property (nonatomic, strong) UIPickerView *dayPickerView;
@property (nonatomic, strong) UIView *toolView;
//@property (nonatomic, strong) YHBPublishSupplyManage *netManage;
@end

@implementation YHBPublishSupplyViewController

//- (instancetype)initWithModel:(YHBSupplyDetailModel *)aModel
//{
//    if (self = [super init]) {
//        myModel = aModel;
//        webEdit = YES;
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(dismissSelf)];
    
    self.title = @"发布供应";
    self.view.backgroundColor = RGBCOLOR(241, 241, 241);
    isClean = NO;
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    [scrollView addSubview:self.pictureAdder];
    
    float labelHeight = 20;//label高度
    float interval = 20;//label之间间隔
    float editViewHeight = 390;//中间view高度
    typeId=0;
    
    UIView *editSupplyView = [[UIView alloc] initWithFrame:CGRectMake(0, self.pictureAdder.bottom, kMainScreenWidth, editViewHeight)];
    editSupplyView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:editSupplyView];
    
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.5)];
    topLineView.backgroundColor = [UIColor lightGrayColor];
    [editSupplyView addSubview:topLineView];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, editViewHeight-0.5, kMainScreenWidth, 0.5)];
    bottomLineView.backgroundColor = [UIColor lightGrayColor];
    [editSupplyView addSubview:bottomLineView];
    
    NSArray *strArray = @[@"*名      称 :", @" 门      幅 :", @" 价      格 :",@" 到期时间:",@"*类      目 :",@" 供货状态:", @" 其他服务:", @" 详细描述:"];
    
    for (int i=0; i<strArray.count; i++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, interval/2+(labelHeight+interval)*i, 70, labelHeight)];
        label.text = [strArray objectAtIndex:i];
        //给星号加颜色
        [self shadedStar:label];
        label.font = [UIFont systemFontOfSize:15];
        //            [contentScrollView addSubview:label];
        [editSupplyView addSubview:label];
        
        if (i!=strArray.count-1)
        {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, label.bottom+10, kMainScreenWidth, 0.5)];
            lineView.backgroundColor = [UIColor lightGrayColor];
            [editSupplyView addSubview:lineView];
        }
    }
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, interval/2-5, kMainScreenWidth-85-10, labelHeight+10)];
    titleLabel.userInteractionEnabled = YES;
    titleLabel.font = kFont15;
    [editSupplyView addSubview:titleLabel];
    
    titlePlaceHolder = [[UILabel alloc] initWithFrame:titleLabel.frame];
    titlePlaceHolder.text = @"请选择品名+输入货号";
    titlePlaceHolder.font = kFont15;
    titlePlaceHolder.textColor = [UIColor lightGrayColor];
    [editSupplyView addSubview:titlePlaceHolder];
    
    UIImageView *rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(titleLabel.right-titleLabel.left-12, (labelHeight+10-15)/2, 9, 15)];
    [rightArrow setImage:[UIImage imageNamed:@"rightArrow"]];
    [titleLabel addSubview:rightArrow];
    
    tapTitleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchTitle)];
    [titleLabel addGestureRecognizer:tapTitleGesture];
    
    _larghezzaTextField = [[UITextField alloc] initWithFrame:CGRectMake(85, interval*1.5+labelHeight-5, kMainScreenWidth - 85 - 5, labelHeight + 10)];
    _larghezzaTextField.placeholder = @"请填写门幅";
    _larghezzaTextField.returnKeyType = UIReturnKeyDone;
    _larghezzaTextField.delegate = self;
    [_larghezzaTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _larghezzaTextField.font = [UIFont systemFontOfSize:15];
    [editSupplyView addSubview:_larghezzaTextField];
    
    priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(85, interval*3.5+labelHeight-5, kMainScreenWidth-85-70 - 10, labelHeight+10)];
    priceTextField.font = [UIFont systemFontOfSize:15];
    priceTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    priceTextField.returnKeyType = UIReturnKeyDone;
    priceTextField.placeholder = @"请填写价格";
    [priceTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    priceTextField.delegate = self;
    [editSupplyView addSubview:priceTextField];
    
    variousView = [[YHBVariousView alloc] initWithFrame:CGRectMake(priceTextField.right, priceTextField.top+5, 60 + 10, labelHeight) andItemArray:@[@"元/米",@"元/本",@"元/码",@"元/平方",@"元/卷"] andSelectedItem:0];
    variousView.layer.borderColor = [KColor CGColor];
    variousView.layer.borderWidth=0.5;
    variousView.layer.cornerRadius = 10;
    variousView.clipsToBounds = YES;
    
    dayView = [[UIView alloc] initWithFrame:CGRectMake(85, (interval+labelHeight)*3+interval/2-5, kMainScreenWidth-85-10, labelHeight+10)];
    dayView.userInteractionEnabled = YES;
    [editSupplyView addSubview:dayView];
    
    dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth-85-10-40, labelHeight+10)];
    dayLabel.font = kFont15;
    dayLabel.userInteractionEnabled = YES;
    [dayView addSubview:dayLabel];
    
    dayPlaceHolder = [[UILabel alloc] initWithFrame:dayLabel.frame];
    dayPlaceHolder.text = @"信息过期时间";
    dayPlaceHolder.font = kFont15;
    dayPlaceHolder.textColor = [UIColor lightGrayColor];
    [dayView addSubview:dayPlaceHolder];
    
    tapDayGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchDay)];
    [dayView addGestureRecognizer:tapDayGesture];
    
    UILabel *dayLabelNote = [[UILabel alloc] initWithFrame:CGRectMake(dayLabel.right, 0, 20, labelHeight+10)];
    dayLabelNote.font = [UIFont systemFontOfSize:15];
    dayLabelNote.textColor = [UIColor lightGrayColor];
    dayLabelNote.text = @"天";
    [dayView addSubview:dayLabelNote];
    
    UIImageView *downArrow = [[UIImageView alloc] initWithFrame:CGRectMake(dayView.right-dayView.left-12, (labelHeight+10-15)/2, 9, 15)];
    [downArrow setImage:[UIImage imageNamed:@"rightArrow"]];
    [dayView addSubview:downArrow];
    
    catNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, (interval+labelHeight)*4+interval/2-5, kMainScreenWidth-85-10, labelHeight+10)];
    catNameLabel.font = kFont15;
    catNameLabel.userInteractionEnabled = YES;
    [editSupplyView addSubview:catNameLabel];
    
    catPlaceHolder = [[UILabel alloc] initWithFrame:catNameLabel.frame];
    catPlaceHolder.text = @"请选择产品分类";
    catPlaceHolder.font = kFont15;
    catPlaceHolder.textColor = [UIColor lightGrayColor];
    [editSupplyView addSubview:catPlaceHolder];
    
    UITapGestureRecognizer *tapGestureReco = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchCat)];
    [catNameLabel addGestureRecognizer:tapGestureReco];
    
    NSArray *array = @[@"现货",@"期货",@"促销"];
    for (int i=0; i<3; i++)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(85+(labelHeight+10+40)*i, (interval+labelHeight)*5+interval/2-5, labelHeight+6, labelHeight+6)];
        [btn setImage:[UIImage imageNamed:@"btnNotChoose"] forState:UIControlStateNormal];
        btn.tag=10+i;
        [btn addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
        [editSupplyView addSubview:btn];
        if (i==0) {
            [btn setImage:[UIImage imageNamed:@"btnChoose"] forState:UIControlStateNormal];
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(btn.right+5, btn.top, 30, labelHeight+10)];
        label.text = [array objectAtIndex:i];
        label.font = kFont15;
        label.textColor = [UIColor lightGrayColor];
        [editSupplyView addSubview:label];
    }
    
    NSArray *otherArray = @[@"提供剪样", @"提供寄品"];
    CGFloat space = (kMainScreenWidth - 85) / 2.0;
    for (int i =0; i < 2; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(85+ space * i, (interval+labelHeight)*6+interval/2-5, labelHeight+6, labelHeight+6)];
        [btn setImage:[UIImage imageNamed:@"btnNotChoose"] forState:UIControlStateNormal];
        btn.tag=30+i;
        [btn addTarget:self action:@selector(otherButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [editSupplyView addSubview:btn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(btn.right+5, btn.top, 60, labelHeight+10)];
        label.text = [otherArray objectAtIndex:i];
        label.font = kFont15;
        label.textColor = [UIColor lightGrayColor];
        [editSupplyView addSubview:label];
    }
    
    
    contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, interval/2+(interval+labelHeight)*7+labelHeight+3, kMainScreenWidth-20, 70)];
    contentTextView.font = [UIFont systemFontOfSize:15];
    contentTextView.returnKeyType = UIReturnKeyDone;
    contentTextView.delegate = self;
    contentTextView.backgroundColor = [UIColor clearColor];
    [editSupplyView addSubview:contentTextView];
    
    detailPlaceHolder = [[UILabel alloc] initWithFrame:contentTextView.frame];
    detailPlaceHolder.text = @"请输入您要卖的产品的织法、成分、颜色、厚薄、弹力、手感、宽幅、克重、用途等，尽可能填写您所知道的全部信息。";
    detailPlaceHolder.numberOfLines = 0;
    detailPlaceHolder.font = kFont15;
    detailPlaceHolder.textColor = [UIColor lightGrayColor];
    [editSupplyView addSubview:detailPlaceHolder];
    
    [editSupplyView addSubview:variousView];
    
    
//    if (myModel)
//    {
//        titleLabel.text = myModel.title;
//        _larghezzaTextField.text = myModel.larghezza;
//        priceTextField.text = myModel.price;
//        catNameLabel.text = myModel.catname;
//        catidString=nil;
//        catidString=myModel.catid;
//        contentTextView.text = myModel.content;
//        dayLabel.text = [NSString stringWithFormat:@"%d", myModel.today];
//        
//        self.pictureAdder.imageArray = [self pictureArrayForAdder];
//        
//        if (myModel.supplySampleCut) {
//            _sampleCutting = YES;
//            UIButton *button = (UIButton *)[self.view viewWithTag:30];
//            [button setImage:[UIImage imageNamed:@"btnChoose"] forState:UIControlStateNormal];
//        }
//        if (myModel.supplySamplePost) {
//            _samplePost = YES;
//            UIButton *button = (UIButton *)[self.view viewWithTag:31];
//            [button setImage:[UIImage imageNamed:@"btnChoose"] forState:UIControlStateNormal];
//        }
//        
//        int atypeId = myModel.typeid.integerValue;
//        UIButton *button = (UIButton *)[self.view viewWithTag:atypeId+10];
//        [self touchBtn:button];
//        
//        dayPlaceHolder.hidden = YES;
//        titlePlaceHolder.hidden = YES;
//        catPlaceHolder.hidden = YES;
//        detailPlaceHolder.hidden = YES;
//    }
//    else{
//        pickViewSelected = 6;
//        dayPlaceHolder.hidden = YES;
//        dayLabel.text = @"7";
//    }
    
    UIView *contactView = [[UIView alloc] initWithFrame:CGRectMake(0, editSupplyView.bottom+10, kMainScreenWidth, 90)];
    [scrollView addSubview:contactView];
    contactView.backgroundColor = [UIColor whiteColor];
    
    UILabel *personNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 75, 20)];
    personNameLabel.font = kFont15;
    personNameLabel.text = @"*联 系 人: ";
    [self shadedStar:personNameLabel];
    
    UIView *alineView = [[UIView alloc] initWithFrame:CGRectMake(0, personNameLabel.bottom+10, kMainScreenWidth, 0.5)];
    alineView.backgroundColor = [UIColor lightGrayColor];
    [contactView addSubview:alineView];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(personNameLabel.left, personNameLabel.bottom+20, 75, 20)];
    phoneLabel.font = kFont15;
    phoneLabel.text = @"*联系电话: ";
    [self shadedStar:phoneLabel];
    
//    YHBUser *user = [YHBUser sharedYHBUser];
    
    nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(85, personNameLabel.top-5, kMainScreenWidth-85-10, labelHeight+10)];
    nameTextField.font = kFont15;
    nameTextField.delegate = self;
    nameTextField.returnKeyType = UIReturnKeyDone;
//    nameTextField.text = user.userInfo.company;
    
    phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(85, phoneLabel.top-5, kMainScreenWidth-85-10 - 80, labelHeight+10)];
    phoneTextField.font = kFont15;
    phoneTextField.delegate = self;
    phoneTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    phoneTextField.returnKeyType = UIReturnKeyDone;
//    phoneTextField.text = user.userInfo.mobile;
    
    UIButton *publicPhoneButton = [[UIButton alloc] initWithFrame:CGRectMake(phoneTextField.right + 5 , phoneTextField.top + 4, labelHeight+6, labelHeight+6)];
    [publicPhoneButton setImage:[UIImage imageNamed:@"btnNotChoose"] forState:UIControlStateNormal];
    publicPhoneButton.tag = 100;
    [publicPhoneButton addTarget:self action:@selector(publicPhoneButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    UILabel *publicPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(publicPhoneButton.right+5, publicPhoneButton.top, 30, labelHeight+10)];
    publicPhoneLabel.text = @"公开";
    publicPhoneLabel.font = kFont15;
    publicPhoneLabel.textColor = [UIColor lightGrayColor];
    
    [contactView addSubview:phoneTextField];
    [contactView addSubview:nameTextField];
    [contactView addSubview:personNameLabel];
    [contactView addSubview:phoneLabel];
    [contactView addSubview:publicPhoneButton];
    [contactView addSubview:publicPhoneLabel];
    
//    if (myModel) {
//        if (!myModel.hidePhone) {
//            _isPublicPhone = YES;
//            [publicPhoneButton setImage:[UIImage imageNamed:@"btnChoose"] forState:UIControlStateNormal];
//        }
//    }
    
    
    UIButton *publishBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, contactView.bottom+10, kMainScreenWidth-20, 40)];
    publishBtn.layer.cornerRadius = 2.5;
    publishBtn.backgroundColor = KColor;
    [publishBtn setTitle:@"立 即 发 布" forState:UIControlStateNormal];
    [publishBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    [publishBtn addTarget:self action:@selector(TouchPublish)
         forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:publishBtn];
    
    if (publishBtn.bottom+10>kMainScreenHeight-62+1)
    {
        scrollView.contentSize = CGSizeMake(kMainScreenWidth, publishBtn.bottom+10);
    }
    else
    {
        scrollView.contentSize = CGSizeMake(kMainScreenWidth, kMainScreenHeight-62+1);
    }
    
    if (!webEdit) {
        [self restoreBackup];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"发布供应"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
    [MobClick endLogPageView:@"发布供应"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//给星号添加颜色
- (void) shadedStar:(UILabel *)label
{
    if ([label.text hasPrefix:@"*"]) {
        NSMutableAttributedString *attrubuteStr = [[NSMutableAttributedString alloc] initWithString:label.text];
        [attrubuteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
        [attrubuteStr addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:-2.0] range:NSMakeRange(0, 1)];
        label.attributedText = attrubuteStr;
    }
}

//是否公开电话号按钮
- (void) publicPhoneButtonClick:(UIButton *)sender
{
    _isPublicPhone = !_isPublicPhone;
    if (_isPublicPhone) {
        [sender setImage:[UIImage imageNamed:@"btnChoose"] forState:UIControlStateNormal];
    }
    else{
        [sender setImage:[UIImage imageNamed:@"btnNotChoose"] forState:UIControlStateNormal];
    }
}
//其他服务按钮
- (void)otherButtonClick:(UIButton *)sender
{
    if (sender.tag == 30) {
        _sampleCutting = !_sampleCutting;
        if (_sampleCutting) {
            [sender setImage:[UIImage imageNamed:@"btnChoose"] forState:UIControlStateNormal];
        }
        else{
            [sender setImage:[UIImage imageNamed:@"btnNotChoose"] forState:UIControlStateNormal];
        }
    }
    else{
        _samplePost = !_samplePost;
        if (_samplePost) {
            [sender setImage:[UIImage imageNamed:@"btnChoose"] forState:UIControlStateNormal];
        }
        else{
            [sender setImage:[UIImage imageNamed:@"btnNotChoose"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark pickerView datasource delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 7;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%d", (int)row+1];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    pickViewSelected = (int)row;
}

- (void)pickerPickEnd:(UIButton *)aBtn
{
    if (aBtn.tag == kButtonTag_Yes)
    {
        dayLabel.text = [NSString stringWithFormat:@"%d", pickViewSelected+1];
        dayPlaceHolder.hidden = YES;
    }
    self.dayPickerView.top = kMainScreenHeight+30;
    self.toolView.top = self.dayPickerView.top-30;
    [self.dayPickerView removeFromSuperview];
    [aBtn.superview removeFromSuperview];
}

#pragma mark 点击cat
- (void)touchCat
{
//    CategoryViewController *vc = [[CategoryViewController alloc] init];
//    if (!isClean) {
//        isClean = YES;
//        [vc cleanAll];
//    }
//    vc.isPushed = YES;
//    [vc setBlock:^(NSArray *aArray) {
//        if (aArray.count>0)
//        {
//            catPlaceHolder.hidden = YES;
//            NSString *str = @"";
//            catidString = @"";
//            for (YHBCatSubcate *subModel in aArray) {
//                str = [str stringByAppendingString:[NSString stringWithFormat:@" %@", subModel.catname]];
//                catidString = [catidString stringByAppendingString:[NSString stringWithFormat:@",%d", (int)subModel.catid]];
//            }
//            catidString = [catidString substringFromIndex:1];
//            catNameLabel.text = str;
//        }
//        else
//        {
//            catNameLabel.text = @"";
//            catPlaceHolder.hidden = NO;
//        }
//        
//    }];
//    [self.navigationController pushViewController:vc animated:YES];
}

//检查必填项是否不为空
- (BOOL) checkMandatory
{
    if ([self isTextNotNil:titleLabel.text]&&[self isTextNotNil:catNameLabel.text]&&[self isTextNotNil:nameTextField.text]&&[self isTextNotNil:phoneTextField.text]){
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

#pragma mark 点击标题
- (void)touchTitle
{
//    TitleTagViewController *vc = [[TitleTagViewController alloc] init];
//    [vc useBlock:^(NSString *title) {
//        if ([title isEqualToString:@""])
//        {
//            titleLabel.text = @"请输入您要发布的名称";
//            titleLabel.textColor = [UIColor lightGrayColor];
//        }
//        else
//        {
//            titleLabel.text = title;
//            titlePlaceHolder.hidden = YES;
//
//            [self setupVariousViewWithTitle];
//        }
//    }];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 点击天数
- (void)touchDay
{
    if (self.dayPickerView.top != kMainScreenHeight-200)
    {
        [priceTextField resignFirstResponder];
        [contentTextView resignFirstResponder];
        [self.dayPickerView reloadAllComponents];
        [self.view addSubview:self.dayPickerView];
        [self.view addSubview:self.toolView];
        [self.dayPickerView selectRow:pickViewSelected inComponent:0 animated:NO];
        [UIView animateWithDuration:0.2 animations:^{
            self.dayPickerView.top = kMainScreenHeight-200;
            self.toolView.top = self.dayPickerView.top-30;
        }];
    }
}

#pragma mark 菊花
- (void)showFlower
{
    [SVProgressHUD show:YES offsetY:kMainScreenHeight/2.0];
}

- (void)dismissFlower
{
    [SVProgressHUD dismiss];
}

#pragma mark 选择类型
- (void)touchBtn:(UIButton *)aBtn
{
    for (int i=0; i<3; i++)
    {
        UIButton *btn = (UIButton *)[self.view viewWithTag:i+10];
        [btn setImage:[UIImage imageNamed:@"btnNotChoose"] forState:UIControlStateNormal];
    }
    [aBtn setImage:[UIImage imageNamed:@"btnChoose"] forState:UIControlStateNormal];
    typeId = (int)aBtn.tag-10;
}

#pragma mark 返回
- (void)dismissSelf
{
    if (!webEdit) {
        [self saveBackup];
    }
    [self dismissFlower];
//    [[CategoryViewController sharedInstancetype] cleanAll];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark 发布
- (void)TouchPublish
{
    if (![self checkMandatory]) {
        [SVProgressHUD showErrorWithStatus:@"带星号的为必填项!!" cover:YES offsetY:kMainScreenHeight/2.0];
        return;
    }
    if (![self checkoutImgae]) {
        [SVProgressHUD showErrorWithStatus:@"请选择要上传的图片!!" cover:YES offsetY:kMainScreenHeight/2.0];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"图片正在上传中，请稍等..." cover:YES offsetY:kMainScreenHeight / 2.0];
    
    if ([self isAllWebImage]) {
        [self deleteDiscardPhoto];
    }
    else{
        [self updatePhoto];
    }
}

- (void)updatePhoto
{
//    NSArray *photoArray = self.pictureAdder.imageArray;
//    NSString *uploadPhototUrl = nil;
//    kYHBRequestUrl(@"upload.php", uploadPhototUrl);
//    for (int i = 0; i < photoArray.count; i++) {
//        YHBPicture *picture = photoArray[i];
//        if (picture.type == YHBPictureTypeLocal) {
//            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 [YHBUser sharedYHBUser].token, @"token",
//                                 [NSString stringWithFormat:@"%d", i], @"order",
//                                 @"album", @"action",
//                                 @"0", @"itemid",
//                                 @"5", @"mid",
//                                 nil];
//            
//            [UIImage imageWithUrl:picture.localImageUrl completed:^(UIImage *image, NSError *error) {
//                
//                [NetManager uploadImg:image parameters:dic uploadUrl:uploadPhototUrl uploadimgName:nil parameEncoding:AFJSONParameterEncoding progressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//                } succ:^(NSDictionary *successDict) {
//                    
//                    MLOG(@"%@", successDict);
//                    NSString *result = [successDict objectForKey:@"result"];
//                    if ([result intValue] != 1)
//                    {
//                        MLOG(@"%@", [successDict objectForKey:@"error"]);
//                        [SVProgressHUD showErrorWithStatus:[successDict objectForKey:@"error"] cover:YES offsetY:kMainScreenHeight / 2.0];
//                    }
//                    else{
//                        @synchronized(self){
//                            NSDictionary *dataDic = [successDict objectForKey:@"data"];
//                            NSInteger order = [[dataDic objectForKey:@"order"] integerValue];
//                            NSInteger pid = [[dataDic objectForKey:@"pid"] integerValue];
//                            YHBPicture *picture = photoArray[order];
//                            picture.type = YHBPictureTypeWeb;
//                            picture.webImage = [[YHBSupplyDetailPic alloc] init];
//                            picture.webImage.pid = pid;
//                            if ([self isAllWebImage]) {
//                                [self deleteDiscardPhoto];
//                            }
//                        }
//                    }
//                    
//                } failure:^(NSDictionary *failDict, NSError *error) {
//                    MLOG(@"%@", [failDict objectForKey:@"error"]);
//                    [SVProgressHUD showErrorWithStatus:error.localizedDescription cover:YES offsetY:kMainScreenHeight / 2.0];
//                }];
//                
//            }];
//        }
//    }
}

- (void)deleteDiscardPhoto
{
//    NSArray *photoArray = self.pictureAdder.imageArray;
//    NSMutableArray *deleteArray = [NSMutableArray array];
//    for (YHBSupplyDetailPic *album in myModel.pic) {
//        BOOL ret = NO;
//        for (YHBPicture *item in photoArray) {
//            if (item.webImage.pid == album.pid) {
//                ret = YES;
//            }
//        }
//        if (!ret) {
//            [deleteArray addObject:[NSNumber numberWithInteger:album.pid]];
//        }
//    }
//    NSMutableArray *pids = [NSMutableArray array];
//    for (YHBPicture *item in photoArray) {
//        [pids addObject:[NSNumber numberWithInteger:item.webImage.pid]];
//    }
//    
//    if (deleteArray.count == 0) {
//        [self publishWithPids:pids];
//    }
//    else{
//        __block NSInteger finishCount = 0;
//        NSString *url = nil;
//        kYHBRequestUrl(@"delUpload.php", url);
//        for (NSNumber *num in deleteArray) {
//            NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                      [YHBUser sharedYHBUser].token, @"token",
//                                      [NSString stringWithFormat:@"%@", num], @"pid",
//                                      nil];
//            [NetManager requestWith:paramDic url:url method:@"GET" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
//                
//                int result = [[successDict objectForKey:@"result"] intValue];
//                kResult_11_CheckWithAlert;
//                if (result != 1)
//                {
//                    
//                }
//                else{
//                    finishCount++;
//                    if (finishCount == deleteArray.count) {
//                        NSLog(@"删除成功!");
//                        [self publishWithPids:pids];
//                    }
//                }
//                
//            } failure:^(NSDictionary *failDict, NSError *error) {
//                
//            }];
//        }
//    }
}

- (void)publishWithPids:(NSArray *)imgIds
{
//    int publishItemid = myModel?myModel.itemid:0;
//    NSMutableArray *havePhotoArray = [NSMutableArray new];
//    
//    [self.netManage publishSupplyWithItemid:publishItemid title:titleLabel.text price:priceTextField.text catid:catidString typeid:[NSString stringWithFormat:@"%d", typeId] today:dayLabel.text content:contentTextView.text truename:nameTextField.text mobile:phoneTextField.text unit:variousView.itemLabel.text hidePhone:!_isPublicPhone provideJianyang:_sampleCutting provideJiyang:_samplePost larghezza:_larghezzaTextField.text photoArray:havePhotoArray pids:imgIds andSuccBlock:^(NSDictionary *aDict) {
//        
//        @synchronized(self){
//            if (!_isPushed) {
//                _isPushed = YES;
//                [self.netManage cleanBackup];
//                NSInteger itemId = [[aDict objectForKey:@"itemid"] integerValue];
//                YHBSupplyDetailViewController *vc = [[YHBSupplyDetailViewController alloc] initWithItemId:(int)itemId andIsMine:YES isModal:YES];
//                [self.navigationController pushViewController:vc animated:YES];
//                NSLog(@"%@", aDict);
//            }
//        }
//        
//    } failBlock:^(NSString *aStr) {
//        
//    }];
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

#pragma mark 键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==priceTextField)
    {
        if ([self isPureFloat:priceTextField.text])
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
    if (textField==nameTextField)
    {
        NSString *oldstr = nameTextField.text;
        NSString *newStr = [oldstr stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([newStr isEqualToString:@""])
        {
            [SVProgressHUD showErrorWithStatus:@"请输入姓名" cover:YES offsetY:kMainScreenWidth/2.0];
        }
        else
        {
            [nameTextField resignFirstResponder];
            [self keyboardDidDisappear];
        }
    }
    
    if (textField==phoneTextField)
    {
        if ([self isPureInt:phoneTextField.text] && phoneTextField.text.length==11)
        {
            [textField resignFirstResponder];
            [self keyboardDidDisappear];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"请输入正确号码" cover:YES offsetY:kMainScreenWidth/2.0];
        }
    }
    
    if (textField == _larghezzaTextField) {
        [textField resignFirstResponder];
        [self keyboardDidDisappear];
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
        content = textView.text;
        [textView resignFirstResponder];
                [self keyboardDidDisappear];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0)
    {
        detailPlaceHolder.hidden = YES;
    }
    else
    {
        detailPlaceHolder.hidden = NO;
    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self keyboardWillAppear];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self keyboardWillAppear];
    return YES;
}

- (void)keyboardWillAppear
{
    [self pickerPickEnd:nil];
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

    if (![priceTextField isFirstResponder])
    {
        float offY = 0;
        MLOG(@"%f", kMainScreenHeight);
        if (kMainScreenHeight>500)
        {
            offY=kMainScreenHeight;
        }
        else
        {
            offY=330;
        }
        [UIView animateWithDuration:0.2 animations:^{
            scrollView.contentOffset = CGPointMake(0, offY);
        }];
        CGRect temFrame = scrollView.frame;
        temFrame.size.height = self.view.frame.size.height - keyboardRect.size.height;
        scrollView.frame = temFrame;
    }

}

- (void)handleKeyboardDidHidden
{
    [UIView animateWithDuration:0.2 animations:^{
        scrollView.frame = self.view.bounds;
        scrollView.contentOffset = CGPointMake(0, 0);
    }];
}

- (void)keyboardDidDisappear
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - private methods
- (NSArray *)pictureArrayForAdder
{
    NSMutableArray *mutableArray = [NSMutableArray array];
//    for (YHBSupplyDetailPic *item in myModel.pic) {
//        YHBPicture *picture = [[YHBPicture alloc] init];
//        picture.type = YHBPictureTypeWeb;
//        picture.webImage = item;
//        [mutableArray addObject:picture];
//    }
    return mutableArray;
}

- (BOOL)isAllWebImage
{
    NSArray *array = self.pictureAdder.imageArray;
    BOOL ret = YES;
    for (YHBPicture *item in array) {
        if (item.type == YHBPictureTypeLocal) {
            ret = NO;
            break;
        }
    }
    return ret;
}

- (void) setupVariousViewWithTitle
{
    NSString *titleStr = titleLabel.text;
    if ([titleStr isEqual:@"样板"]) {
        variousView.itemLabel.text = @"元/本";
    }
    else if ([titleStr isEqual:@"壁纸墙布"] ||
             [titleStr isEqual:@"真皮"] ||
             [titleStr isEqual:@"遮阳"] ){
        variousView.itemLabel.text = @"元/平方";
    }
    else if ([titleStr isEqual:@"绒布"] ||
             [titleStr isEqual:@"窗帘布"] ||
             [titleStr isEqual:@"绣花"] ||
             [titleStr isEqual:@"窗纱"] ||
             [titleStr isEqual:@"辅料"] ||
             [titleStr isEqual:@"沙发布"] ||
             [titleStr isEqual:@"工程布"] ||
             [titleStr isEqual:@"人造革"]){
        variousView.itemLabel.text = @"元/米";
    }
}

- (void)restoreBackup
{
    //TODO: 还原数据
//    YHBPublishSupplyBackup *backup = [self.netManage getBackup];
//    if (backup != nil) {
//        _pictureAdder.imageArray = backup.images;
//        if (backup.title != nil && ![backup.title isEqualToString:@""]) {
//            titleLabel.text = backup.title;
//            titlePlaceHolder.hidden = YES;
//        }
//        if (backup.larghezza != nil && ![backup.larghezza isEqualToString:@""]) {
//            _larghezzaTextField.text = backup.larghezza;
//        }
//        if (backup.category != nil) {
//            [self setupCategoryWithArray:backup.category];
//            catPlaceHolder.hidden = YES;
//        }
//        if (backup.price > 0) {
//            priceTextField.text = [NSString stringWithFormat:@"%.2f", backup.price];
//        }
//        variousView.itemLabel.text = backup.unit;
//        dayLabel.text = [NSString stringWithFormat:@"%ld", (long)backup.validityPeriod];
//        if (backup.introduce != nil && ![backup.introduce isEqualToString:@""]) {
//            contentTextView.text = backup.introduce;
//            detailPlaceHolder.hidden = YES;
//        }
//        nameTextField.text = backup.userName;
//        phoneTextField.text = backup.cellphone;
////        if (backup.isPublic) {
//            [self publicPhoneButtonClick:publicPhoneButton];
//        }
//    }
}

//保存当前数据
- (void)saveBackup
{
//    YHBPublishSupplyBackup *backup = [[YHBPublishSupplyBackup alloc] init];
//    backup.images = _pictureAdder.imageArray;
//    backup.title = titleLabel.text;
//    backup.larghezza = _larghezzaTextField.text;
//    backup.category = categoryArray;
//    backup.price = priceTextField.text.floatValue;
//    backup.validityPeriod = dayLabel.text.integerValue;
//    backup.unit = variousView.itemLabel.text;
//    backup.introduce = contentTextView.text;
//    backup.userName = nameTextField.text;
//    backup.cellphone = phoneTextField.text;
//    backup.isPublic = _isPublicPhone;
//    [self.netManage saveBackup:backup];
}

- (void)setupCategoryWithArray:(NSArray *)aArray
{
    if (aArray.count>0)
    {
        catPlaceHolder.hidden = YES;
        NSString *str = @"";
        catidString = @"";
//        for (YHBCatSubcate *subModel in aArray) {
//            str = [str stringByAppendingString:[NSString stringWithFormat:@" %@", subModel.catname]];
//            catidString = [catidString stringByAppendingString:[NSString stringWithFormat:@",%d", (int)subModel.catid]];
//        }
        catidString = [catidString substringFromIndex:1];
        catNameLabel.text = str;
    }
    else
    {
        catNameLabel.text = @"";
        catPlaceHolder.hidden = NO;
    }
}

#pragma mark - getters and setters
//- (YHBPublishSupplyManage *)netManage
//{
//    if (!_netManage) {
//        _netManage = [[YHBPublishSupplyManage alloc] init];
//    }
//    return _netManage;
//}

- (UIPickerView *)dayPickerView
{
    if (!_dayPickerView)
    {
        _dayPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight+30, kMainScreenWidth, 200)];
        _dayPickerView.backgroundColor = [UIColor whiteColor];
        _dayPickerView.dataSource = self;
        _dayPickerView.delegate = self;
    }
    return _dayPickerView;
}

- (UIView *)toolView
{
    if (!_toolView) {
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.dayPickerView.top-30, kMainScreenWidth, 40)];
        _toolView.backgroundColor = [UIColor lightGrayColor];
        UIButton *_tool = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 60, 0, 60, 40)];
        [_tool setTitle:@"完成" forState:UIControlStateNormal];
        _tool.titleLabel.textAlignment = NSTextAlignmentCenter;
        _tool.tag = kButtonTag_Yes;
        _tool.titleLabel.font = kFont15;
        _tool.backgroundColor = [UIColor clearColor];
        [_tool addTarget:self action:@selector(pickerPickEnd:) forControlEvents:UIControlEventTouchDown];
        [_toolView addSubview:_tool];
        
        UIButton *_cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _cancelBtn.titleLabel.font = kFont15;
        _cancelBtn.backgroundColor = [UIColor clearColor];
        [_cancelBtn addTarget:self action:@selector(pickerPickEnd:) forControlEvents:UIControlEventTouchDown];
        [_toolView addSubview:_cancelBtn];
    }
    return _toolView;
}

- (YHBPictureAdder *)pictureAdder
{
    if (_pictureAdder == nil) {
        _pictureAdder = [[YHBPictureAdder alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 120) contentController:self];
        _pictureAdder.enableEdit = YES;
    }
    return _pictureAdder;
}

@end
