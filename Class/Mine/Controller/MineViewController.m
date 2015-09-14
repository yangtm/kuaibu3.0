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
#import "MyheaderCell.h"
#import "FriendsViewController.h"
#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "LoginViewController.h"
#import "HZCookie.h"


#define WORLD (@"world")

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,MyheaderCellDelagate,UIActionSheetDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIButton *messageBtn;

@end


@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self settitleLabel:@"用户中心"];
//    [self setRightButton:[UIImage imageNamed:@"message"] title:nil target:self action:@selector(messageButtonClick)];
//    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(setLogin)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.messageBtn];
    self.view.backgroundColor = kViewBackgroundColor;
    [self prepareData];
    [self createTabelView];
    

}

- (UIButton *)navBarMessageButton
{
    if (_messageBtn == nil) {
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _messageBtn.frame = CGRectMake(0, 0, 20, 25);
        [_messageBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
        _messageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_messageBtn addTarget:self action:@selector(messageButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        UIView * badgeView = [[UIView alloc] initWithFrame:CGRectMake(13, 0, 10, 10)];
//        badgeView.layer.cornerRadius = 5.0;
//        badgeView.layer.masksToBounds = YES;
//        badgeView.backgroundColor = [UIColor redColor];
//        [_messageBtn addSubview:badgeView];
    }
    return _messageBtn;
}



#pragma mark -按钮响应事件
- (void)setLogin
{
    SettingViewController *vc = [[SettingViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:^{
        
    }];
}

- (void)messageButtonClick
{
    self.tabBarController.selectedIndex = 3;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10) {
        if (buttonIndex == 1) {
            
            NSString *url = nil;
            kYHBRequestUrl(@"member/outlogin", url);
            __weak typeof(self) weakSelf=self;
            [NetworkService postWithURL:url paramters:nil success:^(NSData *receiveData) {
                
                id result = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
                if ([result isKindOfClass:[NSDictionary class]]) {
                    if ([result[@"RESPCODE"] integerValue] == 0) {
                        [weakSelf showAlertWithMessage:result[@"RESPMSG"] automaticDismiss:YES];
                        [HZCookie removeCookie];
                        [HZCookie setCookie];
                        self.tabBarController.selectedIndex = 0;
                        
                        LoginViewController *vc = [[LoginViewController alloc] init];
                        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
                        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"password"];
                        [self presentViewController:navi animated:YES completion:^{
                            
                        }];
                    }
                }
                
            } failure:^(NSError *error) {
                self.tabBarController.selectedIndex = 0;
            }];
        }
    }
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
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
        static NSString *myheaderId = @"myheaderId";
        MyheaderCell *cell = [tableView dequeueReusableCellWithIdentifier:myheaderId];
        if (!cell) {
            cell = [[MyheaderCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:myheaderId];
            cell.delegate = self;
        }
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
- (void)clickMessageImageView:(MyheaderCell *)cell
{
    self.tabBarController.selectedIndex = 3;
}

-(void)clickPortraitImageView:(MyheaderCell *)cell
{
    
}

-(void)clickSettingBtn:(MyheaderCell *)cell
{
    NSLog(@"设置");
    SettingViewController *vc = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showAlertWithMessage:(NSString *)message automaticDismiss:(BOOL)automatic
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    if(automatic)
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:1.0f];
    
}
/**
 *  消失警告视图
 *
 *  @param alert 警告视图
 */
-(void)dismissAlertView:(UIAlertView *)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

@end
