//
//  OfferDetailController.m
//  kuaibu
//
//  Created by zxy on 15/9/12.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "OfferDetailController.h"
#import "YHBRadioBox.h"
#import "MyButton.h"
#import "UIImage+Extensions.h"
#import "SVProgressHUD.h"


#define kLineTag 80

@interface OfferDetailController ()<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    BOOL _isSelect;
    NSInteger _isSpot;
    float _total;
    float _price;
    float _freight;
}
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *offerDetailFormView;

@property (nonatomic,strong) UIImageView *uploadButton;
@property (nonatomic,strong) UITextField *priceTextField;
@property (nonatomic,strong) YHBRadioBox *isPayFor;
@property (nonatomic,strong) UITextField *freightTextField;
@property (nonatomic,strong) UILabel *combinedLabel;
@property (nonatomic,strong) MyButton *spotBtn;
@property (nonatomic,strong) MyButton *reservationBtn;
@property (nonatomic, strong) UITextView *noteEditView;


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
    [self exitAction];
    
}

- (void)back
{
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"确定退出报价吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [view show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
//        NSLog(@"0");
    }else if (buttonIndex == 1){
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 报价详情UI
- (void)setupFormView
{
    UIView *view1 = [self samplePhotoForm:CGRectMake(0, 0, kMainScreenWidth, 100)];
    UIView *view2 = [self priceForm:CGRectMake(0, view1.bottom, kMainScreenWidth, 44)];
    UIView *view3 = [self freightForm:CGRectMake(0, view2.bottom, kMainScreenWidth, view2.height)];
    UIView *view4 = [self combinedForm:CGRectMake(0, view3.bottom, kMainScreenWidth, 60)];
    UIView *view5 = [self SupplyTypeForm:CGRectMake(0, view4.bottom, kMainScreenWidth, 44)];
    UIView *view6 = [self noteDetailForm:CGRectMake(0, view5.bottom, kMainScreenWidth-20, 120)];
    [self.offerDetailFormView addSubview:view1];
    [self.offerDetailFormView addSubview:view2];
    [self.offerDetailFormView addSubview:view3];
    [self.offerDetailFormView addSubview:view4];
    [self.offerDetailFormView addSubview:view5];
    [self.offerDetailFormView addSubview:view6];
    self.offerDetailFormView.frame = CGRectMake(0, 10, kMainScreenWidth, view6.bottom);
}

#pragma mark - 样张UI
- (UIView *)samplePhotoForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 60, 60) title:@"样张 : "];
    [view addSubview:label];
    
    _uploadButton = [[UIImageView alloc] initWithFrame:CGRectMake(label.right + 10, 5, 90, 90)];
    _uploadButton.layer.masksToBounds = YES;
    _uploadButton.layer.borderColor = kNaviTitleColor.CGColor;
    _uploadButton.layer.borderWidth = 1;
    _uploadButton.layer.cornerRadius = 5;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点这上传照片" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(view.right - 100, 70, 80, 30);
    [btn addTarget:self action:@selector(clickUploadBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    [view addSubview:_uploadButton];
    [self addBottomLine:view];
    return view;
}

#pragma mark - 单价UI
- (UIView *)priceForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 70, view.height) title:@"单价 : "];
    self.priceTextField.frame = CGRectMake(label.right,0, 120, view.height);
    
    
//    [self.priceTextField addObserver:self forKeyPath:@"text" options:0 context:nil];

    
    [self.priceTextField addTarget:self  action:@selector(priceTextFieldValueChanged)  forControlEvents:UIControlEventAllEditingEvents];
    
    
    UILabel *label1 = [self formTitleLabel:CGRectMake(_priceTextField.right+5, 0, 70, view.height) title:@"元/单位"];
    [view addSubview:label1];
    [view addSubview:_priceTextField];
    [view addSubview:label];
    [self addBottomLine:view];
    return view;
}


#pragma mark - 运费UI
- (UIView *)freightForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 70, view.height) title:@"运费 : "];
    self.freightTextField.frame = CGRectMake(label.right,0, 120, view.height);
    _freight = [self.freightTextField.text doubleValue];
    [self.freightTextField addTarget:self  action:@selector(freightTextFieldValueChanged)  forControlEvents:UIControlEventAllEditingEvents];
    _isPayFor = [[YHBRadioBox alloc] initWithFrame:CGRectMake(_freightTextField.right+5, 0, 70, view.height) checkedImage:[UIImage imageNamed:@"check_on"] uncheckedImage:[UIImage imageNamed:@"check_off"] title:@"到付"];
    [_isPayFor addTarget:self action:@selector(isPayForDidChanged:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:_isPayFor];
    [view addSubview:_freightTextField];
    [view addSubview:label];
    [self addBottomLine:view];
    return view;
}

