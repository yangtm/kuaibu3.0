//
//  YHBPublishSupplyViewController.m
//  YHB_Prj
//
//  Created by Johnny's on 14/11/30.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "YHBPublishBuyViewController.h"
//#import "YHBBuyDetailViewController.h"
#import "TitleTagViewController.h"
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
#import "YHBAreaModel.h"
#import "YHBCity.h"
#import "MyButton.h"
#import "ProcurementListController.h"



const NSInteger BottomLineTag = 59;

#define kButtonTag_Yes 100
#define kPeriodTextFieldTag 200
#define kAsofdateTextFieldTag 202
#define kButtonTag_Cancel 10
@interface YHBPublishBuyViewController()<UITextFieldDelegate, UIPickerViewDataSource,RecordEditViewDelegate, UIPickerViewDelegate, UIScrollViewDelegate,UIPickerViewAccessibilityDelegate>
{
    int typeId;
    float price;
    int pickViewSelected;
    
    ProcurementModel *_myModel;
    BOOL isClean;
    BOOL _isSelectBtn;
    
    NSArray *categoryArray;
    NSString *catidString;
    
    NSInteger _indexTag;
    NSInteger _billType;
    UIButton *_cancelBtn;
    NSInteger _selProvince;
    NSInteger _selCity;
    
    
    BOOL _webEdit;
    BOOL _isPublicPhone;
    BOOL _isPushed;
    BOOL _isCut;
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
@property (nonatomic, strong) UITextField *asofdateTextField;
@property (nonatomic, strong) UITextField *contactNameTextField;
@property (nonatomic, strong) UITextField *contactPhoneTextField;
@property (nonatomic, strong) UITextField *addressTextField;
@property (nonatomic, strong) UITextField *detailedAddressTextField;
@property (nonatomic, strong) MeasurePicker *measurePicker;
@property (nonatomic, strong) YHBRadioBox *publicPhoneRadiBox;

@property (nonatomic, strong) MyButton *btn1;
@property (nonatomic, strong) MyButton *btn2;
@property (nonatomic, strong) MyButton *btn3;
@property (nonatomic, strong) MyButton *btn4;
@property (nonatomic, strong) MyButton *btn5;

@property (strong, nonatomic) UIPickerView *areaPicker;
@property (strong, nonatomic) UIButton *tool;
@property (strong, nonatomic) UIView *clearView;
@property (strong, nonatomic) NSMutableArray *areaArray;
@property (strong, nonatomic) NSMutableArray *cityArray;
@property (nonatomic, strong) RecordEditView *recordEditView;
@property (nonatomic, strong) UIPickerView *dayPickerView;
@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) UIView *toolViews;
@property (nonatomic, strong) UIDatePicker *datePickerView;
@property (nonatomic, strong) UIDatePicker *datePickersView;
//@property (nonatomic, strong) YHBPublishBuyManage *netManage;
@property (nonatomic, strong) UITextField *currentTextField;
@property (nonatomic, strong) NSString *offerdateStr;//报价截止日期
@property (nonatomic, strong) NSString *goodsdateStr;//收货截止日期
@property (nonatomic, strong) NSDateFormatter *pickerFormatter;

@property (nonatomic,strong) YHBRadioBox *cutYes;
@property (nonatomic,strong) YHBRadioBox *cutNo;

@property (nonatomic,strong) ProcurementModel *model;

@end

@implementation YHBPublishBuyViewController

- (void)dealloc
{
    [self.scrollView removeAdjust];
}

- (instancetype)initWithModel:(ProcurementModel *)aModel
{
    if (self = [super init]) {
        _myModel = aModel;
        _webEdit = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeBottom;
    [self createAreaArray];

    _isSelectBtn = YES;
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(dismissSelf)];
    
    isClean = NO;
    [self settitleLabel:@"发布采购"];
    self.view.backgroundColor = RGBCOLOR(241, 241, 241);

    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.pictureAdder];
    [self.scrollView addSubview:self.editFormView];
    [self.scrollView addSubview:self.contactView];
    [self.scrollView addSubview:self.publishButton];
    
    [self setupFormView];
    [self setupContactView];
    self.publishButton.frame = CGRectMake(100, self.contactView.bottom + 10, kMainScreenWidth-200, 40);
    self.scrollView.contentSize = CGSizeMake(kMainScreenWidth, self.publishButton.bottom + 20);
    [self.scrollView autoAdjust];
    
    [self renderView];
}

