//
//  YHBPublishSupplyViewController.m
//  YHB_Prj
//
//  Created by Johnny's on 14/11/30.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "YHBPublishBuyViewController.h"
//#import "YHBBuyDetailViewController.h"
//#import "TitleTagViewController.h"
#import "SVProgressHUD.h"
//#import "YHBPublishBuyManage.h"
//#import "CategoryViewController.h"
//#import "YHBCatSubcate.h"
//#import "YHBUser.h"
//#import "NetManager.h"
//#import "YHBBuyDetailAlbum.h"
#import "YHBPictureAdder.h"
#import "YHBPicture.h"
#import "UIImage+Extensions.h"
#import "RecordEditView.h"
#import "UIViewAdditions.h"
#import "YHBRadioBox.h"
#import "UIScrollView+AvoidingKeyboard.h"
#import "MeasurePicker.h"
//#import "amrFileCodec.h"


const NSInteger BottomLineTag = 59;

#define kButtonTag_Yes 100

@interface YHBPublishBuyViewController()<UITextFieldDelegate, UIPickerViewDataSource,RecordEditViewDelegate, UIPickerViewDelegate, UIScrollViewDelegate>
{
    int typeId;
    float price;
    int pickViewSelected;
    
    ProcurementModel *myModel;
    BOOL isClean;
    
    NSArray *categoryArray;
    NSString *catidString;
    
    BOOL webEdit;
    BOOL _isPublicPhone;
    BOOL _isPushed;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) YHBPictureAdder *pictureAdder;
@property (nonatomic, strong) UIView *editFormView;
@property (nonatomic, strong) UIView *contactView;
@property (nonatomic, strong) UIButton *publishButton;
@property (nonatomic, strong) UITextField *productNameTextField;
@property (nonatomic, strong) UITextField *categoryTextField;
@property (nonatomic, strong) UITextField *quantityTextField;
@property (nonatomic, strong) UITextField *periodTextField;
@property (nonatomic, strong) UITextField *contactNameTextField;
@property (nonatomic, strong) UITextField *contactPhoneTextField;
@property (nonatomic, strong) MeasurePicker *measurePicker;
@property (nonatomic, strong) YHBRadioBox *publicPhoneRadiBox;
@property (nonatomic, strong) RecordEditView *recordEditView;
@property (nonatomic, strong) UIPickerView *dayPickerView;
@property (nonatomic, strong) UIView *toolView;
//@property (nonatomic, strong) YHBPublishBuyManage *netManage;
@property (nonatomic, strong) UITextField *currentTextField;

@end

@implementation YHBPublishBuyViewController

- (void)dealloc
{
    [self.scrollView removeAdjust];
}

//- (instancetype)initWithModel:(YHBBuyDetailData *)aModel
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
    
    isClean = NO;
    self.title = @"发布采购";
    self.view.backgroundColor = RGBCOLOR(241, 241, 241);

    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.pictureAdder];
    [self.scrollView addSubview:self.editFormView];
    [self.scrollView addSubview:self.contactView];
    [self.scrollView addSubview:self.publishButton];
    
    [self setupFormView];
    [self setupContactView];
    self.publishButton.frame = CGRectMake(10, self.contactView.bottom + 10, kMainScreenWidth - 20, 40);
    self.scrollView.contentSize = CGSizeMake(kMainScreenWidth, self.publishButton.bottom + 20);
    [self.scrollView autoAdjust];
    
    [self renderView];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"发布求购"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.recordEditView stopPlay];
    [MobClick endLogPageView:@"发布求购"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark pickerView datasource delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 30;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%d", (int)row+1];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    pickViewSelected = (int)row;
}

//地区选择器按下确认按钮
- (void)pickerPickEnd:(UIButton *)aBtn
{
    if (aBtn.tag == kButtonTag_Yes)
    {
        self.periodTextField.text = [NSString stringWithFormat:@"%d", pickViewSelected+1];
    }
    self.dayPickerView.top = kMainScreenHeight+30;
    self.toolView.top = self.dayPickerView.top-30;
    [self.dayPickerView removeFromSuperview];
    [aBtn.superview removeFromSuperview];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _productNameTextField) {
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
    else if (textField == _periodTextField){
        [_currentTextField resignFirstResponder];
        _currentTextField = nil;
        [self showDayPicker];
        return NO;
    }
    _currentTextField = textField;
    return YES;
}

