////
////  AddressEditViewController.m
////  kuaibu
////
////  Created by zxy on 15/9/7.
////  Copyright (c) 2015年 yangtm. All rights reserved.
////
//
#import "AddressEditViewController.h"
#import "AddressManager.h"
//#import "SVProgressHUD.h"
#import "AddressModel.h"
//
//
//#define kButtonTag_Cancel 10
//
@interface AddressEditViewController()
//<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    success_Handle _handel;
    UIButton *_cancelBtn;
    
    NSInteger _selProvince;
    NSInteger _selCity;
}
@property (strong, nonatomic) AddressManager *addManager;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *areaArray;
@property (strong, nonatomic) AddressModel *addModel;
@property (strong, nonatomic) UIPickerView *areaPicker;
@property (strong, nonatomic) UIButton *saveButton;
@property (assign, nonatomic) BOOL isNew;
@property (strong, nonatomic) UIView *clearView;
@property (strong, nonatomic) UIButton *tool;
//
//
@end
//
@implementation AddressEditViewController
//
//- (YHBAddressManager *)addManager
//{
//    if (!_addManager) {
//        _addManager = [[YHBAddressManager alloc] init];
//    }
//    return _addManager;
//}
//
//- (UIView *)clearView
//{
//    if (!_clearView) {
//        _clearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth,kMainScreenHeight)];
//        _clearView.backgroundColor = [UIColor clearColor];
//    }
//    return _clearView;
//}
//
//- (UIPickerView *)areaPicker
//{
//    if (!_areaPicker) {
//        _areaPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 200)];
//        _areaPicker.backgroundColor = [UIColor whiteColor];
//        _areaPicker.dataSource =self;
//        _areaPicker.delegate = self;
//        _areaPicker.showsSelectionIndicator = YES;
//    }
//    return _areaPicker;
//}
//
//- (UIButton *)saveButton
//{
//    if (!_saveButton) {
//        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _saveButton.frame = CGRectMake(20, self.tableView.bottom+30, kMainScreenWidth-40, 40);
//        [_saveButton setBackgroundColor:KColor];
//        [_saveButton addTarget:self action:@selector(touchSaveBtn) forControlEvents:UIControlEventTouchUpInside];
//        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
//        _saveButton.layer.cornerRadius = 6.0;
//        _saveButton.titleLabel.font = kFont20;
//    }
//    return _saveButton;
//}
//
//- (UITableView *)tableView
//{
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 230) style:UITableViewStylePlain];
//        _tableView.backgroundColor = kViewBackgroundColor;
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//    }
//    return _tableView;
//}
//
- (instancetype)initWithAddressModel:(AddressModel *)model isNew:(BOOL)isnew SuccessHandle:(success_Handle)handel
{
    self = [super init];
    if (self) {
        self.isNew = isnew;
        _handel = handel;
        _addModel = model;
        self.title = @"收货地址管理";
        _selCity = 0 ;
        _selProvince = 0;
        if (isnew) {
            self.addModel = [[AddressModel alloc] init];
        }
    }
    return self;
}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [SVProgressHUD dismiss];
//    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:@"收货地址管理"];
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [MobClick beginLogPageView:@"收货地址管理"];
//}
//
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeBottom;
//    
    self.view.backgroundColor = kViewBackgroundColor;
