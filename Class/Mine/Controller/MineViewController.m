//
//  MineViewController.m
//  kuaibu_3.0
//
//  Created by zxy on 15/8/18.
//  Copyright (c) 2015年 zxy. All rights reserved.
//

#import "MineViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "NSString+MD5.h"
#import "SettingViewController.h"
#import "MyheaderCell.h"
#import "FriendsViewController.h"
#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "LoginViewController.h"
#import "HZCookie.h"
#import "MineHeadView.h"
#import "ProcurementListController.h"
#import "FXBlurView.h"
#import "HistoryViewController.h"
#import "UIImage+Extensions.h"

#define WORLD (@"world")

typedef NS_ENUM(NSInteger, MineViewType) {
    MineViewTypeSeller,
    MineViewTypeBuyller
};

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,MyheaderCellDelagate,UIActionSheetDelegate,MineHeadViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UITableView *buyerView;
@property (nonatomic,strong) UITableView *sellerView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIButton *messageBtn;
@property (nonatomic,strong) MineHeadView *myView;
@property (strong, nonatomic) FXBlurView *blurView;
@property (assign, nonatomic) BOOL isBlur;
@property (assign, nonatomic) TradingRole role;
@property (assign, nonatomic) MineViewType type;
@property (strong, nonatomic) MineHeadView *headView;
@property (strong,nonatomic) UIImage *photo;
@end


@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.blurView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
//    [self.view addSubview:self.blurView];
    self.blurView.hidden = YES;
    
    if (_type == MineViewTypeBuyller) {
        _headView.numOfOrderArray = @[@"1", @"2", @"3", @"4"];
    }
    [self settitleLabel:@"用户中心"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(setLogin)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.messageBtn];
    self.view.backgroundColor = kViewBackgroundColor;
    [self prepareData];
    [self createTabelView];
    NSString *str = [[NSUserDefaults standardUserDefaults]stringForKey:@"photo"];
    _photo = [UIImage imageNamed:str];
}

//- (UIButton *)navBarMessageButton
//{
//    if (_messageBtn == nil) {
//        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _messageBtn.frame = CGRectMake(0, 0, 20, 25);
//        [_messageBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
//        _messageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [_messageBtn addTarget:self action:@selector(messageButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _messageBtn;
//}



#pragma mark -按钮响应事件
- (void)setLogin
{
    SettingViewController *vc = [[SettingViewController alloc] init];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:^{
        
    }];
}

//- (void)messageButtonClick
//{
//    self.tabBarController.selectedIndex = 3;
//}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10) {
        if (buttonIndex == 1) {
            
            NSString *url = nil;
            kYHBRequestUrl(@"member/outlogin", url);
            __weak typeof(self) weakSelf=self;
            [NetworkService postWithURL:url paramters:nil success:^(NSData *receiveData) {
                
                id result = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
                if ([result isKindOfClass:[NSDictionary class]]) {
                    if ([result[@"RESPCODE"] integerValue] == 0) {
                        [weakSelf showAlertWithMessage:result[@"RESPMSG"] automaticDismiss:YES];
                        [HZCookie removeCookie];
                        [HZCookie setCookie];
                        self.tabBarController.selectedIndex = 0;
                        
                        LoginViewController *vc = [[LoginViewController alloc] init];
                        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
                        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"password"];
                        [self presentViewController:navi animated:YES completion:^{
                            
                        }];
                    }
                }
                
            } failure:^(NSError *error) {
                self.tabBarController.selectedIndex = 0;
            }];
        }
    }
}

#pragma mark - 数据源
- (void)prepareData
{
    self.dataArray = [[NSMutableArray alloc] init];
    NSDictionary *dic = @{WORLD:@[@"采购报价",@"我的收藏",@"最近访问",@"购物车",@"收货地址"]};
    [_dataArray addObject:dic];
}

#pragma mark - UI
- (void)createTabelView
{
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth)];
//    [self.view addSubview:view];
    self.buyerView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) style:UITableViewStylePlain];
    self.buyerView.delegate = self;
    self.buyerView.dataSource = self;
    self.buyerView.backgroundColor = kViewBackgroundColor;
    self.buyerView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.buyerView];
}


#pragma mark - UITableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = -1;
    if (section == 0) {
        number = 1;
    }else if (section == 1){
        number = 2;
    }else if (section == 2){
        number = 5;
    }else if (section == 3){
        number = 1;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
//        cell.backgroundColor = kBackgroundColor;
        static NSString *myheaderId = @"myheaderId";
        MyheaderCell *cell = [tableView dequeueReusableCellWithIdentifier:myheaderId];
        if (!cell) {
            cell = [[MyheaderCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:myheaderId];
            cell.delegate = self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone; 
        return cell;
    }else if (indexPath.section == 1){
        static NSString *orderCellid = @"orderCellid";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellid];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:orderCellid];
        }
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"全部订单";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 1){
            _myView = [[MineHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60) type:MineHeadViewTypeBuyer];
            _myView.delegate = self;
//            _myView.backgroundColor = [UIColor redColor];
            [cell addSubview:_myView];
        }
        return cell;
        
    }else if (indexPath.section == 2){
        static NSString *cellid = @"cellid";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
        }
        
        NSDictionary *subDic = _dataArray[indexPath.section-2];
        NSArray *worldArray = subDic[WORLD];
        cell.textLabel.text = worldArray[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        
    }else if (indexPath.section == 3){
        static NSString *cellid = @"cellid";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
        }
        
        cell.textLabel.text = @"我是卖家";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    //    cell.backgroundColor = [UIColor clearColor];
    return nil;
}

#pragma mark - private methods