#pragma mark - RecordEditViewDelegate
- (void)editViewSizeDidChanged:(RecordEditView *)view
{
    CGRect rect = self.recordEditView.frame;
    rect.size.height += view.difHeight;
    self.recordEditView.frame = rect;
    
    UIView *form = view.superview;
    rect = form.frame;
    rect.size.height += view.difHeight;
    form.frame = rect;
    
    UIView *bottomLine = [form viewWithTag:BottomLineTag];
    rect = bottomLine.frame;
    rect.origin.y += view.difHeight;
    bottomLine.frame = rect;
    
    rect = self.editFormView.frame;
    rect.size.height += view.difHeight;
    self.editFormView.frame = rect;
    
    rect = self.contactView.frame;
    rect.origin.y += view.difHeight;
    self.contactView.frame = rect;
    
    self.publishButton.frame = CGRectMake(10, self.contactView.bottom + 10, kMainScreenWidth - 20, 40);
    self.scrollView.contentSize = CGSizeMake(kMainScreenWidth, self.publishButton.bottom + 20);
}

- (void)editViewAudioData:(RecordEditView *)view audioData:(void (^)(NSData *))audioData
{
    NSString *str = myModel.recording;
    str = [str substringFromIndex:1];
//    NSString *url = [NSString stringWithFormat:@"%@%@", kYHBUrl, str];
//    
//    [NetManager downloadFileWithUrl:url parameters:nil progressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        
//    } succ:^(NSData *data) {
//        
//        audioData(data);
//        
//    } failure:^(NSDictionary *failDict, NSError *error) {
//        
//        audioData(nil);
//        
//    }];
}

#pragma mark - event response
//- (void)publicPhoneRadioBoxValueDidChanged:(YHBRadioBox *)radioBox
//{
//    
//}

#pragma mark 返回
- (void)dismissSelf
{
    if (!webEdit) {
        [self saveBackup];
    }
//    [[CategoryViewController sharedInstancetype] cleanAll];
    [self dismissFlower];
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
    NSArray *photoArray = self.pictureAdder.imageArray;
    NSString *uploadPhototUrl = nil;
    kYHBRequestUrl(@"upload.php", uploadPhototUrl);
    for (int i = 0; i < photoArray.count; i++) {
        YHBPicture *picture = photoArray[i];
        if (picture.type == YHBPictureTypeLocal) {
//            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 [YHBUser sharedYHBUser].token, @"token",
//                                 [NSString stringWithFormat:@"%d", i], @"order",
//                                 @"album", @"action",
//                                 @"0", @"itemid",
//                                 @"6", @"mid",
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
            
        }
    }
}

- (void)uploadSoundWithSuccess:(void(^)(int soundId, NSString *path))cBlock failure:(void(^)(NSString *error))fBlock
{
    if (_recordEditView.editViewModel != RecordEditViewModelSound) {
        cBlock(-1, nil);
        return;
    }
    
    if (_recordEditView.netAudio) {
        cBlock(-1, myModel.recording);
        return;
    }
    
    NSString *url = nil;
    kYHBRequestUrl(@"upload_voice.php", url);
//    NSDictionary *paramDic = @{@"token": [YHBUser sharedYHBUser].token,
//                               @"seconds": @(_recordEditView.recordDuration)};
//    NSData *soundData = EncodeWAVEToAMR([NSData dataWithContentsOfFile:_recordEditView.filePath], 1, 16);
//    
////    NSData *soundData = [NSData dataWithContentsOfFile:_recordEditView.filePath];
//    
//    [NetManager uploadFile:soundData parameters:paramDic uploadUrl:url uploadFileName:@"voice" parameEncoding:AFJSONParameterEncoding progressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        
//    } succ:^(NSDictionary *successDict) {
//        
//        NSDictionary *data = [successDict objectForKey:@"data"];
//        NSInteger soundId = [[data objectForKey:@"id"] integerValue];
//        NSString *filePath = [data objectForKey:@"path"];
//        cBlock((int)soundId, filePath);
//        
//    } failure:^(NSDictionary *failDict, NSError *error) {
//        
//        fBlock(error.localizedDescription);
//        
//    }];
}

