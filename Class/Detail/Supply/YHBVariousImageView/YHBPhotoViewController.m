//
//  YHBPhotoViewController.m
//  TestButton
//
//  Created by Johnny's on 14/11/17.
//  Copyright (c) 2014年 Johnny's. All rights reserved.
//

#import "YHBPhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "YHBPhotoTableViewCell.h"
#import "YHBPhotoImageView.h"
#define kMainScreenHeight [UIScreen mainScreen].bounds.size.height
#define kMainScreenWidth  [UIScreen mainScreen].bounds.size.width
@interface YHBPhotoViewController ()<UITableViewDataSource, UITableViewDelegate, YHBPhotoCellDelegate>
{
    NSArray *temPhotoArray;
    UIActivityIndicatorView *activityView;
}
@property(nonatomic, strong) void(^ myBlock)(NSArray *array);
@property(nonatomic, assign) int photoCount;

@property(nonatomic, strong) NSMutableDictionary *photoDictionary;
@property(nonatomic, assign) int currentSelectCount;
@property(nonatomic, strong) NSString *myTitle;
@property(nonatomic, assign) CGFloat interval;
@property(nonatomic, assign) CGFloat photoHeight;
@property(nonatomic, strong) NSArray *photoArray;
@property(nonatomic, strong) UITableView *showPhotoTableView;
@end

@implementation YHBPhotoViewController

- (instancetype)initWithPhotoArray:(NSArray *)aPhotoArray andTitle:(NSString *)aTitle andBlock:(void(^)(NSArray *aArray))aBlock andPhotoCount:(int)aPhotoCount
{
    if (self = [super init]) {
        temPhotoArray = aPhotoArray;
        self.myTitle = aTitle;
        self.title = aTitle;
        self.myBlock = aBlock;
        self.photoCount = aPhotoCount;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _interval = 9/3;
    _photoHeight = (kMainScreenWidth-9)/4;
    _currentSelectCount = 0;
    _photoDictionary = [NSMutableDictionary new];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    
    self.showPhotoTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.showPhotoTableView.delegate = self;
    self.showPhotoTableView.dataSource = self;
    self.showPhotoTableView.tableFooterView = [UIView new];
    self.showPhotoTableView.allowsSelection = NO;
    self.showPhotoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.showPhotoTableView];
    
    activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(kMainScreenWidth/2-20, kMainScreenHeight/2-20, 40, 40)];
    activityView.color = [UIColor blackColor];
    [activityView startAnimating];
    [self.view addSubview:activityView];
    
    [self performSelector:@selector(reloadTableView) withObject:nil afterDelay:0.1];
}

- (void)reloadTableView
{
    self.photoArray = temPhotoArray;
    [self.showPhotoTableView reloadData];
    [activityView stopAnimating];
    CGFloat height = (self.photoArray.count%4==0?self.photoArray.count/4:self.photoArray.count/4+1)*(_photoHeight+_interval);
    CGFloat offY = 0;
    if (height>kMainScreenHeight)
    {
        offY = height-kMainScreenHeight;
        self.showPhotoTableView.contentOffset = CGPointMake(0, offY);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photoArray.count%4==0?self.photoArray.count/4:self.photoArray.count/4+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _photoHeight+_interval;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHBPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[YHBPhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.delegate = self;
    }
    cell.row = (int)indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imgcount = 0;
    for (int i=0; i<4; i++)
    {
        YHBPhotoImageView *photoImageView = (YHBPhotoImageView *)[cell viewWithTag:i+1];
        photoImageView.isSelected = NO;

        if (i<self.photoArray.count-indexPath.row*4)
        {
            ALAsset *asset = [self.photoArray objectAtIndex:indexPath.row*4+i];
            CGImageRef cgImage = [asset thumbnail];
            UIImage *image = [UIImage imageWithCGImage:cgImage];
            [photoImageView setImage:image];
            cell.imgcount++;
        }
        else
        {
            [photoImageView setImage:[UIImage imageNamed:@""]];
        }
        NSArray *keyArray = [_photoDictionary allKeys];
        for (int j=0; j<keyArray.count; j++)
        {
            NSString *temKey = [keyArray objectAtIndex:j];
            if (indexPath.row*4+i==[temKey intValue])
            {
                YHBPhotoImageView *photoImageView = (YHBPhotoImageView *)[cell viewWithTag:i+1];
                photoImageView.isSelected = YES;
            }
        }
        
    }
    
    return cell;
}

- (void)selectCellWithRow:(int)aRow index:(int)aIndex andCell:(YHBPhotoTableViewCell *)aCell
{
    MLOG(@"%d, %d, %d", aRow, aIndex, aCell.imgcount);
    if (aIndex<aCell.imgcount)
    {
        YHBPhotoImageView *temImgView = (YHBPhotoImageView *)[aCell viewWithTag:aIndex+1];
        if (temImgView.isSelected==NO && _currentSelectCount<_photoCount)
        {
            [temImgView changeSelected];
            _currentSelectCount++;
            int index = aRow*4+aIndex;
            ALAsset *asset = [self.photoArray objectAtIndex:index];
            NSURL *url = [asset valueForProperty:ALAssetPropertyAssetURL];
            
//            CGImageRef cgImage = [[asset defaultRepresentation] fullScreenImage];
//            UIImage *image = [UIImage imageWithCGImage:cgImage];
//            
//            CGRect oldRect = CGRectMake(0, 0, image.size.width, image.size.height);
//            CGRect rect =  CGRectMake(0, 0, 1080, oldRect.size.height * 1080.0f/ oldRect.size.width);
//            UIGraphicsBeginImageContext( rect.size );
//            [image drawInRect:rect];
//            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
            
            [_photoDictionary setObject:url forKey:[NSString stringWithFormat:@"%d", index]];
        }
        else if(temImgView.isSelected==YES)
        {
            [temImgView changeSelected];
            _currentSelectCount--;
            int index = aRow*4+aIndex;
            [_photoDictionary removeObjectForKey:[NSString stringWithFormat:@"%d", index]];
        }
        [self setTitle];
    }
}

- (void)done
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.myBlock([_photoDictionary allValues]);
    }];
}

- (void)setTitle
{
    if (_currentSelectCount==0)
    {
        self.title = _myTitle;
    }
    else
    {
        self.title = [NSString stringWithFormat:@"已选中 %d 张照片", _currentSelectCount];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