- (FXBlurView *)blurView
{
    if (_blurView == nil) {
        _blurView = [[FXBlurView alloc] initWithFrame:CGRectZero];
        _blurView.dynamic = NO;
        _blurView.blurEnabled = YES;
        _blurView.blurRadius = 10.0;
        _blurView.tintColor = [UIColor clearColor];
    }
    return _blurView;
}
- (void)setIsBlur:(BOOL)isBlur
{
    _isBlur = isBlur;
    [self.view bringSubviewToFront:self.blurView];
    self.blurView.hidden = !_isBlur;
    [self.blurView setNeedsDisplay];
}


- (void)transitionShowView
{
    UITableView *frontView = (_role == Buyer ? _buyerView : _sellerView);
    UITableView *backView = (_role == Buyer ? _sellerView : _buyerView);
    
    backView.layer.transform = CATransform3DScale(backView.layer.transform, 2.0, 2.0, 1);
    self.isBlur = YES;
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        backView.layer.transform = CATransform3DIdentity;
        frontView.layer.transform = CATransform3DTranslate(frontView.layer.transform, 0, kMainScreenHeight, 0);
        
    } completion:^(BOOL finished) {
        
        frontView.layer.transform = CATransform3DIdentity;
        self.isBlur = NO;
        [self.view bringSubviewToFront:backView];
        
        if (_role == Buyer) {
            _role = Seller;
        }
        else{
            _role = Buyer;
        }
        
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else if (section == 1){
        return 5;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger number = -1;
    if (indexPath.section == 0) {
        number = 100;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            number = 40;
        }else if (indexPath.row == 1){
            number = 60;
        }
    }else if (indexPath.section == 2){
        number = 44;
    }else if (indexPath.section == 3){
        number = 44;
    }
    return number;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            ProcurementListController *vc = [[ProcurementListController alloc] init];
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:^{
                
            }];

        }else if (indexPath.row == 2){
            HistoryViewController *vc = [[HistoryViewController alloc] init];
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:^{
                
            }];
        }
    }else if (indexPath.section == 3){
//        [self transitionShowView];
    }
}


#pragma mark - HeaderSectionCellDelagate
- (void)clickMessageImageView:(MyheaderCell *)cell
{
    self.tabBarController.selectedIndex = 3;
}

-(void)clickPortraitImageView:(MyheaderCell *)cell
{
    NSLog(@"上传头像");
    cell.tag = 10;
    cell.portraitImageView.image = _photo;
    
    
    [self showActionSheet];

    NSLog(@"%@",_photo);
}

#pragma mark - 显示ActionSheet
- (void)showActionSheet
{
    UIActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", @"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                return;
            case 1: //相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 2: //相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
        }
    }
    else {
        if (buttonIndex == 0) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }
    [self showImagePicker:sourceType];
}

- (void)showImagePicker:(NSUInteger)sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    imagePickerController.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:imagePickerController.sourceType];
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImage * oriImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        [oriImage saveToAlbum:^(NSURL *assetURL, NSError *error) {
            
        }];
    }
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self uploadImgWithImage:image];
    NSLog(@"image:%@",image);
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadImgWithImage:(UIImage *)image
{
    NSString *uploadPhototUrl = nil;
    kYHBRequestUrl(@"upload.php", uploadPhototUrl);
    _photo = image;
//    NSData *data;
//    _photo = [UIImage imageWithData:data];
//    [[NSUserDefaults standardUserDefaults]setObject:_photo forKey:@"photo"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"_photo:%@",_photo);
//    self.uploadButton.image = image;

    //    [SVProgressHUD showWithStatus:@"上传中..." cover:YES offsetY:0];
    //    [NetManager uploadImg:image parameters:dic uploadUrl:uploadPhototUrl uploadimgName:(_isPortrait ? @"avatar" : @"banner") parameEncoding:AFJSONParameterEncoding progressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
    //
    //    } succ:^(NSDictionary *successDict) {
    //        MLOG(@"%@", successDict);
    //        if ([successDict[@"result"] integerValue] == 1) {
    //            [SVProgressHUD dismissWithSuccess:@"上传成功"];
    //            if (!_isPortrait) {
    //                self.imageView.image = image;
    //            }else{
    //                self.headImageView.image = image;
    //            }
    //            [YHBUser sharedYHBUser].statusIsChanged = YES;
    //            [[SDWebImageManager sharedManager].imageCache removeImageForKey:(!_isPortrait ? [YHBUser sharedYHBUser].userInfo.thumb:[YHBUser sharedYHBUser].userInfo.avatar)];
    //        }else{
    //            [SVProgressHUD dismissWithError:kErrorStr];
    //        }
    //
    //    } failure:^(NSDictionary *failDict, NSError *error) {
    //        [SVProgressHUD dismissWithError:kNoNet];
    //    }];
}


-(void)clickSettingBtn:(MyheaderCell *)cell
{
    NSLog(@"设置");
    SettingViewController *vc = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - MineHeadViewDelegate
- (void)mineHeadViewButtonDidTap:(MineHeadView *)headView buttonNum:(NSInteger)num
{
    OrderType type;
    if (_role == Seller) {
        switch (num) {
            case 0:
                type = OrderTypeWatiPay;
                break;
            case 1:
                type = OrderTypePaied;
                break;
            case 2:
                type = OrderTypeDelivered;
                break;
            case 3:
                type = OrderTypeRefunding;
                break;
                
            default:
                break;
        }
    }
    else{
        switch (num) {
            case 0:
                type = OrderTypeWatiPay;
                break;
            case 1:
                type = OrderTypePaied;
                break;
            case 2:
                type = OrderTypeDelivered;
                break;
            case 3:
                type = OrderTypeRefunding;
                break;
                
            default:
                break;
        }
    }
    NSLog(@"%ld",type);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

@end