- (NSMutableArray *)createAreaArray
{
    _areaArray = [[NSMutableArray alloc] init];
    _cityArray = [[NSMutableArray alloc] init];
    NSString *getAddressInfoUrl = nil;//@"http://staging.51kuaibu.com/app/getAreaList.php";
    kYHBRequestUrl(@"addressInfo/getAddressInfo", getAddressInfoUrl);
    NSLog(@"%@",getAddressInfoUrl);
    [NetworkService postWithURL:getAddressInfoUrl paramters:nil success:^(NSData *receiveData) {
        if (receiveData.length > 0) {
            id result = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
//            NSLog(@"%@",result);
            if ([result isKindOfClass:[NSDictionary class]]) {
                
                    NSArray *array = result[@"RESULT"];
//                NSLog(@"%@",array);
                for (NSDictionary *subdic in array) {
                    YHBAreaModel *model = [[YHBAreaModel alloc] init];
                    [model setValuesForKeysWithDictionary:subdic];
                    [_areaArray addObject:model];
//                    NSLog(@"%@",model.city);
                }
                
                
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
    return _areaArray;
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


//地区选择器按下确认按钮
- (void)pickerPickEnd:(UIButton *)aBtn
{
    self.periodTextField.text = [NSString stringWithFormat:@"%@",_offerdateStr];

    self.datePickerView.top = kMainScreenHeight+30;
    self.toolView.top = self.datePickerView.top-30;
    [self.dayPickerView removeFromSuperview];
    [aBtn.superview removeFromSuperview];
}

- (void)pickersPickEnd:(UIButton *)aBtn
{
    self.asofdateTextField.text = [NSString stringWithFormat:@"%@",_goodsdateStr];

    self.datePickersView.top = kMainScreenHeight+30;
    self.toolView.top = self.datePickersView.top-30;
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
    else if (textField == _asofdateTextField){
        [_currentTextField resignFirstResponder];
        _currentTextField = nil;
        [self showDayPickers];
        return NO;
    }
    else if (textField == _addressTextField){
        [_currentTextField resignFirstResponder];
        _currentTextField = nil;
        [self showAreaPickView];
        return NO;
    }
    _currentTextField = textField;
    return YES;
}

#pragma mark -地区选择
- (UIPickerView *)areaPicker
{
    if (!_areaPicker) {
        _areaPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 200)];
        _areaPicker.backgroundColor = kNaviTitleColor;
        _areaPicker.dataSource =self;
        _areaPicker.delegate = self;
        _areaPicker.showsSelectionIndicator = YES;
    }
    return _areaPicker;
}

- (UIView *)clearView
{
    if (!_clearView) {
        _clearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth,kMainScreenHeight)];
        _clearView.backgroundColor = [UIColor clearColor];
    }
    return _clearView;
}

- (void)showAreaPickView
{
    if (![self.areaPicker superview]) {
        UIToolbar *toolView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, _areaPicker.top-30, kMainScreenWidth, 40)];
        toolView.backgroundColor = RGBCOLOR(240, 240, 240);
        _tool = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 60, 0, 60, 40)];
        [_tool setTitle:@"完成" forState:UIControlStateNormal];
        _tool.titleLabel.textAlignment = NSTextAlignmentCenter;
        _tool.titleLabel.font = kFont15;
        [_tool setTitleColor:RGBCOLOR(3, 122, 255) forState:UIControlStateNormal];
        _tool.backgroundColor = [UIColor clearColor];
        [_tool addTarget:self action:@selector(addresspickerPickEnd:) forControlEvents:UIControlEventTouchDown];
        [toolView addSubview:_tool];
        
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.tag = kButtonTag_Cancel;
        _cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _cancelBtn.titleLabel.font = kFont15;
        _cancelBtn.backgroundColor = [UIColor clearColor];
        [_cancelBtn setTitleColor:RGBCOLOR(3, 122, 255) forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(addresspickerPickEnd:) forControlEvents:UIControlEventTouchDown];
        [toolView addSubview:_cancelBtn];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.clearView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.areaPicker];
        [[UIApplication sharedApplication].keyWindow addSubview:toolView];
        
        [UIView animateWithDuration:0.2 animations:^{
            _areaPicker.top = kMainScreenHeight - 180;
            toolView.top = _areaPicker.top - 30;
        }];
    }
}