#pragma mark - 公开按钮
- (YHBRadioBox *)isPayFor
{
    if (_isPayFor == nil) {
        _isPayFor = [[YHBRadioBox alloc] initWithFrame:CGRectMake(0, 0, 60, 20) checkedImage:[UIImage imageNamed:@"check_on"] uncheckedImage:[UIImage imageNamed:@"check_off"] title:@"到付"];
        [_isPayFor addTarget:self action:@selector(isPayForDidChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _isPayFor;
}




#pragma mark - 合计UI
- (UIView *)combinedForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    _total = _number * _price + _freight;
    NSString *title = [NSString stringWithFormat:@"合计 : %.2f",_total];
    self.combinedLabel.text = title;
    self.combinedLabel = [self formTitleLabel:CGRectMake(10, 0, kMainScreenWidth, 60) title:title];
    self.combinedLabel.textAlignment = NSTextAlignmentCenter;
    self.combinedLabel.font = [UIFont systemFontOfSize:20];
   
    [view addSubview:self.combinedLabel];
    [self addBottomLine:view];
    return view;
}

- (void)priceTextFieldValueChanged{
    _price = [self.priceTextField.text floatValue];
    _total = _number * _price;
    NSString *title = [NSString stringWithFormat:@"合计 : %.2f",_total];
    self.combinedLabel.text = title;
}

- (void)freightTextFieldValueChanged{
    _price = [self.priceTextField.text floatValue];
    _freight = [self.freightTextField.text floatValue];
    _total = (_number * _price) + _freight;
    NSString *title = [NSString stringWithFormat:@"合计 : %.2f",_total];
    self.combinedLabel.text = title;
}

//kvo
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"text"]&& object == self.priceTextField) {
//        _total = _number * _price + _freight;
//        NSString *title = [NSString stringWithFormat:@"合计 : %lf",_total];
//        self.combinedLabel.text = title;
//        NSLog(@"***");
//    }
//}
//
//- (void)dealloc{
//    [_priceTextField removeObserver:self forKeyPath:@"price"];
//}

#pragma mark - 货源状态UI
- (UIView *)SupplyTypeForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 0, 70, view.height) title:@"货源状态 : "];
    
    view.userInteractionEnabled = YES;
    _spotBtn = [[MyButton alloc] initWithFrame:CGRectMake(label.right+10, 3, 60, view.height) imageName:@"check_off" text:@"现货"];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selected1:)];
    [_spotBtn addGestureRecognizer:tap1];
    
    _reservationBtn = [[MyButton alloc] initWithFrame:CGRectMake(_spotBtn.right+20, 3, 60, view.height) imageName:@"check_off" text:@"预定"];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selected2:)];
    [_reservationBtn addGestureRecognizer:tap2];
    [view addSubview:_spotBtn];
    [view addSubview:_reservationBtn];
    [view addSubview:label];
    [self addBottomLine:view];
    return view;
}

#pragma mark - 备注UI
- (UIView *)noteDetailForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    self.noteEditView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0,kMainScreenWidth, 120)];
    self.noteEditView.textColor = [UIColor blackColor];
    self.noteEditView.font = [UIFont systemFontOfSize:18];
    self.noteEditView.backgroundColor = [UIColor whiteColor];
    self.noteEditView.delegate = self;
    self.noteEditView.text = @" 备注：";
    self.noteEditView.returnKeyType = UIReturnKeyDefault;
    self.noteEditView.keyboardType = UIKeyboardTypeDefault;
    self.noteEditView.scrollEnabled = YES;
    self.noteEditView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
   
    [view addSubview:self.noteEditView];
    [self addBottomLine:view];
    return view;
}

#pragma mark - 报价按钮
- (void)exitAction
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, kMainScreenHeight-49, kMainScreenWidth, 49)];
    label.backgroundColor = [UIColor orangeColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"提交报价";
    [self.view addSubview:label];
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
    [label addGestureRecognizer:tap];
}

