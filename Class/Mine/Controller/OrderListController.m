//
//  OrderListController.m
//  kuaibu
//
//  Created by 朱新余 on 15/9/25.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "OrderListController.h"
#import "ProgressHUD.h"
#import "OrderModel.h"
#import "OrderListCell.h"
#import "OrderHeaderView.h"
#import "OrderFooterView.h"

@interface OrderListController ()<UIScrollViewDelegate,MJRefreshBaseViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView *_scrollView;
    UIScrollView *_headerScrollView;
    
    
    NSArray *_titleArray;
    NSArray *_IDArray;
    NSMutableArray *_btnArray;
    
    NSMutableArray *_dataArray;
    NSMutableArray *_sectionArray;
    NSInteger _curPage;
}

@property (nonatomic,strong) UITableView *tableView;
@end

@implementation OrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settitleLabel:@"我的订单"];
    
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(back)];
    
    [self createHeaderView];
    [self createScrollView];
    [self prepareData];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)prepareData
{
    _curPage = 1;
    _dataArray = [NSMutableArray array];
    _sectionArray = [NSMutableArray array];
    
    [self createTableView];
}

-(void)createTableView
{
//    [self downloadData];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, kMainScreenWidth, kMainScreenHeight - 104) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    //下拉刷新，上拉加载
    _headerView = [MJRefreshHeaderView header];
    _headerView.delegate = self;
    _headerView.scrollView = self.tableView;
    
    _footerView = [MJRefreshFooterView footer];
    _footerView.delegate = self;
    _footerView.scrollView = self.tableView;
    
//    [_headerView beginRefreshing];
    
}

#pragma mark -创建标题栏的滚动视图
-(void)createHeaderView
{
    _titleArray = @[@"全部",@"待审核",@"待付款",@"待发货",@"待收货",@"待评价",@"退款中",@"已取消"];
    _IDArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _headerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, 40)];
    _headerScrollView.contentSize = CGSizeMake(kMainScreenWidth/5*_titleArray.count, 40);
    _headerScrollView.delegate = self;
    _headerScrollView.tag = 99;
    _headerScrollView.showsHorizontalScrollIndicator = NO;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 104, kMainScreenWidth, 1)];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view];
//    _headerScrollView.backgroundColor = kBackgroundColor;
    
    for (int i = 0 ; i<_titleArray.count; i++)
    {
        UIButton *btn = [MyUtil createButton:CGRectMake(kMainScreenWidth/5 *i, 0, kMainScreenWidth/5, 40) title:_titleArray[i] BtnImage:nil selectImageName:nil target:self action:@selector(titleBtnClick:)];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = [_IDArray[i] intValue];
        
        [_headerScrollView addSubview:btn];
    }
    [self.view addSubview:_headerScrollView];
    [_scrollView addSubview:_headerScrollView];
}

#pragma mark -创建整个页面的横向滚动视图
-(void)createScrollView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+40, kMainScreenWidth, kMainScreenHeight-64)];
    _scrollView.contentSize = CGSizeMake(_titleArray.count*kMainScreenWidth, kMainScreenHeight-64-40);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    
    
    NSArray *urlStringArray = @[];
    for (int i = 0; i<urlStringArray.count; i++)
    {
       
            
        
    }
    [self.view addSubview:_scrollView];

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger i = _scrollView.contentOffset.x/_scrollView.bounds.size.width;

    if (i<=1)
    {
        _headerScrollView.contentOffset = CGPointMake(0, 0);
    }
    //中间的标题随点击事件，移动到中间
    else if (i < _titleArray.count-2)
    {
        _headerScrollView.contentOffset = CGPointMake(-150+kMainScreenWidth/5*i, 0);
    }
    //后两个标题的位置不变
    else
    {
        _headerScrollView.contentOffset = CGPointMake(kMainScreenWidth/5*(_titleArray.count-1)-300, 0);
    }
    for (int j = 0; j < _titleArray.count; j++)
    {
        
        NSArray *btnArray = _headerScrollView.subviews;
        UIButton *subBtn = btnArray[j];
        
        if (j == i)
        {
            [subBtn setTitleColor:kBackgroundColor forState:UIControlStateNormal];
            subBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        }
        else
        {
            subBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [subBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 标签栏按钮的点击事件
-(void)titleBtnClick:(id)sender
{
    UIButton *newBtn = (UIButton *)sender;
    for (int i = 0; i<_titleArray.count; i++)
    {
        if ([newBtn.titleLabel.text isEqualToString:_titleArray[i]])
        {
            //前两个标题位置不变
            if (i<=1)
            {
                _headerScrollView.contentOffset = CGPointMake(0, 0);
            }
            //中间的标题随点击事件，移动到中间
            else if (i < _titleArray.count-2)
            {
                _headerScrollView.contentOffset = CGPointMake(-150+kMainScreenWidth/5*i, 0);
            }
            //后两个标题的位置不变
            else
            {
                _headerScrollView.contentOffset = CGPointMake(kMainScreenWidth/5*(_titleArray.count-1)-300, 0);
            }
            _scrollView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:arc4random_uniform(44) alpha:arc4random_uniform(10)];
            _scrollView.contentOffset = CGPointMake(kMainScreenWidth*i, 0);
            break;
        }
    }
    for (int j = 0; j < _titleArray.count; j++)
    {
        NSArray *btnArray = _headerScrollView.subviews;
        UIButton *subBtn = btnArray[j];
        
        [subBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        subBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    //将点击的btn变换属性
    [newBtn setTitleColor:kBackgroundColor forState:UIControlStateNormal];
    newBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
}


- (void)downloadData{
    
    _isLoading = YES;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(_curPage),@"indexPage", nil];
    
    [NetworkService postWithURL:nil paramters:dic success:^(NSData *receiveData) {
        if (_curPage == 1) {
            [_dataArray removeAllObjects];
        }
        id result = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
        //        NSLog(@"result::%@",result);
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = result;
        }
        
        _isLoading = NO;
        [_headerView endRefreshing];
        [_footerView endRefreshing];
        
    } failure:^(NSError *error) {
        _isLoading = NO;
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OrderHeaderView *headerView = [[OrderHeaderView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44)];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    OrderFooterView *footerView = [[OrderFooterView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 80)];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"OrderListCellid";
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"OrderListCell" owner:nil options:nil][0];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
  
  
    
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_isLoading)
    {
        return;
    }
    
    if (refreshView == _headerView)
    {
        _curPage = 1;
        [self downloadData];
        
    }
    if (refreshView == _footerView)
    {
        _curPage++;
        [self downloadData];
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