#pragma 地区选择结果更新模型 ui
- (void)pickedAreaToModelAndUI
{
    if (_selProvince && _selCity) {
        YHBAreaModel *area = self.areaArray[_selProvince-1];
        YHBCity *city = [[YHBCity alloc]initWithDictionary:area.city[_selCity-1]];
        NSString *areaStr = [area.areaname stringByAppendingString:city.areaname];
        _addressTextField.text=areaStr;
        
//        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - pickerView delegate and datasource

- (void)addresspickerPickEnd:(UIButton *)sender{
    
    //HbuAreaListModelAreas *area = self.cityArray[0];
    [self.clearView removeFromSuperview];
    //[self.tableView shouldScrolltoPointY:0];
    if ([_areaPicker superview]) {
        if (sender.tag != kButtonTag_Cancel) {
            [self pickedAreaToModelAndUI];
        }else{
            _selProvince = 0;
            _selCity = 0;
            [_areaPicker selectRow:0 inComponent:0 animated:NO];
            [_areaPicker selectRow:0 inComponent:1 animated:NO];
        }
        [UIView animateWithDuration:0.2 animations:^{
            _areaPicker.top = kMainScreenHeight;
            [_areaPicker removeFromSuperview];
            [sender.superview removeFromSuperview];
        }];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return  2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return self.areaArray.count+1;
    }else{
        if (_selProvince > 0) {
            YHBAreaModel *area = self.areaArray[_selProvince-1];
            return area.city.count + 1;
        }else{
            return 1;
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 140;
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        if (row == 0) {
            return @"请选择省份";
        }else{
            YHBAreaModel *model = self.areaArray[row-1];
            return model.areaname;
        }
    }else if(component == 1){
        if (row>0) {
            YHBAreaModel *model = self.areaArray[_selProvince-1];
            YHBCity *city = [[YHBCity alloc]initWithDictionary:model.city[row-1]];
            return city.areaname;
        }else return @"请选择城市";
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        _selProvince = row;

        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];

    }else if(component == 1){
        _selCity = row;

    }
    
}

//- (void)pickerView:(UIPickerView *)pickerView
//      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    if (component == 0) {
//        _selProvince = row;
//        YHBAreaModel *model = _areaArray[row];
//        _addressTextField.text = model.areaname;
//        //重点！更新第二个轮子的数据
//        [pickerView reloadComponent:1];
//        
//        NSInteger selectedCityIndex = [pickerView selectedRowInComponent:1];
//        YHBCity *city = [[YHBCity alloc]initWithDictionary:model.city[selectedCityIndex-1]];
//        _addressTextField.text = city.areaname;
//    }else if(component == 1){
//                _selCity = row;
//                YHBAreaModel *model = _areaArray[row];
//                YHBCity *city = [[YHBCity alloc]initWithDictionary:model.city[row]];
//            }
//        NSString *msg = [NSString stringWithFormat:@"province=%@,city=%@", seletedProvince,seletedCity];
//        NSLog(@"%@",msg);
//    }
//    else {
//        NSInteger selectedProvinceIndex = [self.pickerView selectedRowInComponent:0];
//        NSString *seletedProvince = [provinceArray objectAtIndex:selectedProvinceIndex];
//        
//        NSString *seletedCity = [cityArray objectAtIndex:row];
//        NSString *msg = [NSString stringWithFormat:@"province=%@,city=%@", seletedProvince,seletedCity];
//        NSLog(@"%@",msg);
//    }
//}


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
    NSString *str = _myModel.recording;
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
    if (!_webEdit) {
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
//    if (![self checkMandatory]) {
//        [SVProgressHUD showErrorWithStatus:@"带星号的为必填项!!" cover:YES offsetY:kMainScreenHeight/2.0];
//        return;
//    }
//    if (![self checkoutImgae]) {
//        [SVProgressHUD showErrorWithStatus:@"请选择要上传的图片!!" cover:YES offsetY:kMainScreenHeight/2.0];
//        return;
//    }
//    [SVProgressHUD showWithStatus:@"图片正在上传中，请稍等..." cover:YES offsetY:kMainScreenHeight / 2.0];
//    [self saveBackup];
    
    NSString *procurementUrl = nil;
    kYHBRequestUrl(@"procurement/createProcurement", procurementUrl);
    NSDictionary *dic = [self createDictionary];
    
    NSString *str = [self dictionaryToJson:dic];
//    NSLog(@"****%@",str);
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:str,@"procurement", nil];
    
//    NSLog(@"%@",dict);
//    [FGGProgressHUD showLoadingOnView:self.view];
    __weak typeof(self) weakSelf=self;
    [NetworkService postWithURL:procurementUrl paramters:dict success:^(NSData *receiveData) {
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
    
    ProcurementListController *vc = [[ProcurementListController alloc] init];
    [self presentViewController:[[LSNavigationController alloc] initWithRootViewController:vc] animated:YES completion:^{
        
    }];
//    if ([self isAllWebImage]) {
//        [self deleteDiscardPhoto];
//    }
//    else{
//        [self updatePhoto];
//    }
    
}
/**
 *  警告视图
 *
 *  @param message   警告信息
 *  @param automatic 警告视图是否自动消失
 */
-(void)showAlertWithMessage:(NSString *)message automaticDismiss:(BOOL)automatic
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    if(automatic)
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:1.0f];
    
}
/**
 *  消失警告视图
 *
 *  @param alert 警告视图
 */
-(void)dismissAlertView:(UIAlertView *)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

- (NSMutableDictionary *)createDictionary
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:_productNameTextField.text forKey:@"productName"];
    [dic setObject:_quantityTextField.text forKey:@"amount"];
    [dic setObject:_measurePicker.dataArray[_measurePicker.selectItem] forKey:@"amountUnit"];
    [dic setObject:_asofdateTextField.text forKey:@"takeDeliveryLastDate"];
    [dic setObject:_periodTextField.text forKey:@"offerLastDate"];
    [dic setObject:_contactNameTextField.text forKey:@"contactor"];
    [dic setObject: @3 forKey:@"catId"];
    [dic setObject:@(_publicPhoneRadiBox.checked) forKey:@"PhonePublic"];
    [dic setObject:_recordEditView.filePath forKey:@"recording"];
    [dic setObject:_recordEditView.text forKey:@"details"];
    [dic setObject:@(_isCut) forKey:@"isSampleCut"];
    [dic setObject:@(_billType) forKey:@"billingType"];
    [dic setObject:_pictureAdder.imageArray forKey:@"imageUrls"];
    [dic setObject:_addressTextField.text forKey:@"district"];
    [dic setObject:_contactPhoneTextField.text forKey:@"phone"];
    return dic;
    
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