- (void)deleteDiscardPhoto
{
//    NSArray *photoArray = self.pictureAdder.imageArray;
//    NSMutableArray *deleteArray = [NSMutableArray array];
//    for (YHBBuyDetailAlbum *album in myModel.album) {
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
//    [self uploadSoundWithSuccess:^(int soundId, NSString *path) {
//        
//        int publishItemid = myModel? myModel.itemid : 0;
//        NSMutableArray *havePhotoArray = [NSMutableArray new];
//        
//        NSString *contentStr = nil;
//        if (_recordEditView.editViewModel == RecordEditViewModelText) {
//            contentStr = _recordEditView.text;
//        }
//        NSString *unitStr = _measurePicker.dataArray[_measurePicker.selectItem];
//    
//        [self.netManage publishBuyWithItemid:publishItemid title:_productNameTextField.text catid:catidString today:_periodTextField.text content:contentStr soundPath:path truename:_contactNameTextField.text mobile:_contactPhoneTextField.text unit:unitStr album:havePhotoArray amount:_quantityTextField.text pids:imgIds publicPhone:!_publicPhoneRadiBox.isOn andSuccBlock:^(NSDictionary *aDict) {
//            
//            @synchronized(self){
//                if (!_isPushed) {
//                    [_netManage cleanBackup];
//                    _isPushed = YES;
//                    NSInteger itemId = [[aDict objectForKey:@"itemid"] integerValue];
//                    YHBBuyDetailViewController *vc = [[YHBBuyDetailViewController alloc] initWithItemId:(int)itemId andIsMine:YES isModal:YES];
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//            }
//            
//        } failBlock:^(NSString *aStr) {
//            
//        }];
//        
//    } failure:^(NSString *error) {
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

#pragma mark 菊花
- (void)showFlower
{
    [SVProgressHUD show:YES offsetY:kMainScreenHeight/2.0];
}

- (void)dismissFlower
{
    [SVProgressHUD dismiss];
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

#pragma mark - private methods
- (NSArray *)pictureArrayForAdder
{
//    NSMutableArray *mutableArray = [NSMutableArray array];
//    for (YHBSupplyDetailPic *item in myModel.album) {
//        YHBPicture *picture = [[YHBPicture alloc] init];
//        picture.type = YHBPictureTypeWeb;
//        picture.webImage = item;
//        [mutableArray addObject:picture];
//    }
//    return mutableArray;
    return nil;
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

//还原上次填写数据
- (void)restoreBackup
{
//    YHBPublishBuyBackup *backup = [self.netManage getBackup];
//    if (backup != nil) {
//        _pictureAdder.imageArray = backup.images;
//        _productNameTextField.text = backup.title;
//        [self setupCategoryWithArray:backup.category];
//        if (backup.amount > 0) {
//            _quantityTextField.text = [NSString stringWithFormat:@"%d", (int)backup.amount];
//        }
//        _periodTextField.text = [NSString stringWithFormat:@"%d", (int)backup.validityPeriod];
//        _contactNameTextField.text = backup.userName;
//        _contactPhoneTextField.text = backup.cellphone;
//        _publicPhoneRadiBox.isOn = backup.isPublic;
//    }
}

//保存当前数据
- (void)saveBackup
{
//    YHBPublishBuyBackup *backup = [[YHBPublishBuyBackup alloc] init];
//    backup.images = _pictureAdder.imageArray;
//    backup.title = _productNameTextField.text;
//    backup.category = categoryArray;
//    backup.amount = _quantityTextField.text.integerValue;
//    backup.validityPeriod = _periodTextField.text.integerValue;
//    backup.unit = _measurePicker.dataArray[_measurePicker.selectItem];
//    backup.introduce = _recordEditView.text;
//    backup.voicePath = _recordEditView.filePath;
//    backup.voiceSeconds = _recordEditView.recordDuration;
//    backup.recordViewMode = _recordEditView.editViewModel;
//    backup.userName = _contactNameTextField.text;
//    backup.cellphone = _contactPhoneTextField.text;
//    backup.isPublic = _publicPhoneRadiBox.isOn;
//    [self.netManage saveBackup:backup];
}

//设置分类的数据和显示
- (void)setupCategoryWithArray:(NSArray *)aArray
{
    if (aArray.count>0)
    {
        NSString *str = @"";
        catidString = @"";
//        for (YHBCatSubcate *subModel in aArray) {
//            str = [str stringByAppendingString:[NSString stringWithFormat:@" %@", subModel.catname]];
//            catidString = [catidString stringByAppendingString:[NSString stringWithFormat:@",%d", (int)subModel.catid]];
//        }
        self.categoryTextField.text = str;
    }
    else
    {
        self.categoryTextField.text = @"";
    }
}

//检查必填项是否不为空
- (BOOL) checkMandatory
{
    if ([self isTextNotNil:_productNameTextField.text]&&[self isTextNotNil:_categoryTextField.text]&&[self isTextNotNil:_contactNameTextField.text]&&[self isTextNotNil:_contactPhoneTextField.text] && [self isTextNotNil:_quantityTextField.text]){
        return YES;
    }
    return NO;
}

- (void)renderView
{
    if (myModel)
    {
        self.productNameTextField.text = myModel.productName;
        self.categoryTextField.text = myModel.catId;
        catidString = myModel.memberId;
        self.quantityTextField.text = myModel.amount;
//        self.periodTextField.text = myModel.today;
//        self.contactNameTextField.text = myModel.truename;
//        self.contactPhoneTextField.text = myModel.mobile;
//        self.pictureAdder.imageArray = [self pictureArrayForAdder];
//        self.publicPhoneRadiBox.isOn = !myModel.hidePhone;
//        self.measurePicker.selectItem = [self selectUnit:myModel.unit];
//        if (myModel.voicePath != nil && ![myModel.voicePath isEqualToString:@""]) {
//            self.recordEditView.recordDuration = myModel.voiceSeconds;
//            self.recordEditView.netAudio = YES;
//        }
//        else{
//            self.recordEditView.text = myModel.introduce;
//        }
    }
    else{
//        self.periodTextField.text = @"30";
//        YHBUser *user = [YHBUser sharedYHBUser];
//        self.contactNameTextField.text = user.userInfo.truename;
//        self.contactPhoneTextField.text = user.userInfo.telephone;
//        [self restoreBackup];
    }
}

- (NSInteger)selectUnit:(NSString *)str
{
    for (int i = 0; i < _measurePicker.dataArray.count; i++) {
        NSString *unitStr = _measurePicker.dataArray[i];
        if ([str isEqualToString:unitStr]) {
            return i;
        }
    }
    return 0;
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

- (void)showTitletTagView
{
//    TitleTagViewController *vc = [[TitleTagViewController alloc] init];
//    vc.type = 1;
//    [vc useBlock:^(NSString *title) {
//        self.productNameTextField.text = title;
//    }];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showCategoryView
{
//    CategoryViewController *vc = [CategoryViewController sharedInstancetype];
//    if (!isClean) {
//        isClean = YES;
//        [vc cleanAll];
//    }
//    vc.isPushed = YES;
//    [vc setBlock:^(NSArray *aArray) {
//        categoryArray = aArray;
//        [self setupCategoryWithArray:aArray];
//    }];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showDayPicker
{
    if (self.dayPickerView.top != kMainScreenHeight-200)
    {
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

- (void)setupFormView
{
    UIView *form0 = [self headForm:CGRectMake(0, 0, kMainScreenWidth, 30)];
    UIView *form1 = [self productNameForm:CGRectMake(0, form0.bottom, form0.width, 40)];
    UIView *form2 = [self categoryForm:CGRectMake(0, form1.bottom, form1.width, form1.height)];
    UIView *form3 = [self quantityForm:CGRectMake(0, form2.bottom, form2.width, form2.height)];
    UIView *form4 = [self periodForm:CGRectMake(0, form3.bottom, form3.width, form3.height)];
    UIView *form5 = [self describeForm:CGRectMake(0, form4.bottom, form4.width, 60)];
    [self.editFormView addSubview:form0];
    [self.editFormView addSubview:form1];
    [self.editFormView addSubview:form2];
    [self.editFormView addSubview:form3];
    [self.editFormView addSubview:form4];
    [self.editFormView addSubview:form5];
    self.editFormView.frame = CGRectMake(0, self.pictureAdder.bottom, kMainScreenWidth, form5.bottom);
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

- (UIView *)productNameForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 70, frame.size.height) title:@"*采购标题:"];
    self.productNameTextField.frame = CGRectMake(label.right + 5, 0, view.width - label.right, view.height);
    [view addSubview:label];
    [view addSubview:self.productNameTextField];
    [self addBottomLine:view];
    return view;
}

- (UIView *)categoryForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 70, frame.size.height) title:@"*布料分类:"];
    self.categoryTextField.frame = CGRectMake(label.right + 5, 0, view.width - label.right - 20, view.height);
    UIImageView *arrowImageView = [self arrowImageView:CGRectMake(self.categoryTextField.right, 15, 5, 10)];
    [view addSubview:label];
    [view addSubview:self.categoryTextField];
    [view addSubview:arrowImageView];
    [self addBottomLine:view];
    return view;
}

- (UIView *)quantityForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 70, frame.size.height) title:@"*采购数量:"];
    self.quantityTextField.frame = CGRectMake(label.right + 5, 0, view.width - 70 - label.right, frame.size.height);
    self.measurePicker.frame = CGRectMake(_quantityTextField.right, 10, 50, 20);
    [view addSubview:label];
    [view addSubview:_quantityTextField];
    [view addSubview:self.measurePicker];
    [self addBottomLine:view];
    return view;
}

