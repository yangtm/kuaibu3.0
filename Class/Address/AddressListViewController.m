//
//  AddressListViewController.m
//  kuaibu
//
//  Created by zxy on 15/9/7.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddressModel.h"
#import "AddressManager.h"
#import "SVProgressHUD.h"
#import "AddressListCell.h"
#import "AddressEditViewController.h"
#import "MineInfoSetViewController.h"

typedef enum : NSUInteger {
    action_edit = 0,
    action_default,
    action_deleate ,
    action_cancelOrChoose,
} ActionSheet_Action;

@interface AddressListViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    AddressModel *_selModel;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *modelArray;
@property (strong, nonatomic) AddressManager *addManager;

@end

@implementation AddressListViewController
#pragma mark - getter and setter
- (AddressManager *)addManager
{
    if (!_addManager) {
        _addManager = [[AddressManager alloc] init];
    }
    return _addManager;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = RGBCOLOR(231, 231, 231);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:@"收货地址"];
    for (AddressModel *model in self.modelArray) {
//        if (model.ismain) {
//            [_infoSetViewController setAddress:model.address];
//            break;
//        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [MobClick beginLogPageView:@"收货地址"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _selModel = nil;
    [self settitleLabel:@"收货地址"];
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(clickLeftBtn)];
    [self setRightButton:[UIImage imageNamed:@"tianjia"] title:nil target:self action:@selector(addAddress)];
    //UI
    self.view.backgroundColor = kViewBackgroundColor;
    [self.view addSubview:self.tableView];
    
    
    [self getOrRefreshDataWithIsNeedTips:YES];
    
}

- (void)clickLeftBtn{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//重新获取数据，并刷新UI
- (void)getOrRefreshDataWithIsNeedTips:(BOOL)isNeed
{
//    if(isNeed)[SVProgressHUD showWithStatus:@"拼命加载中..." cover:YES offsetY:0];
    self.modelArray = nil;
//    [self.addManager getAddresslistWithToken:([YHBUser sharedYHBUser].token ? :@"") WithSuccess:^(NSMutableArray *modelList) {
//        if(isNeed) [SVProgressHUD dismiss];
//        self.modelArray = modelList;
//        [self.tableView reloadData];
//    } failure:^(NSString *error) {
//        if(isNeed) [SVProgressHUD dismissWithError:error];
//    }];
}

#pragma mark - 数据源方法

#pragma mark 数据行数
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.modelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.modelArray ? 1:0);
}

#pragma mark 每行显示内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    AddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[AddressListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    AddressModel *model = self.modelArray[indexPath.section];
    [cell setUIWithName:model.truename?:@"" Phone:model.contactMobileNumber?:@"" address:model.address?:@"" isMain:((int)model.isDefault?YES:NO)];
    
    return cell;
}

#pragma mark 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AddressModel *model = self.modelArray[indexPath.section];
    _selModel = model;
    if (self.isfromOrder) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请问想怎么操作这条地址" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"查看或修改"otherButtonTitles:@"设为默认地址",@"删除",@"设为收货地址", nil];
        [actionSheet showInView:self.view];
    }else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请问想怎么操作这条地址" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"查看或修改" otherButtonTitles:@"设为默认地址",@"删除", nil];
        [actionSheet showInView:self.view];
    }
    
}

#pragma mark - Action
- (void)addAddress
{
    AddressEditViewController *vc = [[AddressEditViewController alloc] initWithAddressModel:nil isNew:YES SuccessHandle:^{
        [self getOrRefreshDataWithIsNeedTips:NO];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - avtionsheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    __weak AddressListViewController *weakself = self;
    switch (buttonIndex) {
        case action_deleate:
        {
//            [self.addManager deleteAddressWithToken:[YHBUser sharedYHBUser].token?:@"" AndItemID:(int)_selModel.itemid WithSuccess:^{
//                [weakself getOrRefreshDataWithIsNeedTips:NO];
//            } failure:^(NSString *error) {
//                [SVProgressHUD showErrorWithStatus:error cover:YES offsetY:0];
//            }];
        }
            break;
        case action_edit:
        {
//            YHBAddressEditViewController *vc = [[YHBAddressEditViewController alloc] initWithAddressModel:_selModel isNew:NO SuccessHandle:^{
//                [weakself getOrRefreshDataWithIsNeedTips:NO];
//            }];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case action_default:
        {
//            _selModel.ismain = 1;
//            [self.addManager addOrEditAddressWithAddModel:_selModel Token:[YHBUser sharedYHBUser].token?:@"" isNew:NO WithSuccess:^{
//                [SVProgressHUD showSuccessWithStatus:@"修改默认收货地址成功！" cover:YES offsetY:0];
//                [weakself getOrRefreshDataWithIsNeedTips:NO];
//            } failure:^(NSString *error) {
//                [SVProgressHUD showSuccessWithStatus:error cover:YES offsetY:0];
//            }];
        }
            break;
        case action_cancelOrChoose:
        {
            if (self.isfromOrder && [self.delegate respondsToSelector:@selector(choosedAddressModel:)]) {
                [self.delegate choosedAddressModel:_selModel];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
            break;
        default:
            break;
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
