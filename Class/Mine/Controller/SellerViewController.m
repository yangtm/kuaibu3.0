//
//  SellerViewController.m
//  kuaibu
//
//  Created by zxy on 15/9/22.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "SellerViewController.h"
#import "MyheaderCell.h"
#import "MineHeadView.h"
#import "SellerOffManagerController.h"

#define WORLD (@"world")
#define PHOTO (@"photo")
@interface SellerViewController ()<UITableViewDataSource,UITableViewDelegate,MyheaderCellDelagate,MineHeadViewDelegate>

@property (nonatomic,strong) UITableView *sellerView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) MineHeadView *myView;
@end

@implementation SellerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(241, 241, 241);
    [self settitleLabel:@"我是卖家"];
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(clickLeftBtn)];
    [self prepareData];
    [self createTableView];
    // Do any additional setup after loading the view.
}

#pragma mark - 数据源
- (void)prepareData
{
    self.dataArray = [[NSMutableArray alloc] init];
    NSDictionary *dic = @{WORLD:@[@"报价管理",@"我的宝贝",@"产品管理",@"我的访客"],PHOTO:@[@"iconfont-zijinjilu",@"iconfont-walletgiftcard",@"iconfont-store",@"iconfont-organization"]};
    [_dataArray addObject:dic];
}

#pragma mark -返回
- (void)clickLeftBtn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)createTableView
{
    self.sellerView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) style:UITableViewStylePlain];
    self.sellerView.delegate = self;
    self.sellerView.dataSource = self;
    self.sellerView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.sellerView];
    self.sellerView.backgroundColor = [UIColor clearColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = -1;
    if (section == 0) {
        number = 1;
    }else if (section == 1){
        number = 2;
    }else if (section == 2){
        number = 4;
    }
    return number;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else if (section == 1){
        return 4;
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
            number = 40;
        }else if (indexPath.row == 1){
            number = 60;
        }
    }else if (indexPath.section == 2){
        number = 44;
    }
    return number;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //        cell.backgroundColor = kBackgroundColor;
        static NSString *myheaderId = @"myheaderId";
        MyheaderCell *cell = [tableView dequeueReusableCellWithIdentifier:myheaderId];
        if (!cell) {
            cell = [[MyheaderCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:myheaderId];
            cell.delegate = self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1){
        static NSString *orderCellid = @"orderCellid";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellid];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:orderCellid];
        }
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"全部订单";
            cell.imageView.image = [UIImage imageNamed:@"iconfont-list"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 1){
            _myView = [[MineHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60) type:MineHeadViewTypeBuyer];
            _myView.delegate = self;
            //            _myView.backgroundColor = [UIColor redColor];
            [cell addSubview:_myView];
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
        NSArray *photoArray = subDic[PHOTO];
        cell.textLabel.text = worldArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:photoArray[indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        
    }
    
    //    cell.backgroundColor = [UIColor clearColor];
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            SellerOffManagerController *vc = [[SellerOffManagerController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}





#pragma mark - HeaderSectionCellDelagate
- (void)clickMessageImageView:(MyheaderCell *)cell
{
    self.tabBarController.selectedIndex = 3;
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
