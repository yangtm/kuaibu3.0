//
//  WoWPhotoBrowser.m
//  WoWPhotoBrowser
//
//  Created by 童小波 on 15/4/17.
//  Copyright (c) 2015年 tongxiaobo. All rights reserved.
//

#import "WoWPhotoBrowser.h"
#import "AppDelegate.h"
#import "WoWPhotoBrowserCell.h"
#import "SVProgressHUD.h"

#define PhotoBrowserCellID @"PhotoBrowserCellID"
#define Width  self.view.bounds.size.width
#define Height self.view.bounds.size.height

static WoWPhotoBrowser *photoBrowserViewController;

@interface WoWPhotoBrowser ()<UICollectionViewDataSource, UICollectionViewDelegate, WoWPhotoBrowserCellDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UILabel *progressLabel;
@property (strong, nonatomic) UIButton *saveButton;
@property (assign, nonatomic) NSInteger totalPage;
@property (strong, nonatomic) UIViewController *presentController;

@end

@implementation WoWPhotoBrowser

+ (void)showWithPhotos:(NSArray *)photos
          currentIndex:(NSInteger)index
              showView:(UIView *)view
              complete:(void(^)(NSInteger showIndex))cBlock
{
    if (photoBrowserViewController == nil) {
        photoBrowserViewController = [[WoWPhotoBrowser alloc] init];
    }
    photoBrowserViewController.photoArray = photos;
    photoBrowserViewController.currentPage = index;
    photoBrowserViewController.cBlock = cBlock;
    
    UIViewController *viewController = photoBrowserViewController.presentController;
    if (viewController == nil) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        viewController = appDelegate.window.rootViewController;
    }
    [viewController presentViewController:photoBrowserViewController animated:NO completion:^{
        
    }];

}

+ (void)setPresentController:(UIViewController *)presentController
{
    if (photoBrowserViewController == nil) {
        photoBrowserViewController = [[WoWPhotoBrowser alloc] init];
    }
    photoBrowserViewController.presentController = presentController;
}

+ (void)setEnableSave:(BOOL)enable
{
    if (photoBrowserViewController == nil) {
        photoBrowserViewController = [[WoWPhotoBrowser alloc] init];
    }
    photoBrowserViewController.enableSave = enable;
}

+ (void)dismiss
{
    if (photoBrowserViewController != nil) {
        [photoBrowserViewController dismissViewControllerAnimated:NO completion:^{
            photoBrowserViewController = nil;
        }];
    }
}

- (void)dealloc
{
    NSLog(@"WoWPhotoBrowserViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.progressLabel];
    [self.view addSubview:self.saveButton];
    
    self.saveButton.hidden = !self.enableSave;
    self.totalPage = self.photoArray.count;
    self.currentPage = _currentPage;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentPage - 1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UICollectioinView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WoWPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoBrowserCellID forIndexPath:indexPath];
    [self configCell:cell withIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    WoWPhotoBrowserCell *browserCell = (WoWPhotoBrowserCell *)cell;
    //图片消失时还原为原来的比例
    [browserCell recovery];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //设置当前显示图片序号
    NSInteger page = scrollView.contentOffset.x / (Width - 4) + 1;
    if (page <= 0) {
        page = 1;
    }
    self.currentPage = page;
}

#pragma mark - WoWPhotoBrowserCellDelegate
- (void)singleTap
{
    _cBlock(_currentPage);
    [WoWPhotoBrowser dismiss];
}

#pragma mark - events response
- (void)saveButtonClick:(UIButton *)sender
{
    UIImage *image = [self imageAtIndex:_currentPage];
    if (image != nil) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    else{
        [SVProgressHUD showErrorWithStatus:@"保存出错!" cover:YES offsetY:Height];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error != nil) {
        [SVProgressHUD showErrorWithStatus:@"保存出错!" cover:YES offsetY:Height];
    }
    else{
        [SVProgressHUD showSuccessWithStatus:@"保存成功!" cover:YES offsetY:Height / 2.0];
    }
}

#pragma mark - private methods
- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    _progressLabel.text = [NSString stringWithFormat:@"%d/%d", (int)_currentPage, (int)_totalPage];
}

- (UIImage *)imageAtIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index-1 inSection:0];
    WoWPhotoBrowserCell *cell = (WoWPhotoBrowserCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    return cell.image;
}

- (void)configCell:(WoWPhotoBrowserCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    WoWPhoto *photo = self.photoArray[indexPath.row];
    if ([photo isKindOfClass:[WoWPhoto class]]) {
        cell.imageUrl = photo.imageUrl;
//        cell.image = photo.image;
        cell.fileUrl = photo.fileUrl;
    }
    cell.delegate = self;
}

#pragma mark - getters and setters
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[WoWPhotoBrowserCell class] forCellWithReuseIdentifier:PhotoBrowserCellID];
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

- (UILabel *)progressLabel
{
    if (_progressLabel == nil) {
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 26)];
        _progressLabel.center = CGPointMake(Width / 2.0, 40.0);
        _progressLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
        _progressLabel.layer.cornerRadius = 13.0;
        _progressLabel.layer.masksToBounds = YES;
        _progressLabel.textColor = [UIColor whiteColor];
        _progressLabel.font = [UIFont systemFontOfSize:18.0];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _progressLabel;
}

- (UIButton *)saveButton
{
    if (_saveButton == nil) {
        CGFloat x = 20;
        CGFloat y = Height - 40;
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.frame = CGRectMake(x, y, 50, 30);
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_saveButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
        _saveButton.layer.cornerRadius = 2.0;
        _saveButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _saveButton.layer.borderWidth = 0.2;
        [_saveButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

- (void)setEnableSave:(BOOL)enableSave
{
    _enableSave = enableSave;
    _saveButton.hidden = !_enableSave;
}

@end