//保存当前数据
- (void)saveBackup
{
    ProcurementModel *backup = [[ProcurementModel alloc] init];
    backup.imageUrls = _pictureAdder.imageArray;
    backup.productName = _productNameTextField.text;
    //    backup.catId = categoryArray;
//    backup.amount = _quantityTextField.text;
    backup.offerLastDate = _periodTextField.text;
    backup.takeDeliveryLastDate = _asofdateTextField.text;
    backup.isSampleCut = _isCut;
    backup.billingType = _billType;
    
    backup.amountUnit = _measurePicker.dataArray[_measurePicker.selectItem];
        backup.details = _recordEditView.text;
//        backup.voicePath = _recordEditView.filePath;
//        backup.recording = _recordEditView.recordDuration;
//        backup.recordViewMode = _recordEditView.editViewModel;
    backup.contactor = _contactNameTextField.text;
    backup.phone = _contactPhoneTextField.text;
    backup.PhonePublic = _publicPhoneRadiBox.isOn;
   
    _model = [[ProcurementModel alloc] init];
    _model = backup;
}

- (void)updatePhoto
{
    NSArray *photoArray = self.pictureAdder.imageArray;
    NSString *uploadPhototUrl = nil;
    kZXYRequestUrl(@"files/uploadPurchase", uploadPhototUrl);
//    for (int i = 0; i < photoArray.count; i++) {
//        YHBPicture *picture = photoArray[i];
//        if (picture.type == YHBPictureTypeLocal) {
////            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
////                                 [YHBUser sharedYHBUser].token, @"token",
////                                 [NSString stringWithFormat:@"%d", i], @"order",
////                                 @"album", @"action",
////                                 @"0", @"itemid",
////                                 @"6", @"mid",
////                                 nil];
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
//            
//        }
//    }
}

