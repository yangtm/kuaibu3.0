//
//  FunctionsView.m
//  Register
//
//  Created by zxy on 15/8/27.
//  Copyright (c) 2015年 zxy. All rights reserved.
//

#import "FunctionsView.h"
#import "Public.h"
#define WORLD (@"文字")
@implementation FunctionsView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _tableView.frame = self.bounds;
}

- (void)setup
{
    _dataArray = [[NSMutableArray alloc] init];
    
    NSDictionary *dic = @{WORLD:@[@"采购报价",@"我的收藏",@"最近访问",@"购物车"]};
    [_dataArray addObject:dic];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kViewBackgroundColor;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = -1;
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 4;
    }else if (section == 2){
        return 1;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = @"全部订单";
        
    }else if (indexPath.section == 1){
        
        NSDictionary *subDic = _dataArray[indexPath.section-1];
        NSArray *worldArray = subDic[WORLD];
        cell.textLabel.text = worldArray[indexPath.row];
        
    }else if (indexPath.section == 2){
        
        cell.textLabel.text = @"我是卖家";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
