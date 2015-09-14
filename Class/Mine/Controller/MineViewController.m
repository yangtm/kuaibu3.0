//
//  MineViewController.m
//  kuaibu_3.0
//
//  Created by zxy on 15/8/18.
//  Copyright (c) 2015年 zxy. All rights reserved.
//

#import "MineViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "NSString+MD5.h"
#import "SettingViewController.h"
#import "HeaderSectionCell.h"
#import "FriendsViewController.h"
#import "AppDelegate.h"
#import "MainTabBarController.h"


#define WORLD (@"world")

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,HeaderSectionCellDelagate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end


@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settitleLabel:@"用户中心"];
    
    self.view.backgroundColor = kViewBackgroundColor;
//    self.mineHeadView = [[MineHeadView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 180) type:MineHeadViewTypeBuyer];
//    self.mineHeadView.nameLabel.text = _userName;
//    self.functionsView = [[FunctionsView alloc] initWithFrame:CGRectMake(0, self.mineHeadView.bottom, kMainScreenWidth, kMainScreenHeight-self.mineHeadView.height-49)];
//    //    self.mineHeadView.frame = CGRectMake(0, 0, kMainScreenWidth, 220);
//    [self.view addSubview:self.mineHeadView];
//    [self.view addSubview:self.functionsView];
//    self.rightBtn.frame = CGRectMake([[UIScreen mainScreen]bounds].size.width-70, 30, 60, 20);
//    [self.view addSubview:self.rightBtn];
    [self prepareData];
    [self createTabelView];
    

}

#pragma mark - 数据源
- (void)prepareData
{
    self.dataArray = [[NSMutableArray alloc] init];
    NSDictionary *dic = @{WORLD:@[@"采购报价",@"我的收藏",@"最近访问",@"购物车",@"收货地址"]};
    [_dataArray addObject:dic];
}

#pragma mark - UI
- (void)createTabelView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kViewBackgroundColor;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = -1;
    if (section == 0) {
        number = 1;
    }else if (section == 1){
        number = 2;
    }else if (section == 2){
        number = 5;
    }else if (section == 3){
        number = 1;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
//        cell.backgroundColor = kBackgroundColor;
        static NSString *cellid = @"HeaderSectionCell";
        HeaderSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[HeaderSectionCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
        }
        
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone; 
        return cell;
    }else if (indexPath.section == 1){
        
        static NSString *cellid = @"cellid";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"全部订单";
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            cell.userInteractionEnabled = YES;
        }else if (indexPath.row == 1){
            
        }
        return cell;
        
    }else if (indexPath.section == 2){
        static NSString *cellid = @"cellid";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
        }
        
        NSDictionary *subDic = _dataArray[indexPath.section-2];
        NSArray *worldArray = subDic[WORLD];
        cell.textLabel.text = worldArray[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        
    }else if (indexPath.section == 3){
        static NSString *cellid = @"cellid";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
        }
        
        cell.textLabel.text = @"我是卖家";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    //    cell.backgroundColor = [UIColor clearColor];
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger number = -1;
    if (indexPath.section == 0) {
        number = 100;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            number = 44;
        }else if (indexPath.row == 1){
            number = 60;
        }
    }else if (indexPath.section == 2){
        number = 44;
    }else if (indexPath.section == 3){
        number = 44;
    }
    return number;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - HeaderSectionCellDelagate
- (void)clickMessageImageView:(HeaderSectionCell *)cell
{
    self.tabBarController.selectedIndex = 3;
}

-(void)clickPortraitImageView:(HeaderSectionCell *)cell
{
    
}

-(void)clickSettingBtn:(HeaderSectionCell *)cell
{
    NSLog(@"设置");
    SettingViewController *vc = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)test{
    
    //    http://192.168.1.111:8080/kuaibu-appServicr/member/memberInfo
    NSString *nonce = [NSString stringWithFormat:@"%d",arc4random_uniform(1000)+1];
    NSString *timestamp = [self getcurrentTimestamp];
    NSString *sign = [NSString stringWithFormat:@"%@||%@||%@||%@",kAPPID,nonce,timestamp,kAPPKEY];
    NSLog(@"sign:%@",sign);
    NSString *signs = [sign MD5Hash];
    NSLog(@"sign:%@",signs);
    NSString *newSign = [signs substringWithRange:NSMakeRange(12, 8)];
    NSDictionary *postDic =@{@"app_id":kAPPID,@"timestamp":timestamp,@"nonce":nonce,@"sign":newSign, @"memberNameTel":@"",@"password":@""};
    NSString *loginUrl = [NSString stringWithFormat:@"%@member/memberInfo",kYHBBaseUrl];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:loginUrl parameters:postDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"RESPMSG"]);
        
        if ([responseObject[@"RESPCODE"] integerValue]==0) {
            
        }
        NSLog(@"************************************");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

-(NSString*)getcurrentTimestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%f",time];
    NSString *timestamp = [timeStr componentsSeparatedByString:@"."][0]; //精确到秒
    return timestamp;
    
}

@end