- (void)uploadSoundWithSuccess:(void(^)(int soundId, NSString *path))cBlock failure:(void(^)(NSString *error))fBlock
{
    if (_recordEditView.editViewModel != RecordEditViewModelSound) {
        cBlock(-1, nil);
        return;
    }
    
    if (_recordEditView.netAudio) {
        cBlock(-1, _myModel.recording);
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
    if ([self isTextNotNil:_productNameTextField.text]&&[self isTextNotNil:_categoryTextField.text]&&[self isTextNotNil:_contactNameTextField.text]&&[self isTextNotNil:_contactPhoneTextField.text] && [self isTextNotNil:_quantityTextField.text]&&[self isTextNotNil:_addressTextField.text]&&[self isTextNotNil:_detailedAddressTextField.text]){
        return YES;
    }
    return NO;
}

- (void)renderView
{
    if (_myModel)
    {
        self.productNameTextField.text = _myModel.productName;
        self.categoryTextField.text = _myModel.catId;
        catidString = _myModel.memberId;
//        self.quantityTextField.text = _myModel.amount;
        self.periodTextField.text = _myModel.offerLastDate;
        self.asofdateTextField.text = _myModel.takeDeliveryLastDate;
        _isCut = _myModel.isSampleCut;
        _billType = _myModel.billingType;
        
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
    TitleTagViewController *vc = [[TitleTagViewController alloc] init];
    vc.type = 1;
    [vc useBlock:^(NSString *title) {
        self.productNameTextField.text = title;
    }];
    [self.navigationController pushViewController:vc animated:YES];
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
    if (self.datePickerView.top != kMainScreenHeight-200)
    {
        [self.view addSubview:self.datePickerView];
        [self.view addSubview:self.toolView];
        [UIView animateWithDuration:0.2 animations:^{
            self.datePickerView.top = kMainScreenHeight-200;
            self.toolView.top = self.datePickerView.top-30;
        }];
    }
}

- (void)showDayPickers
{
    if (self.datePickerView.top != kMainScreenHeight-200)
    {
        [self.view addSubview:self.datePickersView];
        [self.view addSubview:self.toolViews];
        [UIView animateWithDuration:0.2 animations:^{
            self.datePickersView.top = kMainScreenHeight-200;
            self.toolViews.top = self.datePickersView.top-30;
        }];
    }
}

#pragma mark - 编辑部分
- (void)setupFormView
{
    UIView *form0 = [self headForm:CGRectMake(0, 0, kMainScreenWidth, 30)];
    UIView *form1 = [self productNameForm:CGRectMake(0, form0.bottom, form0.width, 40)];
    UIView *form2 = [self categoryForm:CGRectMake(0, form1.bottom, form1.width, form1.height)];
    UIView *form3 = [self quantityForm:CGRectMake(0, form2.bottom, form2.width, form2.height)];
    UIView *form4 = [self periodForm:CGRectMake(0, form3.bottom, form3.width, form3.height)];
    UIView *form5 = [self asofdateForm:CGRectMake(0, form4.bottom, form4.width, form4.height)];
    UIView *form6 = [self isCutForm:CGRectMake(0, form5.bottom, form5.width, form5.height)];
    UIView *form7 = [self invoiceRequirementsForm:CGRectMake(0, form6.bottom, form6.width, form6.height)];
    UIView *form8 = [self describeForm:CGRectMake(0, form7.bottom, form7.width, 60)];
    [self.editFormView addSubview:form0];
    [self.editFormView addSubview:form1];
    [self.editFormView addSubview:form2];
    [self.editFormView addSubview:form3];
    [self.editFormView addSubview:form4];
    [self.editFormView addSubview:form6];
    [self.editFormView addSubview:form5];
    [self.editFormView addSubview:form7];
    [self.editFormView addSubview:form8];
    self.editFormView.frame = CGRectMake(0, self.pictureAdder.bottom, kMainScreenWidth, form8.bottom);
}

#pragma mark - 联系人
- (void)setupContactView
{
    UIView *form0 = [self contactNameForm:CGRectMake(0, 0, kMainScreenWidth, 40)];
    UIView *form1 = [self contactPhoneForm:CGRectMake(0, form0.bottom, form0.width, form0.height)];
    UIView *form2 = [self shippingAddressForm:CGRectMake(0, form1.bottom, form1.width, form1.height)];
//    UIView *form3 = [self detailAddressForm:CGRectMake(0, form2.bottom, form2.width, form2.height)];
    [self.contactView addSubview:form0];
    [self.contactView addSubview:form1];
    [self.contactView addSubview:form2];
//    [self.contactView addSubview:form3];
    self.contactView.frame = CGRectMake(0, self.editFormView.bottom + 10, kMainScreenWidth, form2.bottom);
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

#pragma mark -采购标题UI
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

#pragma mark -布料分类UI
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

#pragma mark -采购数量UI
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

#pragma mark - 报价截止日UI
- (UIView *)periodForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 80, frame.size.height) title:@"报价截止日:"];
    self.periodTextField.frame = CGRectMake(label.right + 5, 0, view.width - 60, view.height);
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(view.width - 40, 0, 20, view.height)];
    label1.text = @"天";
    label1.font = [UIFont systemFontOfSize:15.0];
    label1.textColor = [UIColor lightGrayColor];
    UIImageView *arrowImageView = [self arrowImageView:CGRectMake(label1.right, 15, 5, 10)];
    [view addSubview:label];
    [view addSubview:self.periodTextField];
