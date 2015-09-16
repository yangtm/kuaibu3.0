//
//  LookSupplyViewController.m
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/15.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "LookSupplyViewController.h"
#import "SVPullToRefresh.h"
#import "YHBSegmentView.h"
#import "Public.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "LookBuyAllShowCell.h"
#define topViewHeight 40

@interface LookSupplyViewController ()<UIScrollViewDelegate,AVAudioPlayerDelegate,UITableViewDataSource, UITableViewDelegate>
{
    BOOL _isVip;
    int  _typeid;
}
@property(nonatomic, strong) UIButton *selectAllBtn;
@property(nonatomic, strong) UIButton *selectVipBtn;

@property (nonatomic, strong) YHBSegmentView *segmentView;
@property (nonatomic, strong) UITableView *supplyTableView;

//@property (nonatomic, strong) YHBLookBuyManage *buyManage;
//@property (nonatomic, strong) YHBSupplyDataSource *dataSource;
@property (nonatomic, strong) NSMutableArray *tableViewArray;
@property (nonatomic, assign) NSInteger pageId;

@property (nonatomic, strong) NSArray *catIds;
@property (nonatomic, assign) BOOL isAll;
@property (nonatomic, strong) NSIndexPath *playSoundIndexPath;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) UIButton *scrollToTopButton;
@end

@implementation LookSupplyViewController

- (instancetype)initWithIsSupply:(BOOL)aIsSupply
{
    if (self = [super init]) {
        _typeid = 0;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    _isVip = NO;
    
    self.title =@"查看采购";
    //[self setRightButton:nil title:@"筛选" target:self action:@selector(rightBarButtonClick:)];
    
    self.supplyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    if (app.isLoginedIn) {
        self.supplyTableView.tableHeaderView = self.segmentView;
    }
    
    self.supplyTableView.delegate = self;
    self.supplyTableView.dataSource = self;
    self.supplyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.supplyTableView];
    
    _isAll = YES;
    
    //[self addTableViewTrag];
    //[self showFlower];
    //[self getData];
    [self addScrollToTopButton];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"查看采购"];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self dismissFlower];
    
    [self stopPlaySound];
    
    [MobClick endLogPageView:@"查看采购"];
   
    [self removeScrollToTopButton];
}
#pragma mark - setters and getters
- (YHBSegmentView *)segmentView
{
    if (_segmentView == nil) {
        YHBSegmentViewStyle style;
        NSArray *titleArray;
        CGRect rect;
            style = YHBSegmentViewStyleArrow;
            titleArray = @[@"全部采购", @"我的关注"];
            rect = CGRectMake(0, 0, kMainScreenWidth, 25);
        _segmentView = [[YHBSegmentView alloc] initWithFrame:rect style:style];
        _segmentView.titleArray = titleArray;
        [_segmentView addTarget:self action:@selector(segmentViewDidValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentView;
}

- (void)segmentViewDidValueChanged:(YHBSegmentView *)sender
{
    _typeid = (int)sender.selectItem;
        if (sender.selectItem == 0) {
            _isAll = YES;
            [self setRightButtonActive];
        }
        else if (sender.selectItem == 1){
            [self setRightButtonUnAcitve];
            [self stopPlaySound];
            _isAll = NO;
        }
    [self showFlower];
   // [self getData];
}

- (void)setRightButtonUnAcitve
{
    [self.rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.rightButton.userInteractionEnabled = NO;
}

- (void)setRightButtonActive
{
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.rightButton.userInteractionEnabled = YES;
}

-(void)removeScrollToTopButton
{
    [_scrollToTopButton removeFromSuperview];
    _scrollToTopButton = nil;
}

- (void)stopPlaySound
{
    if (_isPlaying) {
        [_audioPlayer stop];
        LookBuyAllShowCell *cell = (LookBuyAllShowCell *)[_supplyTableView cellForRowAtIndexPath:_playSoundIndexPath];
        //cell.isPlay = NO;
        _isPlaying = NO;
        _playSoundIndexPath = nil;
    }
}

- (void)showFlower
{
    [SVProgressHUD show:YES offsetY:kMainScreenHeight/2.0];
}

- (void)dismissFlower
{
    [SVProgressHUD dismiss];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= 300.f) {
        _scrollToTopButton.hidden = NO;
    }
    else{
        _scrollToTopButton.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isAll){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else{
        LookBuyAllShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        if (cell == nil) {
            cell = [[LookBuyAllShowCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)addScrollToTopButton
{
    _scrollToTopButton = [[UIButton alloc] initWithFrame:CGRectMake(self.navigationController.view.frame.size.width - 50 - 20, self.navigationController.view.frame.size.height - 50 - 30, 50, 50)];
    [_scrollToTopButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [_scrollToTopButton addTarget:self action:@selector(scrollToTop) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:_scrollToTopButton];
    _scrollToTopButton.hidden = YES;
}

-(void)scrollToTop
{
    if (self.supplyTableView.contentSize.height <= self.supplyTableView.frame.size.height)
    {
        return;
    }
    else
    {
        [self.supplyTableView setContentOffset:CGPointZero animated:YES];
    }
}


@end