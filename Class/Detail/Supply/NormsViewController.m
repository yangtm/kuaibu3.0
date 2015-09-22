//
//  NormsViewController.m
//  kuaibu
//
//  Created by zxy on 15/9/22.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "NormsViewController.h"
#import "AddNormsViewController.h"
#import "NormsModle.h"
#import "NormsManager.h"
@interface NormsViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSInteger _index;
    NSIndexPath *_indexoath;
    void(^myBlock)(NSArray *myArray);
    void(^Block)(NSString *title);
    NSMutableArray *_normsArray;
}


@end

@implementation NormsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(236, 236, 236);
    self.title = @"填写规格";
//    [self createNavigation];
    [self prepareData];
    [self showData];
    [self createTableView];
    [self setRightButton:nil title:@"确认" target:self action:@selector(rightBarButtonClick:)];
    [self setLeftButton:[UIImage imageNamed:@"back"] title:@"" target:self action:@selector(backButtonClikc:)];
    // Do any additional setup after loading the view.
}

- (void)useBlock:(void (^)(NSArray *))aBlock
{
    myBlock = aBlock;
}

- (void)strBlock:(void (^)(NSString *))aBlock
{
    Block = aBlock;
}

#pragma mark - 返回
- (void)backButtonClikc:(UIButton *)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonClick:(UIButton *)btn
{
    if (_dataArray.count > 0) {
        Block(@"规格已编辑");
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self showAlertWithMessage:@"内容不能为空" automaticDismiss:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 初始化数据源
- (void)prepareData
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    _normsArray  = [NSMutableArray array];
}

#pragma mark - 读取数据库数据
- (void)showData
{
    NormsManager *manager = [NormsManager shareManager];
    NSArray *array = [[NSMutableArray alloc]init];
    array = [manager selectAllNorms];
    myBlock(array);
//    NSLog(@"array:%@",array);
    if (_dataArray.count) {
        [_dataArray removeAllObjects];
    }
    
    for (NSString *str in array) {
        NormsModle *model = [[NormsModle alloc] init];
        NSArray *strArray = [str componentsSeparatedByString:@"xiaozhu"];
//        NSLog(@"strArray:%@",strArray);
        model.specificationName = strArray[0];
        model.price = strArray[1];
        [_dataArray addObject:model];
        
    }
    
    [_tableView reloadData];
}


#pragma mark - 创建uitableview
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 44) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc] init];
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - 44, kMainScreenWidth, 44)];
    addBtn.layer.cornerRadius = 2.5;
    addBtn.backgroundColor = KColor;
    [addBtn setTitle:@"添 加 规 格" forState:UIControlStateNormal];
    [addBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    [addBtn addTarget:self action:@selector(gotoAddAction:)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
 
}

#pragma mark - UITableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
//    NSLog(@"几个数据%ld", _dataArray.count);
    return _dataArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    NormsModle *model = _dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"规格名称 : %@",model.specificationName];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"价格 : %@ 元",model.price];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    cell.detailTextLabel.textColor = [UIColor redColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"确定删除吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    _index = indexPath.row;
    _indexoath = indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    AddNormsViewController *vc = [[AddNormsViewController alloc] init];
//    NormsModle *model = _dataArray[indexPath.row];
//    vc.model = model;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - UIAlertView代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }else if (buttonIndex == 1){
        NormsModle *model = _dataArray[_index];
        
        [[NormsManager shareManager]deleteDataByName:model.specificationName];
        [_dataArray removeObjectAtIndex:_index];
        [_tableView deleteRowsAtIndexPaths:@[_indexoath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}




- (void)gotoAddAction:(UIButton *)button
{
    AddNormsViewController *vc = [[AddNormsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showData];
    //    NSArray *array = [[notesManager shareManager]selectAllNotes];
    //    _dataArray = [NSMutableArray arrayWithArray:array];
    //
    //    [_tableView reloadData];
}

@end