//    [view addSubview:label1];
    [view addSubview:arrowImageView];
    [self addBottomLine:view];
    return view;
}

#pragma mark - 收货截止日UI
- (UIView *)asofdateForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 80, frame.size.height) title:@"收货截止日:"];
    self.asofdateTextField.frame = CGRectMake(label.right + 5, 0, view.width - 60, view.height);
    [view addSubview:label];
    [view addSubview:self.asofdateTextField];
    [self addBottomLine:view];
    return view;
}

#pragma mark - 是否剪样UI
- (UIView *)isCutForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 100, frame.size.height) title:@"是否需要剪样:"];
    label.userInteractionEnabled = YES;
    _btn1 = [[MyButton alloc] initWithFrame:CGRectMake(label.right+5, 0, 60, view.height) imageName:@"check_off" text:@"是"];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedBtn1:)];
    [_btn1 addGestureRecognizer:tap1];

    _btn2 = [[MyButton alloc] initWithFrame:CGRectMake(_btn1.right+20, 0, 60, view.height) imageName:@"check_off" text:@"否"];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedBtn2:)];
    [_btn2 addGestureRecognizer:tap2];
    
//    _myModel.isSampleCut = _isCut;

    [view addSubview:_btn1];
    [view addSubview:_btn2];
    [view addSubview:label];
    [self addBottomLine:view];
    return view;
}

- (void)selectedBtn1:(UIGestureRecognizer *)tap
{
    if (_btn1) {
        _isCut = YES;
        _btn1.imageView.image =[UIImage imageNamed:@"check_on"];
        _btn2.imageView.image =[UIImage imageNamed:@"check_off"];
    }
}

- (void)selectedBtn2:(UIGestureRecognizer *)tap
{
    if (_btn2) {
        _isCut = NO;
        _btn2.imageView.image =[UIImage imageNamed:@"check_on"];
        _btn1.imageView.image =[UIImage imageNamed:@"check_off"];
    }
}

#pragma mark - 开票要求UI
- (UIView *)invoiceRequirementsForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 80, frame.size.height) title:@"发票要求:"];
    
    _btn3 = [[MyButton alloc] initWithFrame:CGRectMake(label.right, 0, 80, view.height) imageName:@"check_off" text:@"普通发票"];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedBtn3:)];
    [_btn3 addGestureRecognizer:tap3];
    
    _btn4 = [[MyButton alloc] initWithFrame:CGRectMake(_btn3.right+5, 0, 80, view.height) imageName:@"check_off" text:@"增值税发票"];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedBtn4:)];
    [_btn4 addGestureRecognizer:tap4];
    
    _btn5 = [[MyButton alloc] initWithFrame:CGRectMake(_btn4.right+20, 0, 80, view.height) imageName:@"check_off" text:@"无"];
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedBtn5:)];
    [_btn5 addGestureRecognizer:tap5];
    [view addSubview:_btn3];
    [view addSubview:_btn4];
    [view addSubview:_btn5];
    [view addSubview:label];
    [self addBottomLine:view];
    return view;
}

- (void)selectedBtn3:(MyButton *)tap
{
    if (_btn3) {
        _billType = 2;
        _btn3.imageView.image =[UIImage imageNamed:@"check_on"];
        _btn4.imageView.image =[UIImage imageNamed:@"check_off"];
        _btn5.imageView.image =[UIImage imageNamed:@"check_off"];
    }
}

- (void)selectedBtn4:(MyButton *)tap
{
    if (_btn4) {
        _billType = 3;
        _btn4.imageView.image =[UIImage imageNamed:@"check_on"];
        _btn3.imageView.image =[UIImage imageNamed:@"check_off"];
        _btn5.imageView.image =[UIImage imageNamed:@"check_off"];
    }
}

