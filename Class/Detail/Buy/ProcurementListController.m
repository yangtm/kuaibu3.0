//
//  ProcurementListController.m
//  kuaibu
//
//  Created by zxy on 15/9/10.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "ProcurementListController.h"
#import "SVProgressHUD.h"
#import "ListCell.h"
#import "BuyDetailViewController.h"
#import "ProcurementModel.h"
#import "OfferListController.h"

@interface ProcurementListController ()<UITableViewDataSource,UITableViewDelegate,ListCellDelagate,MJRefreshBaseViewDelegate,UIScrollViewDelegate>
{
    NSInteger _page;
   
    NSInteger _offerList;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIButton *scrollToTopButton;
@end

@implementation ProcurementListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settitleLabel:@"我的采购"];
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(dismissSelf)];
    _page = 1;

    self.dataArray  = [[NSMutableArray alloc] init];
    
    [self showData];
    [self createTableView];
    [self addScrollToTopButton];
}



#pragma mark 返回
- (void)dismissSelf
{
    self.tabBarController.selectedIndex = 4;
    [self dismissViewControllerAnimated:YES completion:^{
      
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}




#pragma mark - 请求数据
- (void)showData
{
    NSString *url = nil;
    kYHBRequestUrl(@"procurement/memberPurchaseList", url);
    NSLog(@"%@",url);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(_page),@"pageIndex", nil];
    
    __weak ProcurementListController *weakSelf = self;
    [NetworkService postWithURL:url paramters:dic success:^(NSData *receiveData) {
        id result = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
        _isLoading = YES;
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = result;
//            NSLog(@"result:%@",dic);
            NSArray *array = dic[@"RESULT"];
            for (NSDictionary *subDic in array) {
                ProcurementModel *model = [[ProcurementModel alloc] init];
//                [model setValuesForKeysWithDictionary:subDic];
                model.amount = [subDic[@"amount"] doubleValue];
                model.offerLastDate = subDic[@"offerLastDate"];
                model.takeDeliveryLastDate = subDic[@"lastModifyDatetime"];
                model.procurementId = subDic[@"procurementId"];
                _offerList = [model.procurementId integerValue];
//                NSLog(@"_offerList:%ld",_offerList);
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
    }];
}

#pragma mark -UI
- (void)createTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
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
        _page++;
        [self showData];
    }
}

#pragma mark - UITableViewDelegate
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[ListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.delegate = self;
    [self configCell:cell withIndexPath:indexPath];
    return cell;
}

- (void)configCell:(ListCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    ProcurementModel *model = self.dataArray[indexPath.row];
    
    cell.numberStr = model.amount;
    
    cell.indexStr = [NSString stringWithFormat:@"报价次数 : %@",@"1"];
    cell.typeStr = @"寻找中";
//    cell.dataStr = [NSString stringWithFormat:@"发布时间 : %@",[self timeFormatted:[model.offerLastDate doubleValue]/1000]];
//    NSLog(@"offerLastDate:%@",model.offerLastDate);
//    NSLog(@"%@",[self timeFormatted:[model.offerLastDate doubleValue]/1000]);
//    cell.cycleStr = [NSString stringWithFormat:@"报价截止时间 : %@",[self timeFormatted:[model.takeDeliveryLastDate doubleValue]/1000]];
//    NSLog(@"*************offerLastDate:%@",model.takeDeliveryLastDate);
//    NSLog(@"*************takeDeliveryLastDate:%@",[self timeFormatted:[model.takeDeliveryLastDate doubleValue]/1000]);
    cell.cycleStr = model.takeDeliveryLastDate;
    cell.dataStr = [NSString stringWithFormat:@"报价截止时间 : %@",model.offerLastDate];
}
//时间戳转换为时间
- (NSString *)timeFormatted:(int)totalSeconds
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate  *date = [NSDate dateWithTimeIntervalSince1970:totalSeconds];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSString *strDate = [dateFormatter stringFromDate:localeDate];

    return strDate;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BuyDetailViewController *vc = [[BuyDetailViewController alloc] init];
    ProcurementModel *model = _dataArray[indexPath.row];
    vc.ListId = [model.procurementId integerValue];
    vc.procModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ListCellDelagate
- (void)cilckOfferManagerBtn
{
    OfferListController *vc = [[OfferListController alloc] init];
    
    vc.offerListId = _offerList;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)addScrollToTopButton
{
    _scrollToTopButton = [[UIButton alloc] initWithFrame:CGRectMake(self.navigationController.view.frame.size.width - 50 - 20, self.navigationController.view.frame.size.height - 50 - 30, 50, 50)];
    [_scrollToTopButton setImage:[UIImage imageNamed:@"快布3［方案二］_03"] forState:UIControlStateNormal];
    [_scrollToTopButton addTarget:self action:@selector(scrollToTop) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:_scrollToTopButton];
    _scrollToTopButton.hidden = YES;
}

-(void)removeScrollToTopButton
{
    [_scrollToTopButton removeFromSuperview];
    _scrollToTopButton = nil;
}

-(void)scrollToTop
{
    if (self.tableView.contentSize.height <= self.tableView.frame.size.height)
    {
        return;
    }
    else
    {
        [self.tableView setContentOffset:CGPointZero animated:YES];
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
