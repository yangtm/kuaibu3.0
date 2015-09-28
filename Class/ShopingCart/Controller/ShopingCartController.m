//
//  ShopingCartController.m
//  kuaibu
//
//  Created by zxy on 15/9/24.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "ShopingCartController.h"
#import "ShopingCartListCell.h"
#import "ProcurementModel.h"
#import "ShopingCartListHeaderView.h"
#import "ProductModel.h"
#import "CartModel.h"
#import "UIImageView+WebCache.h"
#import "StoreModel.h"

@interface ShopingCartController ()<UITableViewDataSource,UITableViewDelegate,ShopingCartListCellDelegate,UITextFieldDelegate,ShopingCartListHeaderViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_SectionArray;
    NSMutableArray *_ListArray;
    NSInteger _selectType;
    NSInteger _pageIndex;
}

@end

@implementation ShopingCartController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settitleLabel:@"购物车"];
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(back)];
    self.view.backgroundColor = kViewBackgroundColor;
    _selectType = YES;
    _pageIndex = 1;
    [self showData];
    [self createTableView];
}

- (UIView *)createFooterView{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - 44, kMainScreenWidth, 44)];
    
    return view;
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showData
{
    _dataArray = [NSMutableArray array];
    _SectionArray = [NSMutableArray array];
    _ListArray = [NSMutableArray array];
    NSString *url = nil;
    kYHBRequestUrl(@"cart/cartList", url);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(_pageIndex),@"pageIndex", nil];
    [NetworkService postWithURL:url paramters:dic success:^(NSData *receiveData) {
        id result = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            for (NSDictionary *dic in result[@"RESULT"]) {
                CartModel *model = [[CartModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
                
                NSDictionary *product = model.product;
                ProductModel *productModel = [[ProductModel alloc] init];
                [productModel setValuesForKeysWithDictionary:product];
                [_ListArray addObject:productModel];
                
                NSDictionary *store = model.store;
                StoreModel *storeModel = [[StoreModel alloc] init];
                storeModel.storeName = store[@"storeName"];
                [_SectionArray addObject:storeModel];
            }
            
            
        }
        [_tableView reloadData];
        MLOG(@"%@",result);
    } failure:^(NSError *error) {
        MLOG(@"%@",error);
    }];
}

- (void)createTableView
{
//    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.tableFooterView = [[UIView alloc] init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _SectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _ListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    StoreModel *model = _SectionArray[section];
    ShopingCartListHeaderView *view = [[ShopingCartListHeaderView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
    view.storeNameLabel.text = model.storeName;
    view.delegate = self;
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    ShopingCartListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[ShopingCartListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    ProductModel *productModel = _ListArray[indexPath.row];
    CartModel *cartModel = _dataArray[indexPath.row];
    NSString *productImageUrl = nil;
    kZXYRequestUrl(productModel.productImage, productImageUrl);
    [cell.productImage sd_setImageWithURL:[NSURL URLWithString:productImageUrl]];
    cell.detailLabel.text = productModel.productName;
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",productModel.price];
    cell.showTextField.text = [NSString stringWithFormat:@"%@",cartModel.amount];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -ShopingCartListCellDelegate
- (void)clickSelectBtn:(ShopingCartListCell *)cell
{
    if (_selectType) {
       [cell.selectButton setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];

    }else{
       [cell.selectButton setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    }
    _selectType = !_selectType;
}

- (void)clickReduceBtn:(ShopingCartListCell *)cell
{
    cell.number = [cell.showTextField.text integerValue];
    if(cell.number >= 2){
        cell.number -= 1;
        cell.showTextField.text = [NSString stringWithFormat:@"%ld",cell.number];
    }
}

- (void)clickIncreaseBtn:(ShopingCartListCell *)cell
{
    cell.number = [cell.showTextField.text integerValue];
    cell.number += 1;
    cell.showTextField.text = [NSString stringWithFormat:@"%ld",cell.number];
  
}

#pragma mark -ShopingCartListHeaderViewDelegate
- (BOOL)clickAction:(ShopingCartListHeaderView *)headerView
{
    if (_selectType) {
        [headerView.selectAllButton setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    }else{
        [headerView.selectAllButton setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    }
    _selectType = !_selectType;
    return YES;
}

- (void)tapStoreName:(ShopingCartListHeaderView *)headerView
{
    //点击进入店铺详情
}
@end