- (void)selectedBtn5:(MyButton *)tap
{
    if (_btn5) {
        _billType = 1;
        _btn5.imageView.image =[UIImage imageNamed:@"check_on"];
        _btn3.imageView.image =[UIImage imageNamed:@"check_off"];
        _btn4.imageView.image =[UIImage imageNamed:@"check_off"];
    }
}

#pragma mark - 详情UI
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

#pragma mark - 联系人UI
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

#pragma mark - 联系电话UI
- (UIView *)contactPhoneForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 70, frame.size.height) title:@"*联系电话:"];
    self.contactPhoneTextField.frame = CGRectMake(label.right + 5, 0, view.width - label.right - 80, view.height);
//    self.publicPhoneRadiBox.frame = CGRectMake(_contactPhoneTextField.right, 10, 60, view.height);
    _publicPhoneRadiBox = [[YHBRadioBox alloc] initWithFrame:CGRectMake(_contactPhoneTextField.right+2, 0, 60, view.height) checkedImage:[UIImage imageNamed:@"check_on"] uncheckedImage:[UIImage imageNamed:@"check_off"] title:@"公开"];
    [_publicPhoneRadiBox addTarget:self action:@selector(publicPhoneRadioBoxValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:label];
    [view addSubview:self.contactPhoneTextField];
    [view addSubview:_publicPhoneRadiBox];
    [self addBottomLine:view];
    return view;
}

#pragma mark - 收货地址UI
- (UIView *)shippingAddressForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 80, view.height) title:@"*收货地址:"];
    self.addressTextField.frame = CGRectMake(label.right+5, 0, view.width- 60, view.height);
    [view addSubview:label];
    [view addSubview:self.addressTextField];
    [self addBottomLine:view];
    return view;
}

#pragma mark - 详细地址UI
- (UIView *)detailAddressForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 80, view.height) title:@"*详细地址:"];
    self.detailedAddressTextField.frame = CGRectMake(label.right+5, 0, view.width-10, view.height);
    [view addSubview:label];
    [view addSubview:self.detailedAddressTextField];
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

- (UIDatePicker *)datePickerView
{
    if (!_datePickerView) {
        
        _datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kMainScreenHeight+30, kMainScreenWidth, 100)];
        _datePickerView.backgroundColor = kNaviTitleColor;
        
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
       
        _datePickerView.locale = locale;
        
        NSDate *localeDate = [NSDate date];

        [_datePickerView setDatePickerMode: UIDatePickerModeDate]; // 设置日期选择器模式
        [_datePickerView setDate: localeDate animated: YES]; // 设置默认选中日期

        _datePickerView.minimumDate = localeDate;
        
        NSDate *pickerDate = [_datePickerView date];
        _pickerFormatter = [[NSDateFormatter alloc] init];
