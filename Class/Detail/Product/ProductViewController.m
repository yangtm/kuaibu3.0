//
//  ProductViewController.m
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/21.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "ProductViewController.h"
#import "YHBSegmentView.h"
#import "CategoryViewController.h"

typedef enum : long {
    Get_All = 0,
    Get_Amount,
    Get_Price,
} GetPrivateTag;

@interface ProductViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    GetPrivateTag _selTag;
    int pagesize;
    int pageid;
    int pagetotal;
}
@property (strong, nonatomic) UITextField *navBarSearchTextField;
@property (strong, nonatomic) YHBSegmentView *segmentView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *titleArray;
@property (nonatomic, strong) NSArray *catIds;
@property (strong, nonatomic) NSMutableDictionary *modelsDic;//数据字典-存放数据模型数组 key为tag
@property (strong, nonatomic) NSMutableDictionary *pageDic;

@end



@implementation ProductViewController

-(void)back
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _selTag = Get_All;
    
    UIButton *back =[[UIButton alloc]initWithFrame:CGRectMake(20,30, 30, 30)];
    back.backgroundColor = [UIColor redColor];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    UIButton *select = [[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth - 86, 80, (kMainScreenWidth - 86)/3, 20)];
    [select setTitle:@"筛选" forState:UIControlStateNormal];
    [select setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [select addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:select];
    [self.view addSubview:back];
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.tableView];
    [self getFirstPageData];
    [self.view addSubview:self.navBarSearchTextField];
}

#pragma mark 网络请求
- (void)getDataWithPageID:(NSInteger)pageid catIds:(NSArray *)catIds
{
    pageid = 1;
    pagesize = 10;
    NSMutableDictionary *dict;
    
    if (catIds != nil) {
        NSString *catIdsStr = @"";
        for (NSNumber *number in catIds) {
            catIdsStr = [catIdsStr stringByAppendingFormat:@"|%@", number];
        }
        catIdsStr = [catIdsStr substringFromIndex:1];
        NSString *allConditions = [NSString stringWithFormat:@"category:%@",catIdsStr];
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",pageid],@"pageIndex",allConditions,@"allConditions", nil];
    }else
    {
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",pageid],@"pageIndex", nil];
    }
    
    NSString *url= nil;
    GetPrivateTag tag = _selTag;
    switch (tag) {
        case Get_All:
            kYHBRequestUrl(@"product/open/searchProduct", url);
            NSLog(@"url=%@",url);
            break;
        case Get_Amount:
            NSLog(@"1");
            break;
        case Get_Price:
            NSLog(@"2");
            break;

        default:
            break;
    }
    
    [NetworkService postWithURL:url paramters:dict success:^(NSData *receiveData) {
        if (receiveData.length>0) {
            id result=[NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"产品列表＝%@",result);
            if([result isKindOfClass:[NSDictionary class]])
            {
                
            }
        }
    }failure:^(NSError *error){
        NSLog(@"下载数据失败");
    }];
    
}

- (void)getFirstPageData
{
    [self getDataWithPageID:1 catIds:self.catIds];
}

#pragma mark - event response
- (void)rightBarButtonClick:(UIButton *)button
{
    //打开筛选器
    LSNavigationController *navVc = [[LSNavigationController alloc] initWithRootViewController:[CategoryViewController sharedInstancetype]];
    [CategoryViewController sharedInstancetype].hidesBottomBarWhenPushed = YES;
    //navVc.hidesBottomBarWhenPushed = YES;
    [[CategoryViewController sharedInstancetype] cleanAll];
    [CategoryViewController sharedInstancetype].isPushed = NO;
    [CategoryViewController sharedInstancetype].isSingleSelect = NO;
    [[CategoryViewController sharedInstancetype] setBlock:^(NSArray *aArray) {
        // NSLog(@"%@",aArray);
        if (aArray.count > 0) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in aArray) {
                [array addObject:[dic valueForKey:@"categoryId"]];
            }
            self.catIds = array;
        }
        else{
            self.catIds = nil;
        }
        //[self getData];
    }];
    [self presentViewController:navVc animated:YES completion:nil];
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


#pragma mark 数据行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray *modelArray = self.modelsDic[[NSString stringWithFormat:@"%lu",_selTag]];
    return modelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark 每行显示内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *dataArray = self.modelsDic[[NSString stringWithFormat:@"%lu",_selTag]];
    NSString *cellIdentifier1 = @"Buy";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    if (!cell) {
        cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier1];
//        YHBSupplyModel *list = dataArray[indexPath.row];
//        [cell setCellWithModel:list];
    }
     return cell;
}
#pragma mark 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        NSMutableArray *modelArray = self.modelsDic[[NSString stringWithFormat:@"%lu", _selTag]];
        if (modelArray.count > indexPath.row) {
          //  YHBRslist *model = modelArray[indexPath.row];
            
        }
    }
}


- (UITextField *)navBarSearchTextField
{
    if (_navBarSearchTextField == nil) {
        _navBarSearchTextField = [[UITextField alloc] init];
        _navBarSearchTextField.leftViewMode = UITextFieldViewModeAlways;
        _navBarSearchTextField.layer.cornerRadius = 4.0;
        _navBarSearchTextField.layer.masksToBounds = YES;
        _navBarSearchTextField.returnKeyType = UIReturnKeySearch;
        _navBarSearchTextField.clearButtonMode = UITextFieldViewModeAlways;
        _navBarSearchTextField.layer.borderColor=[UIColor colorWithRed:0.7608 green:0.7608 blue:0.7608 alpha:1].CGColor;
        _navBarSearchTextField.layer.borderWidth= 1.0f;
        _navBarSearchTextField.delegate = self;
    }
    _navBarSearchTextField.frame = CGRectMake(70, 35, 250, 20);
    return _navBarSearchTextField;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.segmentView.bottom, kMainScreenWidth, kMainScreenHeight - self.segmentView.bottom - 55) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = view;
    }
    return _tableView;
}

- (YHBSegmentView *)segmentView
{
    if (_segmentView == nil) {
        _segmentView = [[YHBSegmentView alloc] initWithFrame:CGRectMake(0, 80, kMainScreenWidth - 86, 20) style:YHBSegmentViewStyleNormal];
        _segmentView.titleArray = self.titleArray;
        
        [_segmentView addTarget:self action:@selector(segmentViewValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentView;
}

#pragma mark - evnet response
- (void)segmentViewValueDidChanged:(YHBSegmentView *)sender
{
    _selTag = sender.selectItem;
    if (self.modelsDic[[NSString stringWithFormat:@"%lu",_selTag]] != nil) {
        
        [self.tableView reloadData];
    }else{
       // [self getFirstPageData];
    }
}

- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@"综合",@"销量",@"价格"];
    }
    return _titleArray;
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
