//
//  MineInfoSetViewController.m
//  YHB_Prj
//
//  Created by 童小波 on 15/6/3.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "MineInfoSetViewController.h"
#import "UIImageView+WebCache.h"
#import "CCEditTextView.h"
#import "UIImage+Extensions.h"
#import "MemberModel.h"
#import "SVProgressHUD.h"
#import "YHBAreaPicker.h"
//#import "CategoryViewController.h"
#import "LSNavigationController.h"
#import "AddressListViewController.h"
//#import "YHBCatSubcate.h"
#import "AddressManager.h"
#import "AddressModel.h"


@interface MineInfoSetViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthOfImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceOfImageViewToScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *cellphoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyName;

@property (nonatomic,strong) NSString *cateID;

@property (assign, nonatomic) CGFloat initialHeight;
@property (assign, nonatomic) BOOL isPortrait;
@property (strong, nonatomic) MemberModel *memberModel;
//@property (strong, nonatomic) YHBUserInfo *userInfo;

@end

@implementation MineInfoSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    [self settitleLabel:@"个人设置"];
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(back)];
    self.companyName.text = @"";
    self.cellphoneTextField.text = @"";
    self.addressTextField.text = @"";
    
    self.widthOfImageView.constant = kMainScreenWidth;
    self.initialHeight = self.heightOfImageView.constant;

    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
//    self.userInfo = [YHBUser sharedYHBUser].userInfo;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_memberModel.picture] placeholderImage:[UIImage imageNamed:@"userBannerDefault"] options:SDWebImageCacheMemoryOnly];
    self.headImageView.layer.cornerRadius = 22.5;
    self.headImageView.layer.masksToBounds = YES;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:_memberModel.picture] placeholderImage:[UIImage imageNamed:@"DefualtUser"] options:SDWebImageCacheMemoryOnly];
    self.companyName.text = self.memberModel.memberName;
    self.cellphoneTextField.text = self.memberModel.memberPhone;
    
//    [SVProgressHUD showWithStatus:@"拼命加载中..." cover:YES offsetY:0];
//    AddressManager *addManager = [[AddressManager alloc] init];
    
//    [addManager getAddresslistWithToken:([YHBUser sharedYHBUser].token ? :@"") WithSuccess:^(NSMutableArray *modelList) {
//        [SVProgressHUD dismiss];
//        
//        for (YHBAddressModel *model in modelList) {
//            if (model.ismain) {
//                _addressTextField.text = model.address;
//                break;
//            }
//        }    } failure:^(NSString *error) {
//        [SVProgressHUD dismissWithError:error];
//    }];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        
        self.verticalSpaceOfImageViewToScrollView.constant = scrollView.contentOffset.y;
        self.heightOfImageView.constant = _initialHeight + fabs(scrollView.contentOffset.y);
        
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 11:
            [self showEditViewWithTitle:@"昵称" attachView:textField];
            break;
        case 12:
            [self showEditViewWithTitle:@"联系电话" attachView:textField];
            break;
        case 13:
            [self showAddressView];
            break;
        default:
            break;
    }
    return NO;
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
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma makr - event response
- (IBAction)modifyPortraitViewDidTap:(id)sender {
    _isPortrait = YES;
    [self showActionSheet];
}

- (IBAction)addButtonClick:(id)sender {
    _isPortrait = NO;
    [self showActionSheet];
}

#pragma mark - private methods
- (void)showEditViewWithTitle:(NSString *)title attachView:(UITextField *)textField
{
    [[CCEditTextView sharedView] showEditTextViewWithTitle:[NSString stringWithFormat:@"编辑%@", title] textfieldText:textField.text comfirmBlock:^BOOL(NSString *text) {
        if (textField.tag == 11){
            
            if (![self checkUserName:text]) {
                [CCEditTextView sharedView].reminderStr = @"只能包含英文、中文、数字，10个字符以内";
                return NO;
            }
        }
        textField.text = text;
        [self syncInfo];
        return YES;
    } cancelBlock:^{
        
    }];
}

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

- (void)showImagePicker:(NSUInteger)sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    imagePickerController.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:imagePickerController.sourceType];
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}

- (void)showAddressView
{
    AddressListViewController *vc = [[AddressListViewController alloc] init];
//    vc.infoSetViewController = self;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//检查是否合法的用户名
- (BOOL)checkUserName:(NSString *)userName
{
    //TODO: 检查用户名合法性
    NSString *usernameRegex = @"[\u4e00-\u9fa5a-zA-Z0-9]{1,10}";
    NSPredicate *usernameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", usernameRegex];
    return [usernameTest evaluateWithObject:userName];
}

- (void)syncInfo
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:9];
//    [dic setObject:[YHBUser sharedYHBUser].token forKey:@"token"];
//
//    if (self.userInfo.company != nil) {
//        [dic setObject:self.userInfo.company forKey:@"company"];
//    }
//    if (self.companyName.text.length) {
//        [dic setObject:self.companyName.text forKey:@"truename"];
//    }
//    if (_cellphoneTextField.text.length) {
//        [dic setObject:_cellphoneTextField.text forKey:@"telephone"];
//    }
//    if (self.cateID.length) {
//        [dic setObject:self.cateID forKey:@"catid"];
//    }
//    if (_addressTextField.text.length) {
//        [dic setObject:_addressTextField.text forKey:@"address"];
//    }
//    
//    MLOG(@"%@",dic);
//    [self.userManager editUserInfoWithInfoDic:dic withSuccess:^{
//        
//        [SVProgressHUD showSuccessWithStatus:@"修改成功!" cover:YES offsetY:0];
//        [YHBUser sharedYHBUser].statusIsChanged = YES;
//        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateUserMessage object:nil];
//    } failure:^(int result, NSString *errorString) {
//        [SVProgressHUD showErrorWithStatus:errorString cover:YES offsetY:0];
//    }];
}

- (void)uploadImgWithImage:(UIImage *)image
{
//    NSString *uploadPhototUrl = nil;
//    kYHBRequestUrl(@"upload.php", uploadPhototUrl);
//    
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                         [YHBUser sharedYHBUser].token, @"token",
//                         _isPortrait ? @"avatar" : @"banner", @"action", nil];
//    
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

- (void)setAddress:(NSString *)address
{
    _addressTextField.text = address;
}

//- (YHBUserManager *)userManager
//{
//    if (_userManager == nil) {
//        _userManager = [[YHBUserManager alloc] init];
//    }
//    return _userManager;
//}

//- (YHBUserInfo *)userInfo
//{
//    return [YHBUser sharedYHBUser].userInfo;
//}

@end
