//
//  SellerOffManagerController.m
//  kuaibu
//
//  Created by zxy on 15/9/23.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "SellerOffManagerController.h"
#import "YHBSegmentView.h"
#import "SellerOffCell.h"

@interface SellerOffManagerController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    NSInteger _typeid;
    NSInteger _sellerOffPage;
    NSInteger _MAX;
}

@property (nonatomic, strong) YHBSegmentView *segmentView;
@property (nonatomic, strong) UITableView *sellerTableView;
@property (nonatomic, strong) UIButton *scrollToTopButton;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SellerOffManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    _typeid = 1;
    _sellerOffPage = 1;
    self.title =@"我的报价";
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(backAction)];
    [self prepareData];
    [self createSellerTabelView];
    [self showFlower];
    [self getData];
    [self addScrollToTopButton];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self removeScrollToTopButton];
    [self dismissFlower];
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
    _isLoading = YES;
    NSString *url = nil;
    kYHBRequestUrl(@"procurement/seller/ProcurementPrice", url);
    NSLog(@"%@",url);
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@(_sellerOffPage),@"pageIndex",@(_typeid),@"state", nil];
    __weak SellerOffManagerController *weakSelf = self;
    [NetworkService postWithURL:url paramters:dic success:^(NSData *receiveData) {
        if (_sellerOffPage == 1) {
            [_dataArray removeAllObjects];
        }
        
        id result = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"result::%@",result);
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSArray *array = result[@"RESULT"];
            _MAX = [result[@"RESPCODE"]integerValue];
            for (NSDictionary *dic in array) {
                NSDictionary *subDic = dic[@"procurement"];
                ProcurementModel *model = [[ProcurementModel alloc] init];
                [model setValuesForKeysWithDictionary:subDic];
                [_dataArray addObject:model];
            }
            [weakSelf.sellerTableView reloadData];
        }
        _isLoading = NO;
        [_headerView endRefreshing];
        [_footerView endRefreshing];
        [self dismissFlower];
        
    } failure:^(NSError *error) {
        [self dismissFlower];
        _isLoading = NO;
    }];
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
    self.sellerTableView.tableFooterView = [[UIView alloc] init];
    
    //下拉刷新，上拉加载
    _headerView = [MJRefreshHeaderView header];
    _headerView.delegate = self;
    _headerView.scrollView = self.sellerTableView;
    
    _footerView = [MJRefreshFooterView footer];
    _footerView.delegate = self;
    _footerView.scrollView = self.sellerTableView;
}

#pragma mark - UITableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"SellerOffCellid";
    SellerOffCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SellerOffCell" owner:nil options:nil]lastObject];
    }
    ProcurementModel *model = self.dataArray[indexPath.row];
    [cell configCell:model];
    if (_typeid == 1) {
        cell.typeLabel.text = @"寻找中";
    }else if(_typeid == 2) {
       cell.typeLabel.text = @"已采纳";
    }
    return cell;
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
    if (sender.selectItem == 0) {
        _typeid = 1;
    }
    else if (sender.selectItem == 1){
        _typeid = 2;
    }
    [self showFlower];
    [self getData];
}


#pragma mark - MJ代理
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_isLoading) {
        return;
    }
    if (refreshView == _headerView) {
        _sellerOffPage = 1;
        [self getData];
    }else if (refreshView == _footerView){
        _sellerOffPage++;
        [self getData];
    }
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

-(void)removeScrollToTopButton
{
    [_scrollToTopButton removeFromSuperview];
    _scrollToTopButton = nil;
}
@end
