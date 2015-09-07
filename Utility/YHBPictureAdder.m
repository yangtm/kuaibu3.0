//
//  YHBPictureAdder.m
//  YHB_Prj
//
//  Created by 童小波 on 15/5/15.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "YHBPictureAdder.h"
#import "LSNavigationController.h"
#import "YHBAlbumViewController.h"
#import "UIImage+Extensions.h"
#import "YHBPicture.h"
#import "WoWPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "UIViewAdditions.h"
#import "UIImageView+Extensions.h"

#define WidthOfImageViewUnit 100
#define AddSheetTag          199
#define DelSheetTag          200

@interface YHBPictureAdder()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *additonImageView;
@property (strong, nonatomic) UILabel *additonLabel;
@property (strong, nonatomic) NSMutableArray *imageViewArray;
@property (strong, nonatomic) NSMutableArray *pictureArray;
@property (assign, nonatomic) NSInteger tappedNum;
@property (assign, nonatomic) NSInteger coverNum;
@property (strong, nonatomic) UIImageView *coverImageView;

@end

@implementation YHBPictureAdder

- (instancetype) initWithFrame:(CGRect)frame contentController:(UIViewController *)viewController
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentController = viewController;
        self.maxImageNum = 5;
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.additonImageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat widthOfContentSize = self.bounds.size.width;
    if (self.pictureArray.count == 0 && self.enableEdit) {
        self.additonImageView.center = self.center;
        self.additonImageView.hidden = NO;
        self.additonLabel.text = @"添加图片";
    }
    else if (self.pictureArray.count == 5 || !self.enableEdit){
        self.additonImageView.center = CGPointMake(-WidthOfImageViewUnit / 2.0, 0);
        self.additonImageView.hidden = YES;
        widthOfContentSize = self.pictureArray.count * (WidthOfImageViewUnit + 5) + 5;
    }
    else if (self.enableEdit){
        self.additonImageView.center = CGPointMake(5 + WidthOfImageViewUnit / 2.0, self.center.y);
        self.additonImageView.hidden = NO;
        self.additonLabel.text = @"继续添加";
        widthOfContentSize = (self.pictureArray.count + 1) * (WidthOfImageViewUnit + 5) + 5;
    }
    
    _additonLabel.frame = CGRectMake(0, 60, _additonImageView.width, 20);
    
    int i = 0;
    for (; i < self.pictureArray.count; i++) {
        UIImageView *imageView = [self configImageViewWithIndex:i];
        imageView.center = CGPointMake(_additonImageView.center.x + (WidthOfImageViewUnit + 5) * (i + 1), self.center.y);
        [self.scrollView addSubview:imageView];
        if (i == _coverNum && self.enableEdit) {
            [imageView addSubview:self.coverImageView];
        }
    }
    for (; i < self.imageViewArray.count; i++) {
        UIImageView *imageView = [self imageViewWithNum:i];
        [imageView removeFromSuperview];
    }
    self.scrollView.contentSize = CGSizeMake(widthOfContentSize, self.bounds.size.height);
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == AddSheetTag) {
        if (buttonIndex == 1) {
            [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        else if (buttonIndex == 2){
            [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }
    }
    else if (actionSheet.tag == DelSheetTag){
        if (buttonIndex == 0) {
            [self setCoverImageAtIndex:_tappedNum];
        }
        else if(buttonIndex == 1){
            [self showPhotoBrowser];
        }
        else if (buttonIndex == 2){
            [self deletImageAtIndex:_tappedNum];
        }
        [self layoutSubviews];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        [image saveToAlbum:^(NSURL *assetURL, NSError *error) {
            
            [self insertNewImage:assetURL];
            [self layoutSubviews];
            
        }];
    }
}

#pragma mark - event response
- (void) additionHandler:(UITapGestureRecognizer *)tap
{
    [self showAdditionActionSheet];
}

- (void) eidtImageHnadler:(UITapGestureRecognizer *)tap
{
    UIImageView *imageView = (UIImageView *)tap.view;
    self.tappedNum = imageView.tag;
    if (self.enableEdit) {
        [self showDelAcitonSheet];
    }
    else{
        [self showPhotoBrowser];
    }
}

- (void) imageWasSavedSuccessfully:(UIImage *)paramImage didFinishSavingWithError:(NSError *)paramError contextInfo:(void *)paramContextInfo{
    if (paramError == nil){
        NSLog(@"Image was saved successfully.");
        paramImage = nil;
    } else {
        NSLog(@"An error happened while saving the image.");
        NSLog(@"Error = %@", paramError);
    }
}

#pragma mark - private methods
- (void) showAdditionActionSheet
{
    UIActionSheet *sheet;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", @"拍照", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    sheet.tag = AddSheetTag;
    [sheet showInView:self.contentController.view];
}

- (void) showDelAcitonSheet
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"设为封面" otherButtonTitles: @"查看大图", @"删除照片", nil];
    sheet.tag = DelSheetTag;
    [sheet showInView:self.contentController.view];
}

