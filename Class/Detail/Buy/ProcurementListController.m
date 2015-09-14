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

@interface ProcurementListController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _page;
    BOOL _isLoading;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
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
    
}



#pragma mark 返回
- (void)dismissSelf
{
    [self dismissFlower];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)dismissFlower
{
    [SVProgressHUD dismiss];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



#pragma mark - 初始化数据
//- (NSMutableArray *)dataArray
//{
//    if (_dataArray == nil) {
//        _dataArray = [[NSMutableArray alloc] init];
//    }
//    return _dataArray;
//}
#pragma mark - 请求数据
- (void)showData
{
//    _isLoading = YES;
    NSString *url = nil;
    kYHBRequestUrl(@"procurement/memberPurchaseList", url);
    NSLog(@"%@",url);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(_page),@"pageIndex", nil];
    
    __weak ProcurementListController *weakSelf = self;
    [NetworkService postWithURL:url paramters:dic success:^(NSData *receiveData) {
        id result = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = result;
            NSLog(@"result:%@",dic);
            NSArray *array = dic[@"RESULT"];
            for (NSDictionary *subDic in array) {
                ProcurementModel *model = [[ProcurementModel alloc] init];
                model.amount = [subDic[@"amount"] doubleValue];
                model.offerLastDate = subDic[@"offerLastDate"];
                model.takeDeliveryLastDate = subDic[@"lastModifyDatetime"];
                [_dataArray addObject:model];
            }
            [weakSelf.tableView reloadData];
        }
//        _isLoading = NO;
    } failure:^(NSError *error) {
//        _isLoading = NO;
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
//    _tableView.tableFooterView = [[UIView alloc] init];
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
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BuyDetailViewController *vc = [[BuyDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
