//
//  WoWPhotoBrowserCell.m
//  WoWPhotoBrowser
//
//  Created by 童小波 on 15/4/20.
//  Copyright (c) 2015年 tongxiaobo. All rights reserved.
//

#import "WoWPhotoBrowserCell.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+Extensions.h"

#define MinZoomScale 1.0
#define MaxZoomScale 2.0
#define WidthOfView self.bounds.size.width
#define HeightOfView self.bounds.size.height

@implementation WoWPhotoBrowserCell

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self setupTap];
    }
    return self;
}

#pragma mark- UIScrollView
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self layoutSubviews];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    _currentScale = scale;
    [self layoutSubviews];
}

#pragma mark - event response
- (void)handleSingleTap:(UITapGestureRecognizer *)tap
{
    if ([_delegate respondsToSelector:@selector(singleTap)]) {
        [_delegate singleTap];
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap
{
    if (_currentScale == MinZoomScale) {
        [_scrollView setZoomScale:MaxZoomScale animated:YES];
    }
    else{
        [_scrollView setZoomScale:MinZoomScale animated:YES];
        _scrollView.contentSize = CGSizeMake(WidthOfView - 4, HeightOfView - 4);
    }
    [self layoutSubviews];
}

#pragma mark - private methods
- (void)setup
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(2, 2, WidthOfView - 4, HeightOfView - 4)];
    _scrollView.bouncesZoom = YES;
    _scrollView.minimumZoomScale = MinZoomScale;
    _scrollView.maximumZoomScale = MaxZoomScale;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(WidthOfView - 4, HeightOfView - 4);
    [self.contentView addSubview:_scrollView];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.center = self.center;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_imageView];
}

- (void)setupTap
{
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self addGestureRecognizer:doubleTap];
    [self addGestureRecognizer:singleTap];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _scrollView.frame = CGRectMake(2, 2, WidthOfView - 4, HeightOfView - 4);
    CGFloat centerX = _scrollView.contentSize.width / 2.0;
    CGFloat centerY = _scrollView.contentSize.height / 2.0;
    if (centerX < (WidthOfView - 4) / 2.0) {
        centerX = (WidthOfView - 4) / 2.0;
    }
    if (centerY < (HeightOfView -4) / 2.0) {
        centerY = (HeightOfView - 4) / 2.0;
    }
    _imageView.center = CGPointMake(centerX, centerY);
}
//恢复原来比例
- (void)recovery
{
    [_scrollView setZoomScale:MinZoomScale animated:YES];
    _scrollView.contentSize = CGSizeMake(WidthOfView - 4, HeightOfView - 4);
    [self layoutSubviews];
}

#pragma mark- getters and setters
- (void)setImageUrl:(NSString *)imageUrl
{
    if (imageUrl == nil) {
        return;
    }
    _imageUrl = imageUrl;
    _currentScale = MinZoomScale;
    _image = nil;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        _image = image;
        CGFloat width = WidthOfView;
        CGFloat height = width / image.size.width * image.size.height;
        _imageView.frame = CGRectMake(0, 0, width, height);
        [self layoutSubviews];
        
    }];
}

- (void)setImage:(UIImage *)image
{
    if (image == nil) {
        return;
    }
    _image = image;
    _imageView.image = _image;
    CGFloat width = WidthOfView;
    CGFloat height = width / image.size.width * image.size.height;
    _imageView.frame = CGRectMake(0, 0, width, height);
    [self layoutSubviews];
}

- (void)setFileUrl:(NSURL *)fileUrl
{
    if (fileUrl == nil) {
        return;
    }
    CGFloat width = WidthOfView;
    __weak UIImageView *weakImageView = _imageView;
    __weak WoWPhotoBrowserCell *weakSelf = self;
    [_imageView setFullScreenWithUrl:fileUrl completed:^(UIImage *image, NSError *error) {
        
        _image = image;
        CGFloat height = width / image.size.width * image.size.height;
        weakImageView.frame = CGRectMake(0, 0, width, height);
        [weakSelf layoutSubviews];
        
    }];
}

@end