//    [self setExtraCellLineHidden:self.tableView];
//    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.saveButton];
}
//
//- (void)showAreaPickView
//{
//    if (![self.areaPicker superview]) {
//        UIToolbar *toolView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, _areaPicker.top-30, kMainScreenWidth, 40)];
//        toolView.backgroundColor = RGBCOLOR(240, 240, 240);
//        _tool = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 60, 0, 60, 40)];
//        [_tool setTitle:@"完成" forState:UIControlStateNormal];
//        _tool.titleLabel.textAlignment = NSTextAlignmentCenter;
//        _tool.titleLabel.font = kFont15;
//        [_tool setTitleColor:RGBCOLOR(3, 122, 255) forState:UIControlStateNormal];
//        _tool.backgroundColor = [UIColor clearColor];
//        [_tool addTarget:self action:@selector(pickerPickEnd:) forControlEvents:UIControlEventTouchDown];
//        [toolView addSubview:_tool];
//        
//        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
//        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//        _cancelBtn.tag = kButtonTag_Cancel;
//        _cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//        _cancelBtn.titleLabel.font = kFont15;
//        _cancelBtn.backgroundColor = [UIColor clearColor];
//        [_cancelBtn setTitleColor:RGBCOLOR(3, 122, 255) forState:UIControlStateNormal];
//        [_cancelBtn addTarget:self action:@selector(pickerPickEnd:) forControlEvents:UIControlEventTouchDown];
//        [toolView addSubview:_cancelBtn];
//        
//        [[UIApplication sharedApplication].keyWindow addSubview:self.clearView];
//        [[UIApplication sharedApplication].keyWindow addSubview:self.areaPicker];
//        [[UIApplication sharedApplication].keyWindow addSubview:toolView];
//        
//        [UIView animateWithDuration:0.2 animations:^{
//            _areaPicker.top = kMainScreenHeight - 180;
//            toolView.top = _areaPicker.top - 30;
//        }];
//    }
//}
//
//#pragma mark - 数据源方法
//#pragma mark 数据行数
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 4;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 55;
//}
//
//#pragma mark 每行显示内容
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
//        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
//    }
//    cell.detailTextLabel.text = nil;
//    switch (indexPath.row) {
//        case 0:
//        {
//            //城市
//            cell.textLabel.text = self.addModel.area.length ? self.addModel.area : @"请选择所在地区";
//            cell.detailTextLabel.text = @"所在地区";
//        }
//            break;
//        case 1:
//        {
//            //地址
//            cell.textLabel.text = self.addModel.address.length ? [NSString stringWithFormat:@"详细地址：%@",self.addModel.address] : @"请输入详细地址";
//        }
//            break;
//        case 2:
//        {
//            //姓名
//            cell.textLabel.text = self.addModel.truename.length ? [NSString stringWithFormat:@"姓名：%@",self.addModel.truename] : @"请输入收货人姓名";
//        }
//            break;
//        case 3:
//        {
//            //联系电话
//            cell.textLabel.text = self.addModel.mobile.length ? [NSString stringWithFormat:@"联系电话：%@",self.addModel.mobile] : @"请输入收货人联系电话";
//        }
//            break;
//        default:
//            break;
//    }
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.row == 0) {
//        if (!self.areaArray) {
//            __weak YHBAddressEditViewController *weakself = self;
//            [self.addManager getAreaListWithSuccess:^(NSMutableArray *areaArray) {
//                weakself.areaArray = areaArray;
//                [weakself.areaPicker reloadAllComponents];
//            } failure:^(NSString *error) {
//                [SVProgressHUD showErrorWithStatus:error cover:YES offsetY:0];
//            }];
//        }
//        [self showAreaPickView];
//    }else{
//        [[CCEditTextView sharedView] showEditTextViewWithTitle:[self titleWithRow:indexPath.row] textfieldText:[self textWithRow:indexPath.row] comfirmBlock:^BOOL(NSString *text) {
//            [self setAddressModelValueWithRow:indexPath.row Text:text];
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            return YES;
//        } cancelBlock:^{
//            
//        }];
//        
//        
//        //        [[CCEditTextView sharedView] showEditTextViewWithTitle:[self titleWithRow:indexPath.row] textfieldText:[self textWithRow:indexPath.row] comfirmBlock:^(NSString *text) {
//        //            [self setAddressModelValueWithRow:indexPath.row Text:text];
//        //            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        //        } cancelBlock:^{
//        //
//        //        }];
//    }
//}
//#pragma mark - 点击保存按钮
//- (void)touchSaveBtn
//{
//    if ([self infoCheck]) {
//        __weak YHBAddressEditViewController *weakself = self;
//        [weakself.addManager addOrEditAddressWithAddModel:self.addModel Token:([YHBUser sharedYHBUser].token?:@"") isNew:self.isNew WithSuccess:^{
//            [SVProgressHUD showSuccessWithStatus:@"更新收货地址成功！" cover:YES offsetY:0];
//            [self.navigationController popViewControllerAnimated:YES];
//            if(_handel) _handel();
//        } failure:^(NSString *error) {
//            [SVProgressHUD showErrorWithStatus:error cover:YES offsetY:0];
//        }];
//    }else{
//        [SVProgressHUD showErrorWithStatus:@"请填写完整信息！" cover:YES offsetY:0];
//    }
//}
//
//- (BOOL)infoCheck
//{
//    if (self.addModel.address.length && self.addModel.truename.length && self.addModel.mobile.length && self.addModel.area.length) {
//        return YES;
//    }else return NO;
//}
//
//- (NSString *)titleWithRow:(NSInteger)row
//{
//    if (row == 1) {
//        return @"请输入详细地址";
//    }else if (row == 2){
//        return @"请输入联系人姓名";
//    }else if (row == 3){
//        return @"请输入联系人电话";
//    }else return @"";
//}
//
//- (void)setAddressModelValueWithRow:(NSInteger)row Text:(NSString *)text
//{
//    if (!self.addModel) {
//        self.addModel = [[YHBAddressModel alloc] init];
//    }
//    if (row == 1) {
//        self.addModel.address = text;
//    }else if (row == 2){
//        self.addModel.truename = text;
//    }else if (row == 3){
//        self.addModel.mobile = text;
//    }
//}
//
//- (NSString *)textWithRow:(NSInteger)row
//{
//    if (row == 0) {
//        return self.addModel.area;
//    }else if (row == 1){
//        return self.addModel.address;
//    }else if(row == 2){
//        return self.addModel.truename;
//    }else if(row == 3){
//        return self.addModel.mobile;
//    }else return nil;
//}
//
//#pragma 地区选择结果更新模型 ui
//- (void)pickedAreaToModelAndUI
//{
//    if (_selProvince && _selCity) {
//        YHBAreaModel *area = self.areaArray[_selProvince-1];
//        YHBCity *city = area.city[_selCity-1];
//        NSString *areaStr = [area.areaname stringByAppendingString:city.areaname];
//        self.addModel.area = areaStr;
//        self.addModel.areaid = city.areaid;
//        
//        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
//}
//
//#pragma mark - pickerView delegate and datasource
//
//- (void)pickerPickEnd:(UIButton *)sender{
//    
//    //HbuAreaListModelAreas *area = self.cityArray[0];
//    [self.clearView removeFromSuperview];
//    //[self.tableView shouldScrolltoPointY:0];
//    if ([_areaPicker superview]) {
//        if (sender.tag != kButtonTag_Cancel) {
//            [self pickedAreaToModelAndUI];
//        }else{
//            _selProvince = 0;
//            _selCity = 0;
//            [_areaPicker selectRow:0 inComponent:0 animated:NO];
//            [_areaPicker selectRow:0 inComponent:1 animated:NO];
//        }
//        [UIView animateWithDuration:0.2 animations:^{
//            _areaPicker.top = kMainScreenHeight;
//            [_areaPicker removeFromSuperview];
//            [sender.superview removeFromSuperview];
//        }];
//    }
//}
//
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
//    return  2;
//}
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
//    
//    if (component == 0) {
//        return self.areaArray.count+1;
//    }else{
//        if (_selProvince > 0) {
//            YHBAreaModel *area = self.areaArray[_selProvince-1];
//            return area.city.count + 1;
//        }else{
//            return 1;
//        }
//    }
//}
//
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
//    return 140;
//    
//}
//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
//    return 30;
//}
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    if (component == 0) {
//        if (row == 0) {
//            return @"请选择省份";
//        }else{
//            YHBAreaModel *model = self.areaArray[row-1];
//            return model.areaname;
//        }
//    }else if(component == 1){
//        if (row) {
//            YHBAreaModel *model = self.areaArray[_selProvince-1];
//            YHBCity *city = model.city[row-1];
//            return city.areaname;
//        }else return @"请选择城市";
//    }
//    return nil;
//}
//
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
//    if (component == 0) {
//        _selProvince = row;
//        [pickerView reloadComponent:1];
//        [pickerView selectRow:0 inComponent:1 animated:YES];
//    }else if(component == 1){
//        _selCity = row;
//    }
//    
//}
//
//- (void)setExtraCellLineHidden: (UITableView *)tableView
//{
//    UIView *view = [UIView new];
//    view.backgroundColor = [UIColor clearColor];
//    [tableView setTableFooterView:view];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
@end