- (void) showImagePickerWithSourceType:(NSInteger)sourceType
{
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = sourceType;
        imagePickerController.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:imagePickerController.sourceType];
        [self.contentController presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }
    else
    {
        YHBAlbumViewController *albumViewController = [[YHBAlbumViewController alloc] initWithBlock:^(NSArray *aArray) {
            
            [self insertNewImages:aArray];
            [self layoutSubviews];
            
        } andPhotoCount: 5 - (int)_pictureArray.count];
            
        [self.contentController presentViewController:[[LSNavigationController alloc] initWithRootViewController:albumViewController] animated:YES completion:nil];
    }
}

- (void) showPhotoBrowser
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (YHBPicture *model in self.pictureArray) {
        WoWPhoto *photo;
        if (model.type == YHBPictureTypeLocal) {
            photo = [[WoWPhoto alloc] initWithFileUrl:model.localImageUrl];
        }
        else{
            photo = [[WoWPhoto alloc] initWithImageUrl:model.webImage.large];
        }
        [mutableArray addObject:photo];
    }
    
    [WoWPhotoBrowser setPresentController:self.contentController];
    [WoWPhotoBrowser setEnableSave:_enableSaveImage];
    [WoWPhotoBrowser showWithPhotos:mutableArray currentIndex:_tappedNum + 1 showView:nil complete:^(NSInteger showIndex) {
        
    }];
}

- (void) insertNewImage:(NSURL *)imageUrl
{
    YHBPicture *picture = [[YHBPicture alloc] init];
    picture.type = YHBPictureTypeLocal;
    picture.localImageUrl = imageUrl;
    [self.pictureArray addObject:picture];
}

- (void) insertNewImages:(NSArray *)array
{
    for (NSURL *item in array) {
        [self insertNewImage:item];
    }
}

- (void) deletImageAtIndex:(NSInteger)index
{
    self.coverNum = 0;
    [self.pictureArray removeObjectAtIndex:index];
}

- (void) setCoverImageAtIndex:(NSInteger)index
{
    self.coverNum = index;
}

- (UIImageView *) configImageViewWithIndex:(NSInteger)index
{
    UIImageView *imageView = [self imageViewWithNum:index];
    YHBPicture *picture = self.pictureArray[index];
    if (picture.type == YHBPictureTypeLocal) {
        [imageView setThumbImageWithUrl:picture.localImageUrl completed:nil];
    }
    else{
        [imageView sd_setImageWithURL:[NSURL URLWithString:picture.webImage.thumb]];
    }
    return imageView;
}

#pragma mark - setters and getters
- (void)setImageArray:(NSArray *)imageArray
{
    self.pictureArray = [NSMutableArray arrayWithArray:imageArray];
    [self layoutSubviews];
}

- (NSArray *)imageArray
{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:_pictureArray];
    if (_coverNum != 0 && _coverNum < _pictureArray.count) {
        [mutableArray exchangeObjectAtIndex:_coverNum withObjectAtIndex:0];
    }
    return mutableArray;
}

- (NSInteger)imageCount
{
    return _pictureArray.count;
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    }
    return _scrollView;
}

- (UIImageView *)additonImageView
{
    if (_additonImageView == nil) {
        _additonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WidthOfImageViewUnit, WidthOfImageViewUnit)];
        _additonImageView.image = [UIImage imageNamed:@"QSPlusBtn"];
        _additonImageView.layer.cornerRadius = 5.0;
        _additonImageView.layer.masksToBounds = YES;
        _additonImageView.backgroundColor = [UIColor redColor];
        _additonImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(additionHandler:)];
        [_additonImageView addGestureRecognizer:tap];
        _additonLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _additonLabel.text = @"添加照片";
        _additonLabel.textColor = [UIColor whiteColor];
        _additonLabel.font = [UIFont systemFontOfSize:13.0];
        _additonLabel.textAlignment = NSTextAlignmentCenter;
        [_additonImageView addSubview:_additonLabel];
    }
    return _additonImageView;
}

- (NSMutableArray *)pictureArray
{
    if (_pictureArray == nil) {
        _pictureArray = [NSMutableArray array];
    }
    return _pictureArray;
}

- (NSMutableArray *)imageViewArray
{
    if (_imageViewArray == nil) {
        _imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}

- (UIImageView *)imageViewWithNum:(NSInteger)num
{
    if (num >= self.imageViewArray.count) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WidthOfImageViewUnit, WidthOfImageViewUnit)];
        imageView.layer.cornerRadius = 5.0;
        imageView.layer.masksToBounds = YES;
        imageView.userInteractionEnabled = YES;
        imageView.tag = num;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eidtImageHnadler:)];
        [imageView addGestureRecognizer:tap];
        [self.imageViewArray addObject:imageView];
    }
    return self.imageViewArray[num];
}

- (UIImageView *)coverImageView
{
    if (_coverImageView == nil) {
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _coverImageView.image = [UIImage imageNamed:@"coverImage"];
    }
    return _coverImageView;
}

@end
