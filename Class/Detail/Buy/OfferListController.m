//
//  OfferListController.m
//  kuaibu
//
//  Created by zxy on 15/9/15.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "OfferListController.h"
#import "OfferListCell.h"
#import "OfferModle.h"
#import "BuyOfferListDetailController.h"
#import "SellerDetailController.h"

@interface OfferListController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    NSInteger _page;
    NSInteger _max;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;


@end

@implementation OfferListController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;

    [self settitleLabel:@"报价列表"];
    [self showData];
    [self createTabelView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 获取数据
- (void)showData
{
    self.dataArray = [[NSMutableArray alloc] init];
    
    NSString *url = nil;
    kYHBRequestUrl(@"procurement/getPurchasePrices", url);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(_offerListId),@"procurementId",@(_page),@"pageIndex", nil];
//    NSLog(@"%ld",_offerListId);
 
    __weak OfferListController *weakSelf = self;
    [NetworkService postWithURL:url paramters:dic success:^(NSData *receiveData) {
        id result = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
        _isLoading = YES;
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = result;
                        NSLog(@"result:%@",dic);
            _max = [dic[@"RESPCODE"]integerValue];
            NSArray *array = dic[@"RESULT"];
            for (NSDictionary *subDic in array) {
                OfferModle *model = [[OfferModle alloc] init];
                [model setValuesForKeysWithDictionary:subDic];
                
                [_dataArray addObject:model];
            }
            [weakSelf.tableView reloadData];
        }
        _isLoading = NO;
        [_headerView endRefreshing];
        [_footerView endRefreshing];
    } failure:^(NSError *error) {
        _isLoading = NO;
        NSLog(@"%@",error);
    }];;
}

- (void)dealloc
{
    _headerView.scrollView = nil;
    _footerView.scrollView = nil;
}

#pragma mark - UI
- (void)createTabelView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    //下拉刷新，上拉加载
    _headerView = [MJRefreshHeaderView header];
    _headerView.delegate = self;
    _headerView.scrollView = self.tableView;
    
    _footerView = [MJRefreshFooterView footer];
    _footerView.delegate = self;
    _footerView.scrollView = self.tableView;
    
    
//    [self.tableView registerClass:[OfferListCell class] forCellReuseIdentifier:@"offerListCellid"];
}

#pragma mark - MJ代理
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_isLoading) {
        return;
    }
    if (refreshView == _headerView) {
        _page = 1;
        [self showData];
    }else if (refreshView == _footerView){
        if (_max >_page) {
            _page++;
        }else{
            _page = _max;
        }
        
        [self showData];
    }
}

#pragma mark - UITabelView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%ld",self.dataArray.count);
    return self.dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"offerListCellid";
    OfferListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OfferListCell" owner:nil options:nil]lastObject];
    }
    
    OfferModle *model = self.dataArray[indexPath.row];
    [cell configOfferListModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BuyOfferListDetailController *vc = [[BuyOfferListDetailController alloc] init];
//    vc.buyOfferListDetailId = _offerListId;
//    SellerDetailController *vc = [[SellerDetailController alloc] init];
    OfferModle *model = self.dataArray[indexPath.row];
    vc.buyOfferListDetailId = [model.procurementPriceId integerValue];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
