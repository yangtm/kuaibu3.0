//
//  ProcurementListController.m
//  kuaibu
//
//  Created by zxy on 15/9/10.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "ProcurementListController.h"
#import "SVProgressHUD.h"
#import "ProcurementListCell.h"
#import "BuyDetailViewController.h"

@interface ProcurementListController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}

@end

@implementation ProcurementListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settitleLabel:@"我的采购"];
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(dismissSelf)];
    
    [self prepareData];
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
- (void)prepareData
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
}

#pragma mark - 请求数据
- (void)showData
{
    
}

#pragma mark -UI
- (void)createTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"ProcurementListCellid";
    ProcurementListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ProcurementListCell" owner:nil options:nil][0];
    }
//    ProcurementModel *model = _dataArray[indexPath.row];
//    [cell configModel:model];
    return cell;
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
    return 140;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BuyDetailViewController *vc = [[BuyDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
