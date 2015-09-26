//
//  OrderTableView.m
//  kuaibu
//
//  Created by 朱新余 on 15/9/25.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "OrderTableView.h"
#import "ProgressHUD.h"
#import "OrderModel.h"
#import "OrderListCell.h"
#import "OrderHeaderView.h"

@implementation OrderTableView
{
    NSMutableArray *_dataArray;
    NSMutableArray *_sectionArray;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _curPage = 1;
        _dataArray = [NSMutableArray array];
        _sectionArray = [NSMutableArray array];
        self.backgroundColor = [UIColor redColor];
        [self createTableView];
    }
    return self;
}


-(void)setUrlString:(NSString *)urlString
{
    _urlString = urlString;
    if (urlString)
    {
        [self createTableView];
    }
    
}

-(void)createTableView
{
    [self downloadData];
    
    self.delegate = self;
    self.dataSource = self;
    
    self.headerView = [MJRefreshHeaderView header];
    self.headerView.scrollView = self;
    self.headerView.delegate = self;
    
    self.footerView = [MJRefreshFooterView footer];
    self.footerView.scrollView = self;
    self.footerView.delegate = self;
    
    [self.headerView beginRefreshing];
    
}

- (void)downloadData{
    
    _isLoading = YES;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(_curPage),@"indexPage", nil];
    
    [NetworkService postWithURL:_urlString paramters:dic success:^(NSData *receiveData) {
        if (_curPage == 1) {
            [_dataArray removeAllObjects];
        }
        id result = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"result::%@",result);
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = result;
        }
        [self reloadData];
        _isLoading = NO;
        [_headerView endRefreshing];
        [_footerView endRefreshing];
        
    } failure:^(NSError *error) {
        _isLoading = NO;
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OrderHeaderView *view = [[OrderHeaderView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44)];
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"OrderListCellid";
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"OrderListCell" owner:nil options:nil][0];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderModel *model = _dataArray[indexPath.row];
    if (self.selectBlock)
    {
        self.selectBlock(model.orderStatus);
    }
    
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (self.isLoading)
    {
        return;
    }
    
    if (refreshView == self.headerView)
    {
        self.curPage = 1;
        [self downloadData];
        
    }
    if (refreshView == self.footerView)
    {
        self.curPage++;
        [self downloadData];
    }
}

- (void)dealloc
{
    self.headerView.scrollView = nil;
    self.footerView.scrollView = nil;
}
@end