//        [_pickerFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
        [_pickerFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [_pickerFormatter stringFromDate:pickerDate];
        _offerdateStr = dateString;
        [_datePickerView addTarget: self action: @selector(onDatePickerChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePickerView;
}

- (UIDatePicker *)datePickersView
{
    if (!_datePickersView) {
        
        _datePickersView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kMainScreenHeight+30, kMainScreenWidth, 100)];
        _datePickersView.backgroundColor = kNaviTitleColor;
        
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        
        _datePickersView.locale = locale;
        
        NSDate *localeDate = [NSDate date];
        
        [_datePickersView setDatePickerMode: UIDatePickerModeDate]; // 设置日期选择器模式
        [_datePickersView setDate: localeDate animated: YES]; // 设置默认选中日期
        
        _datePickersView.minimumDate = localeDate;
        
        NSDate *pickerDate = [_datePickersView date];
        _pickerFormatter = [[NSDateFormatter alloc] init];
//        [_pickerFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
        [_pickerFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [_pickerFormatter stringFromDate:pickerDate];
        _goodsdateStr = dateString;
        [_datePickerView addTarget: self action: @selector(onDatePickersChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePickerView;
}


- (void)onDatePickerChanged: (UIDatePicker *)datePicker {

//    [_pickerFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    [_pickerFormatter setDateFormat:@"yyyy-MM-dd"];
    _offerdateStr = [_pickerFormatter stringFromDate:datePicker.date];
}

- (void)onDatePickersChanged: (UIDatePicker *)datePicker {
    
//    [_pickerFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    [_pickerFormatter setDateFormat:@"yyyy-MM-dd"];
    _goodsdateStr = [_pickerFormatter stringFromDate:datePicker.date];
}

- (UIPickerView *)dayPickerView
{
    if (!_dayPickerView)
    {
        _dayPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight+30, kMainScreenWidth, 100)];
        _dayPickerView.backgroundColor = kNaviTitleColor;
        
        
        
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

- (UIView *)toolViews
{
    if (!_toolViews) {
        
        _toolViews = [[UIView alloc] initWithFrame:CGRectMake(0, self.dayPickerView.top-30, kMainScreenWidth, 40)];
        _toolViews.backgroundColor = [UIColor lightGrayColor];
        UIButton *_tools = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 60, 0, 60, 40)];
        [_tools setTitle:@"完成" forState:UIControlStateNormal];
        _tools.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _tools.tag = kButtonTag_Yes;
        
        _tools.titleLabel.font = kFont15;
        _tools.backgroundColor = [UIColor clearColor];
        [_tools addTarget:self action:@selector(pickersPickEnd:) forControlEvents:UIControlEventTouchDown];
        [_toolViews addSubview:_tools];
        
        UIButton *_cancelBtns = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        [_cancelBtns setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtns.titleLabel.textAlignment = NSTextAlignmentCenter;
        _cancelBtns.titleLabel.font = kFont15;
        _cancelBtns.backgroundColor = [UIColor clearColor];
        [_cancelBtns addTarget:self action:@selector(pickersPickEnd:) forControlEvents:UIControlEventTouchDown];
        [_toolViews addSubview:_cancelBtns];
    }
    return _toolViews;
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
        _periodTextField.tag = kPeriodTextFieldTag;
        _indexTag = _productNameTextField.tag;
        _periodTextField.delegate = self;
    }
    return _periodTextField;
}

- (UITextField *)asofdateTextField
{
    if (_asofdateTextField == nil) {
        _asofdateTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _asofdateTextField.font = [UIFont systemFontOfSize:15.0];
        _asofdateTextField.tag = kAsofdateTextFieldTag;
        _indexTag = _asofdateTextField.tag;
        _asofdateTextField.delegate = self;
    }
    return _asofdateTextField;
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

- (UITextField *)addressTextField
{
    if (_addressTextField ==nil) {
        _addressTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _addressTextField.font = [UIFont systemFontOfSize:15.0];
        _addressTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _addressTextField.returnKeyType = UIReturnKeyDone;
        _addressTextField.placeholder = @"请选择所在地区";
        [_addressTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        _addressTextField.delegate = self;
    }
    return _addressTextField;
}

- (UITextField *)detailedAddressTextField
{
    if (_detailedAddressTextField == nil) {
        _detailedAddressTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _detailedAddressTextField.font = [UIFont systemFontOfSize:15.0];
        _detailedAddressTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _detailedAddressTextField.returnKeyType = UIReturnKeyDone;
        _detailedAddressTextField.placeholder = @"请输入你的详细地址";
        [_detailedAddressTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        _detailedAddressTextField.delegate = self;
    }
    return _detailedAddressTextField;
}

#pragma mark - 是否剪样按钮


#pragma mark - 公开按钮
- (YHBRadioBox *)publicPhoneRadiBox
{
    if (_publicPhoneRadiBox == nil) {
        _publicPhoneRadiBox = [[YHBRadioBox alloc] initWithFrame:CGRectMake(0, 0, 60, 20) checkedImage:[UIImage imageNamed:@"check_on"] uncheckedImage:[UIImage imageNamed:@"check_off"] title:@"公开"];
        [_publicPhoneRadiBox addTarget:self action:@selector(publicPhoneRadioBoxValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _publicPhoneRadiBox;
}
#pragma mark - event response
- (void)publicPhoneRadioBoxValueDidChanged:(YHBRadioBox *)radioBox
{
    
    switch (radioBox.tag) {
        case 1001:
            if (_isSelectBtn) {
//                _cutNo.userInteractionEnabled = YES;
//                _cutYes.userInteractionEnabled = NO;
                _isSelectBtn = !_isSelectBtn;
                }
//            NSLog(@"%d",radioBox.tag);
            break;
        case 1002:
            if (_isSelectBtn) {
//                _cutNo.userInteractionEnabled = YES;
//                _cutYes.userInteractionEnabled = NO;
                _isSelectBtn = !_isSelectBtn;}
//            NSLog(@"%d",radioBox.tag);
            break;
        default:
            break;
    }

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
