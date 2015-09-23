//
//  SellerViewController.m
//  kuaibu
//
//  Created by zxy on 15/9/22.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "SellerViewController.h"

@interface SellerViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *sellerView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation SellerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(241, 241, 241);
    [self settitleLabel:@"我的店铺"];
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(clickLeftBtn)];
    self.dataArray = [NSMutableArray array];
    
    [self createTableView];
    // Do any additional setup after loading the view.
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
        number = 1;
    }else if (section == 2){
        number = 4;
    }
    return number;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 0;
    }
    return 10;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = @"头像";
    }else if (indexPath.section == 1){
        cell.textLabel.text = @"全部订单";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 2){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"报价管理";
        
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"我的宝贝";
        }else if (indexPath.row == 2){
            cell.textLabel.text = @"产品管理";
        }else if (indexPath.row == 3){
            cell.textLabel.text = @"我的访客";
        }
    }
    return cell;

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
