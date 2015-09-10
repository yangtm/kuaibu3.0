//
//  BannerView.m
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/7.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "BannerView.h"
#import "UIImageView+WebCache.h"

@interface BannerView()

@property (strong, nonatomic) UIPageControl *pageControl; //分页
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *imgArray;
@property (strong, nonatomic) NSMutableArray *imageViewArray;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation BannerView

- (void)dealloc
{
    if (_timer) {
        [self.timer invalidate];
        _timer = nil;
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.isNeedCycle = NO;
        
        //添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled = YES;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width,self.height)];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.hidesForSinglePage = YES;
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
        [_pageControl setPageIndicatorTintColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0]];
        [self addSubview:_pageControl];
        
        _imageViewArray = [NSMutableArray array];
        _duration = 6.0;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    self.pageControl.bounds = CGRectMake(0, 0, 150.0, 50.0);
    self.pageControl.center = CGPointMake(kMainScreenWidth/2, self.height - 10);
    
    for (int i = 0; i < _imageViewArray.count; i++) {
        UIImageView *imageView = _imageViewArray[i];
        imageView.frame = CGRectMake(i * kMainScreenWidth, 0, kMainScreenWidth, self.bounds.size.height);
    }
    
    //设置滚动视图滚动区域
    _scrollView.contentSize = CGSizeMake(kMainScreenWidth * _imageViewArray.count, self.bounds.size.height);
    //设置分页控制器
    _pageControl.numberOfPages = _imgArray.count;
    if (_hidePageControl) {
        _pageControl.hidden = YES;
    }
}

- (void)resetUIWithUrlStrArray:(NSArray *)urlArray
{
    self.imgArray = urlArray;
    //如果需要循环滚动，需要在额外在两边各加一张图片
    int count = (int)_imgArray.count;
    if (self.isNeedCycle) {
        count += 2;
    }
    //在图片视图数组里添加视图
    int i = (int)_imageViewArray.count;
    i = MAX(i, 0);
    for (; i < count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollView addSubview:imageView];
        [_imageViewArray addObject:imageView];
    }
    //给图片视图添加图片
    i = 0;
    if (_isNeedCycle) {
        UIImageView *imageView = [_imageViewArray firstObject];
        NSString *url = [_imgArray lastObject];
        [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
        imageView = [_imageViewArray lastObject];
        url = [_imgArray firstObject];
        [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
        i = 1;
    }
    for (int j = 0; j < _imgArray.count; i++, j++) {
        UIImageView *imageView = _imageViewArray[i];
        NSString *url = _imgArray[j];
        [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    }
    
    [self layoutSubviews];
    //设置循环滚动起始位置
    if (_isNeedCycle && _scrollView.contentOffset.x < kMainScreenWidth) {
        _scrollView.contentOffset = CGPointMake(kMainScreenWidth, 0);
    }
    //是否为自动滚动
    if (self.autoRoll) {
        [self startRoll];
    }
    else{
        [self stopRoll];
    }
}

//开始滚动
- (void)startRoll
{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_duration target:self selector:@selector(timeout:) userInfo:nil repeats:YES];
    }
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_duration]];
}

//停止滚动
- (void)stopRoll
{
    [_timer setFireDate:[NSDate distantFuture]];
}

#pragma mark - event response
- (void)handleTapGesture:(UITapGestureRecognizer *)tap
{
    NSInteger number = self.pageControl.currentPage;
    if (self.imgArray && [self.delegate respondsToSelector:@selector(touchBannerWithNum:)]) {
        [self.delegate touchBannerWithNum:number];
    }
}

- (void)timeout:(NSTimer *)timer
{
    int nextPage = (int)_pageControl.currentPage + 1;
    
    if (_isNeedCycle) {
        nextPage += 1;
    }
    
    [self.scrollView setContentOffset:CGPointMake(kMainScreenWidth * nextPage, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / kMainScreenWidth;
    if (self.isNeedCycle) {
        if (scrollView.contentOffset.x <= 0) {
            _scrollView.contentOffset = CGPointMake(kMainScreenWidth * _imgArray.count, _scrollView.contentOffset.y);
            page = _imgArray.count;
        }
        else if (page == _imgArray.count + 1){
            _scrollView.contentOffset = CGPointMake(kMainScreenWidth, _scrollView.contentOffset.y);
            page = 0;
        }
        else{
            page -= 1;
        }
    }
    self.pageControl.currentPage = page;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_pageControl.currentPage == _imgArray.count - 1 && !self.isNeedCycle) {
        CGFloat offSetX = scrollView.contentOffset.x-kMainScreenWidth*self.pageControl.currentPage;
        if (offSetX > 20.0) {
            if ([self.delegate respondsToSelector:@selector(didScrollOverRight)]) {
                [self.delegate didScrollOverRight];
            }
        }
    }
}

@end