- (UIView *)periodForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 70, frame.size.height) title:@" 求购周期:"];
    self.periodTextField.frame = CGRectMake(label.right + 5, 0, view.width - 60, view.height);
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(view.width - 40, 0, 20, view.height)];
    label1.text = @"天";
    label1.font = [UIFont systemFontOfSize:15.0];
    label1.textColor = [UIColor lightGrayColor];
    UIImageView *arrowImageView = [self arrowImageView:CGRectMake(label1.right, 15, 5, 10)];
    [view addSubview:label];
    [view addSubview:self.periodTextField];
    [view addSubview:label1];
    [view addSubview:arrowImageView];
    [self addBottomLine:view];
    return view;
}

- (UIView *)describeForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    self.recordEditView = [[RecordEditView alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 40)];
    self.recordEditView.delegate = self;
    self.recordEditView.attachScrollView = self.scrollView;
    [view addSubview:self.recordEditView];
    [self addBottomLine:view];
    return view;
}

- (UIView *)contactNameForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 70, frame.size.height) title:@"*联 系 人:"];
    self.contactNameTextField.frame = CGRectMake(label.right + 5, 0, view.width - label.right, view.height);
    [view addSubview:label];
    [view addSubview:self.contactNameTextField];
    [self addBottomLine:view];
    return view;
}

