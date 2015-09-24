//
//  SellerOffManagerController.m
//  kuaibu
//
//  Created by zxy on 15/9/23.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "SellerOffManagerController.h"
#import "YHBSegmentView.h"
#import "AlreadyOfferCell.h"

@interface SellerOffManagerController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _typeid;
}

@property (nonatomic, strong) YHBSegmentView *segmentView;
@property (nonatomic, strong) UITableView *sellerTableView;
@property (nonatomic, strong) UIButton *scrollToTopButton;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SellerOffManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    _typeid = 0;
    self.title =@"我的报价";
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(backAction)];
    [self prepareData];
    [self createSellerTabelView];
    

    
}

- (void)prepareData
{
    if (self.dataArray == nil) {
        self.dataArray = [NSMutableArray array];
    }
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getData
{
    
}

#pragma mark - tableview
- (void)createSellerTabelView
{
    self.sellerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    if (app.isLoginedIn) {
        self.sellerTableView.tableHeaderView = self.segmentView;
    }
    
    self.sellerTableView.delegate = self;
    self.sellerTableView.dataSource = self;
//    self.sellerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.sellerTableView];
}

#pragma mark - UITableView代理
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
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_typeid == 0) {
        static NSString *cellid = @"AlreadyOfferCellid";
        AlreadyOfferCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"AlreadyOfferCell" owner:nil options:nil]lastObject];
        }
        return cell;
    }else {
        static NSString *cellid = @"cellid";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        return cell;
    }
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setters and getters
- (YHBSegmentView *)segmentView
{
    if (_segmentView == nil) {
        YHBSegmentViewStyle style;
        NSArray *titleArray;
        CGRect rect;
        style = YHBSegmentViewStyleBottomLine;
        titleArray = @[@"已报价", @"已采纳"];
        rect = CGRectMake(0, 0, kMainScreenWidth, 30);
        _segmentView = [[YHBSegmentView alloc] initWithFrame:rect style:style];
        _segmentView.titleArray = titleArray;
        [_segmentView addTarget:self action:@selector(segmentViewDidValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentView;
}

- (void)segmentViewDidValueChanged:(YHBSegmentView *)sender
{
    _typeid = (int)sender.selectItem;
    NSLog(@"%d",_typeid);
    if (sender.selectItem == 0) {
//        _isAll = YES;
       
    }
    else if (sender.selectItem == 1){
      
//        [self stopPlaySound];
//        _isAll = NO;
    }
//    [self showFlower];
//    [self getData];
}

#pragma mark - 返回顶部
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
    if (self.sellerTableView.contentSize.height <= self.sellerTableView.frame.size.height)
    {
        return;
    }
    else
    {
        [self.sellerTableView setContentOffset:CGPointZero animated:YES];
    }
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
@end
