//
//  OrderSureController.m
//  kuaibu
//
//  Created by zxy on 15/9/23.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "OrderSureController.h"
#import "AddressListViewController.h"
#import "OrderSuccessController.h"

@interface OrderSureController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property (nonatomic,strong) UILabel *orderPriceLabel;
@property (nonatomic,strong) UILabel *freightLabel;
@property (nonatomic,strong) UILabel *userName;
@property (nonatomic,strong) UILabel *userPhone;
@property (nonatomic,strong) UILabel *userAddress;
@property (nonatomic,strong) UILabel *supplyName;
@property (nonatomic,strong) UIImageView *logoImageView;
@property (nonatomic,strong) UILabel *orderTitleLabel;
@property (nonatomic,strong) UILabel *orderNumberLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *numbers;

@end

@implementation OrderSureController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settitleLabel:@"确认订单"];
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(back)];
//    self.view.backgroundColor = RGBCOLOR(241, 241, 241);
    [self createTableView];
   
}
- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight ) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc] init];
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
        number = 1;
    }
    return number;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 10;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 10;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger number = -1;
    if (indexPath.section == 0) {
        if (indexPath.row == 0)
            number = 70;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0)
            number = 140;
        else if(indexPath.row == 1)
            number = 44;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            number = 44;
        }
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (indexPath.section == 0) {
        UIView *view = [self userFormView:CGRectMake(0, 0, kMainScreenWidth, 70)];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.contentView addSubview:view];
    }else if (indexPath.section ==1){
        if (indexPath.row == 0) {
            
            UIView *view1 = [self supplyFormView:CGRectMake(0, 0, kMainScreenWidth, 140)];
            [cell.contentView addSubview:view1];
        }else if (indexPath.row == 1){
            UIView *view2 = [self footFormView:CGRectMake(0, 0, kMainScreenWidth, 44)];
            [cell.contentView addSubview:view2];

        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            UIView *view3 = [self sureView:CGRectMake(0, 0, kMainScreenWidth, 44)];
            [cell.contentView addSubview:view3];
            cell.backgroundColor = KColor;
        }
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
        AddressListViewController *vc = [[AddressListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 2){
        
        OrderSuccessController *vc = [[OrderSuccessController alloc] init];
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:^{
            
        }];
    }
}


- (UIView *)sureView:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(0, 0, kMainScreenWidth, 44) title:@"确 认 订 单"];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    [view addSubview:label];
    [self addBottomLine:view];
    return view;
}


- (UIView *)footFormView:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(kMainScreenWidth/2 - 40, 0, 100, 44) title:@"共计50件商品"];
    [view addSubview:label];
    UILabel *lable1 = [self formTitleLabel:CGRectMake(label.right + 10, 0, kMainScreenWidth/3, 44) title:@"合计 : ¥ 888"];
    NSMutableAttributedString *attrubute = [[NSMutableAttributedString alloc] initWithString:lable1.text];
    [attrubute addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, lable1.text.length - 4)];
    lable1.attributedText = attrubute;
    [view addSubview:lable1];
    [self addBottomLine:view];
    return view;
}

#pragma mark - userView
- (UIView *)userFormView:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [self formTitleLabel:CGRectMake(10, 10, 50, 20) title:@"收货人 : "];
    [view addSubview:label];
    
    _userName = [self formTitleLabel:CGRectMake(label.right, 10, 100, 20) title:@"XXXX"];
    [view addSubview:_userName];
    //    _userName.backgroundColor = kNaviTitleColor;
    _userPhone = [self formTitleLabel:CGRectMake(view.right -140, 10, 100, 20) title:@"13917638167"];
    [view addSubview:_userPhone];
    
    UILabel *label1 = [self formTitleLabel:CGRectMake(10, _userName.bottom + 10,70, 20) title:@"收货地址 : "];
    [view addSubview:label1];
    _userAddress = [self formTitleLabel:CGRectMake(label1.right, _userName.bottom + 10, kMainScreenWidth - label1.width - 20, 20) title:@"XXXXXXXXXXXXXX"];
    [view addSubview:_userAddress];
    [self addBottomLine:view];
    
    return view;
}

#pragma mark - supply
- (UIView *)supplyFormView:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label1 = [self formTitleLabel:CGRectMake(20,10, 60, 20) title:@"供应商 : "];
    label1.font = [UIFont boldSystemFontOfSize:16.0f];
    [view addSubview:label1];
    _supplyName = [self formTitleLabel:CGRectMake(label1.right + 10, 10, kMainScreenWidth - label1.width - 30, 20) title:@"XXXXXXXXXXXXXX"];
    _supplyName.font = [UIFont boldSystemFontOfSize:16.0f];
    [view addSubview:_supplyName];
    
    _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, _supplyName.bottom + 5, 90, 90)];
    _logoImageView.layer.masksToBounds = YES;
    _logoImageView.layer.cornerRadius = 5;
    _logoImageView.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:_logoImageView];
    
    _orderTitleLabel = [self formTitleLabel:CGRectMake(_logoImageView.right + 10, _supplyName.bottom + 5, kMainScreenWidth - _logoImageView.width - 40, 20) title:@"采购咖啡色窗帘布"];
    _orderTitleLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:_orderTitleLabel];
    
    
    _orderNumberLabel = [self formTitleLabel:CGRectMake(_logoImageView.right + 10, _orderTitleLabel.bottom + 5, kMainScreenWidth - _logoImageView.width - 30, 20) title:@"采购1001212112111米"];
    _orderNumberLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:_orderNumberLabel];
    NSLog(@"%ld",_orderNumberLabel.text.length);
    NSMutableAttributedString *attrubuteStr = [[NSMutableAttributedString alloc] initWithString:_orderNumberLabel.text];
    [attrubuteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, _orderNumberLabel.text.length - 3)];
    //    [attrubuteStr addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:-2.0] range:NSMakeRange(0, 1)];
    _orderNumberLabel.attributedText = attrubuteStr;
    _timeLabel = [self formTitleLabel:CGRectMake(_logoImageView.right + 10, _orderNumberLabel.bottom + 5, 80, 20) title:@"2001.2.2"];
    _timeLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:_timeLabel];
    
    _priceLabel = [self formTitleLabel:CGRectMake(_logoImageView.right + 10, _timeLabel.bottom + 5, 80, 20) title:@"¥ 888"];
    _priceLabel.textColor = [UIColor redColor];
    [view addSubview:_priceLabel];
    
    _numbers = [self formTitleLabel:CGRectMake(view.right-70, _timeLabel.bottom + 5, 50, 20) title:@"X50"];
    _numbers.textColor = [UIColor lightGrayColor];
    [view addSubview:_numbers];
    
    [self addBottomLine:view];
    return view;
}

- (UILabel *)formTitleLabel:(CGRect)frame title:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:13];
    label.text = title;
    return label;
}

- (void)addBottomLine:(UIView *)view
{
    UIView *lineView = [self lineView:CGRectMake(0, view.height - 0.5, 0, 0)];
    lineView.tag = 101;
    [view addSubview:lineView];
}

- (UIView *)lineView:(CGRect)frame
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, kMainScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    return lineView;
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