- (UIView *)contactPhoneForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 70, frame.size.height) title:@"*联系电话:"];
    self.contactPhoneTextField.frame = CGRectMake(label.right + 5, 0, view.width - label.right - 80, view.height);
    self.publicPhoneRadiBox.frame = CGRectMake(_contactPhoneTextField.right, 10, 60, 30);
    [view addSubview:label];
    [view addSubview:self.contactPhoneTextField];
    [view addSubview:self.publicPhoneRadiBox];
    [self addBottomLine:view];
    return view;
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
    lineView.tag = BottomLineTag;
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

//- (YHBPublishBuyManage *)netManage
//{
//    if (!_netManage) {
//        _netManage = [[YHBPublishBuyManage alloc] init];
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

- (UITextField *)productNameTextField
{
    if (_productNameTextField == nil) {
        _productNameTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _productNameTextField.font = [UIFont systemFontOfSize:15];
        _productNameTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _productNameTextField.returnKeyType = UIReturnKeyDone;
        _productNameTextField.placeholder = @"请选择或输入品名关键词";
        [_productNameTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        _productNameTextField.delegate = self;
    }
    return _productNameTextField;
}

- (UITextField *)categoryTextField
{
    if (_categoryTextField == nil) {
        _categoryTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _categoryTextField.font = [UIFont systemFontOfSize:15];
        _categoryTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _categoryTextField.returnKeyType = UIReturnKeyDone;
        _categoryTextField.placeholder = @"请选择产品类目";
        [_categoryTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        _categoryTextField.delegate = self;
    }
    return _categoryTextField;
}

- (UITextField *)quantityTextField
{
    if (_quantityTextField == nil) {
        _quantityTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _quantityTextField.font = [UIFont systemFontOfSize:15];
        _quantityTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _quantityTextField.returnKeyType = UIReturnKeyDone;
        _quantityTextField.placeholder = @"需求数量";
        [_quantityTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        _quantityTextField.delegate = self;
    }
    return _quantityTextField;
}

- (MeasurePicker *)measurePicker
{
    if (_measurePicker == nil) {
        NSArray *array = @[@"米", @"本", @"码", @"平方", @"卷"];
        _measurePicker = [[MeasurePicker alloc] initWithFrame:CGRectMake(0, 0, 50, 20) attachView:self.scrollView dataArray:array];
    }
    return _measurePicker;
}

- (UITextField *)periodTextField
{
    if (_periodTextField == nil) {
        _periodTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _periodTextField.font = [UIFont systemFontOfSize:15.0];
        _periodTextField.delegate = self;
    }
    return _periodTextField;
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

- (YHBRadioBox *)publicPhoneRadiBox
{
    if (_publicPhoneRadiBox == nil) {
        _publicPhoneRadiBox = [[YHBRadioBox alloc] initWithFrame:CGRectMake(0, 0, 60, 20) checkedImage:[UIImage imageNamed:@"btnChoose"] uncheckedImage:[UIImage imageNamed:@"btnNotChoose"] title:@"公开"];
        [_publicPhoneRadiBox addTarget:self action:@selector(publicPhoneRadioBoxValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _publicPhoneRadiBox;
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.recordEditView setRecordButtonAvaliable:NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.recordEditView setRecordButtonAvaliable:YES];
}

@end
