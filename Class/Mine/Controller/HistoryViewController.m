//
//  HistoryViewController.m
//  kuaibu
//
//  Created by zxy on 15/9/19.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryCell.h"
#import "ProductModel.h"

@interface HistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    NSInteger _index;
    NSIndexPath *_indexoath;
}

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settitleLabel:@"最近访问"];
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(back)];
    [self setRightButton:nil title:@"清空" target:self action:@selector(clearAction)];
    
    [self showData];
    [self prepareTableView];
}

#pragma mark - 清空数据
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)clearAction{
    NSLog(@"清空数据");
}

- (void)showData
{
    _dataArray = [NSMutableArray array];
    
}

- (void)prepareTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight ) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
//    _tableView.tableFooterView = [[UIView alloc] init];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"historyCellid";
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HistoryCell" owner:nil options:nil]lastObject];
    }
//    ProductModel *model = _dataArray[indexPath.row];
//    [cell configModel:model];
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"确定要这条记录吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    _index = indexPath.row;
    _indexoath = indexPath;
}

#pragma mark - UIAlertView代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }else if (buttonIndex == 1){
//        ProductModel *model = _dataArray[_index];
        
        [_dataArray removeObjectAtIndex:_index];
        [_tableView deleteRowsAtIndexPaths:@[_indexoath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