#pragma mark - 按钮点击响应事件
- (void)clickAction:(UIGestureRecognizer *)tap
{
//    NSLog(@"提交报价");
    NSString *url = nil;
    kYHBRequestUrl(@"procurement/seller/addProcurementPrice", url);
    
    NSDictionary *dic = [self createDictionary];
    
    NSString *str = [self dictionaryToJson:dic];
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@(_offerDetailId),@"procurementId", nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:str,@"procurementPrice", nil];
//     NSLog(@"****%@",dict);
    __weak typeof(self) weakSelf=self;
    [NetworkService postWithURL:url paramters:dict success:^(NSData *receiveData) {
        if(receiveData.length>0)
        {
            id result=[NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
            if([result isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dictionary=result;
                NSString *msg = dictionary[@"RESPMSG"];
                NSString *status = dictionary[@"RESPCODE"];
                
                
                if([status integerValue] == 0)
                {
                    [weakSelf showAlertWithMessage:msg automaticDismiss:YES];
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                }
                else if ([status integerValue] != 0)
                {
                    [weakSelf showAlertWithMessage:msg automaticDismiss:NO];
                }
            }
        }
    } failure:^(NSError *error) {
        [FGGProgressHUD hideLoadingFromView:weakSelf.view];
        [self showAlertWithMessage:error.localizedDescription automaticDismiss:NO];
    }];
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
    
    [dic setObject:@(_offerDetailId) forKey:@"procurementId"];
//    [dic setObject:_uploadButton.image forKey:@"productImage"];
    [dic setObject:_priceTextField.text forKey:@"productPrice"];
    [dic setObject:_freightTextField.text forKey:@"transportPrice"];
    [dic setObject:_freightTextField.text forKey:@"totalPrice"];
    [dic setObject:@(_isSpot) forKey:@"productStatus"];
    [dic setObject:_noteEditView.text forKey:@"remark"];
    return dic;
    
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


- (void)clickUploadBtn
{
//    NSLog(@"上传图片");
    [self showActionSheet];
}



- (void)isPayForDidChanged:(YHBRadioBox *)radioBox
{
    switch (radioBox.tag) {
        case 1001:
            if (_isSelect) {
                //                _cutNo.userInteractionEnabled = YES;
                //                _cutYes.userInteractionEnabled = NO;
                _isSelect = !_isSelect;
            }
            //            NSLog(@"%d",radioBox.tag);
            break;
        case 1002:
            if (_isSelect) {
                //                _cutNo.userInteractionEnabled = YES;
                //                _cutYes.userInteractionEnabled = NO;
                _isSelect = !_isSelect;}
            //            NSLog(@"%d",radioBox.tag);
            break;
        default:
            break;
    }
}


- (void)selected1:(UIGestureRecognizer *)tap
{
//    NSLog(@"asd");
    if (_spotBtn) {
        _isSpot = YES;
        _spotBtn.imageView.image =[UIImage imageNamed:@"check_on"];
        _reservationBtn.imageView.image =[UIImage imageNamed:@"check_off"];
    }
}

- (void)selected2:(UIGestureRecognizer *)tap
{
    if (_reservationBtn) {
        _isSpot = NO;
        _reservationBtn.imageView.image =[UIImage imageNamed:@"check_on"];
        _spotBtn.imageView.image =[UIImage imageNamed:@"check_off"];
    }
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
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadImgWithImage:(UIImage *)image
{
    NSString *uploadPhototUrl = nil;
    kYHBRequestUrl(@"upload.php", uploadPhototUrl);
    self.uploadButton.image = image;
    
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
//        _priceTextField.borderStyle = UITextBorderStyleRoundedRect;
        _priceTextField.returnKeyType = UIReturnKeyDone;
        _priceTextField.placeholder = @"请输入你的单价";
        _priceTextField.delegate = self;
    }
    return _priceTextField;
}

- (UITextField *)freightTextField
{
    if (_freightTextField ==nil) {
        _freightTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _freightTextField.font = [UIFont systemFontOfSize:15.0];
        _freightTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        //        _priceTextField.borderStyle = UITextBorderStyleRoundedRect;
        _freightTextField.returnKeyType = UIReturnKeyDone;
        _freightTextField.placeholder = @"请输入你的运费";
        _freightTextField.delegate = self;
    }
    return _freightTextField;
}

//- (UITextField *)combinedTextfield
//{
//    if (_combinedTextfield ==nil) {
//        _combinedTextfield = [[UITextField alloc] initWithFrame:CGRectZero];
//        _combinedTextfield.font = [UIFont systemFontOfSize:15.0];
//        _combinedTextfield.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//        _combinedTextfield.returnKeyType = UIReturnKeyDone;
//        _combinedTextfield.delegate = self;
//    }
//    return _combinedTextfield;
//}


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
