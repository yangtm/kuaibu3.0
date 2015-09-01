//
//  SettingViewController.m
//  kuaibu
//
//  Created by zxy on 15/9/1.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//  设置

#import "SettingViewController.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}

@end

@implementation SettingViewController






- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kViewBackgroundColor;
    
    
    [self createNavi];
    [self createTableView];
    [self exitAction];
    
    
}

#pragma mark - 导航栏
- (void)createNavi
{
    [self settitleLabel:@"设置"];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = item;
}

#pragma mark - 列表
- (void)createTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc] init];
   
}

#pragma mark - 退出按钮
- (void)exitAction
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, kMainScreenHeight/2, kMainScreenWidth-40, 40)];
    label.backgroundColor = [UIColor orangeColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"退出登入";
    [self.view addSubview:label];
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
    [label addGestureRecognizer:tap];
}

#pragma mark -按钮响应事件
- (void)clickAction:(UIGestureRecognizer *)btn
{
    NSLog(@"..");
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"个人资料";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"修改密码";
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"清理缓存";
    }else if (indexPath.row == 3){
        cell.textLabel.text = @"意见反馈";
    }else if (indexPath.row == 4){
        cell.textLabel.text = @"关于快布";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            NSLog(@"个人资料");
            break;
        case 1:
            NSLog(@"修改密码");
            break;
        case 2:
            NSLog(@"清理缓存");
            break;
        case 3:
            NSLog(@"意见反馈");
            break;
        case 4:
            NSLog(@"关于快布");
            break;
        default:
            break;
    }
}


@end
