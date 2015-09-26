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
#import "OrderDetailModel.h"


@implementation OrderTableView
{
    NSMutableArray *_dataArray;
    NSMutableArray *_sectionArray;
    BOOL _isSelect;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _curPage = 1;
        _dataArray = [NSMutableArray array];
        _sectionArray = [NSMutableArray array];
        _isSelect = 0;

    }
    return self;
}


-(void)setState:(NSInteger)state
{
    _state = state;
    if (state)
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
    
//    [self.headerView beginRefreshing];
    
}

- (void)downloadData{
    
    
    NSLog(@"_state %ld",_state);
    _isLoading = YES;
    NSString *url = nil;
    kYHBRequestUrl(@"order/getOrdersForBuy", url);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(_curPage),@"pageIndex",@(_state),@"state", nil];
    NSLog(@"url:%@",url);
    [NetworkService postWithURL:url paramters:dic success:^(NSData *receiveData) {
        if (_curPage == 1) {
            [_dataArray removeAllObjects];
            [_sectionArray removeAllObjects];
        }
        id result = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"**result:%@",result);
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = result;
//            NSLog(@"%@",dic[@"RESULT"]);
            for (NSDictionary *subDic in dic[@"RESULT"]) {
                
                OrderModel *orderModel = [[OrderModel alloc] init];
                [orderModel setValuesForKeysWithDictionary:subDic];
                [_sectionArray addObject:orderModel];
                for (NSDictionary *dict in subDic[@"orderItems"]) {
                    OrderDetailModel *model = [[OrderDetailModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [_dataArray addObject:model];
                }
            }
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
    return _sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OrderHeaderView *headerView = [[OrderHeaderView alloc] initWithFrame:CGRectMake(0, 10, kMainScreenWidth, 40) orderType:_state];
//    headerView.state = _state;
    NSLog(@"hhh:%ld",headerView.state);
    headerView.delegate = self;
    OrderModel *model = _sectionArray[section];
    headerView.storeNameLabel.text = model.storeName;
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    OrderFooterView *footerView = [[OrderFooterView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 80) state:_state];
    OrderModel *model = _sectionArray[section];
//    footerView.numberLabel.text = [NSString stringWithFormat:@"共计%@件商品",model.quantity];
    footerView.totalLabel.text = [NSString stringWithFormat:@"合计 ¥%@",model.countPrice];
    footerView.delegate = self;
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"OrderListCellid";
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"OrderListCell" owner:nil options:nil][0];
    }
    OrderDetailModel *model = _dataArray[indexPath.row];
    [cell showModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    
}

#pragma mark - OrderFooterViewDelegate
- (void)clickPaymentBtn:(OrderFooterView *)footerView{
    if (_state == -1) {
         NSLog(@"付款");
    }else if (_state == 4){
        NSLog(@"付款");
    }else if (_state == 5){
        NSLog(@"提醒卖家");
    }else if (_state == 6){
        NSLog(@"确认收货");
    }else if (_state == 7){
        NSLog(@"评价订单");
    }
   
}

- (void)clickCancelOrderBtn:(OrderFooterView *)footerView{
    NSLog(@"取消订单");
}

- (void)clickContactSellerBtn:(OrderFooterView *)footerView{
    NSLog(@"联系卖家");
}

#pragma mark - OrderHeaderViewDelegate
- (BOOL)clickAction:(OrderHeaderView *)headerView{
    if (_isSelect == 0) {
        [headerView.selectImageView setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
        _isSelect = 1;
    }else{
        [headerView.selectImageView setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
        _isSelect = 0;
    }
    
    return YES;
}

- (void)tapStoreName:(OrderHeaderView *)headerView{
    //进入店铺详情
}

#pragma mark - 刷新
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_isLoading)
    {
        return;
    }
    
    if (refreshView == _headerView)
    {
        _curPage = 1;
        [self downloadData];
        
    }
    if (refreshView == _footerView)
    {
        _curPage++;
        [self downloadData];
    }
}

- (void)dealloc
{
    self.headerView.scrollView = nil;
    self.footerView.scrollView = nil;
}
@end
