//
//  ProductViewController.m
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/21.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "StoreViewController.h"
#import "YHBSegmentView.h"
#import "CategoryViewController.h"
#import "SVPullToRefresh.h"
#import "ProductDetailViewController.h"
#import "DropDownChooseProtocol.h"
#import "DropDownListView.h"
#import "StoreModel.h"
#import "StoreListTableViewCell.h"
#import "IndustryModel.h"

typedef enum : long {
    Get_All = 0,
    GEt_hot,
} GetPrivateTag;

@interface  StoreViewController  ()<UIScrollViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,YHBSegmentViewDelegate,DropDownChooseDelegate,DropDownChooseDataSource>
{
    GetPrivateTag _selTag;
    int pagesize;
    int pageId;
    int pagetotal;
    NSMutableArray *chooseArray ;
}

@property (strong, nonatomic) UIView *searchView;
@property (strong, nonatomic) UITextField *searchTextField;
@property (strong, nonatomic) UIButton *searchBtn;
@property (strong, nonatomic) YHBSegmentView *segmentView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSMutableArray *modelArray;
@property (nonatomic, strong) UIButton *scrollToTopButton;
@property (strong, nonatomic) NSMutableArray *IndustryIdArray;
@property (strong, nonatomic) NSMutableArray *IndustryNameArray;
@end

@implementation StoreViewController

-(void)back
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _selTag = Get_All;
    UIButton *back =[[UIButton alloc]initWithFrame:CGRectMake(20,30, 30, 30)];
    [back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    [self getIndustrydata];
    chooseArray = [NSMutableArray arrayWithArray:@[@[@"暂无"]]];
    DropDownListView * dropDownView = [[DropDownListView alloc] initWithFrame:CGRectMake(kMainScreenWidth - 95,80, (kMainScreenWidth - 86)/3, 20) dataSource:self delegate:self];
    dropDownView.mSuperView = self.view;
    [self.view addSubview:dropDownView];
    [self.view addSubview:back];
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.tableView];
    [self getFirstPageData];
    [self addScrollToTopButton];
    [self addTableViewTrag:self.catIds];
    [self.view addSubview:self.searchView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeScrollToTopButton];
}

-(void)getIndustrydata
{
    NSString *adverturl= nil;
    kYHBRequestUrl(@"store/open/getIndustry", adverturl);
    [NetworkService postWithURL:adverturl paramters:nil success:^(NSData *receiveData) {
        if (receiveData.length>0) {
            id result=[NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
            if([result isKindOfClass:[NSDictionary class]])
            {
                _IndustryIdArray = [NSMutableArray array];
                _IndustryNameArray = [NSMutableArray array];
                NSMutableArray *industry =result[@"RESULT"];
            for (NSInteger i=0; i<industry.count; i++) {
                IndustryModel *model =[[IndustryModel alloc]init];
                [model setValuesForKeysWithDictionary:industry[i]];
                [_IndustryIdArray addObject:model.industryId];
                [_IndustryNameArray addObject:model.industryName];
                }
            }
            chooseArray = [NSMutableArray arrayWithArray:@[_IndustryNameArray]];
        }
    }failure:^(NSError *error){
        NSLog(@"下载数据失败");
    }];
}

#pragma mark 网络请求
- (void)getDataWithPageID:(NSInteger)pageid catIds:(NSArray *)catIds
{
    pageId = 1;
    pagesize = 5;
    NSMutableDictionary *dict;
    NSString *url= nil;
    kYHBRequestUrl(@"store/open/storeList", url);
    GetPrivateTag tag = _selTag;
    switch (tag) {
        case Get_All:
        {
            if (catIds != nil) {
                NSString *catIdsStr = @"";
                for (NSNumber *number in catIds) {
                    catIdsStr = [catIdsStr stringByAppendingFormat:@"|%@", number];
                }
                catIdsStr = [catIdsStr substringFromIndex:1];
                if ([_searchTextField.text isEqualToString:@""]||_searchTextField.text ==nil) {
                    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex",catIdsStr,@"industryId", nil];
                }else{
                    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex", _searchTextField.text,@"storeName",catIdsStr,@"industryId",nil];
                }
            }
            else
            {
                if ([_searchTextField.text isEqualToString:@""]||_searchTextField.text ==nil)
                {
                dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex", nil];
                }else
                {
                dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex", _searchTextField.text,@"storeName",nil];
                }
            }
        }
            break;
        case GEt_hot:
            if (catIds != nil) {
                NSString *catIdsStr = @"";
                for (NSNumber *number in catIds) {
                    catIdsStr = [catIdsStr stringByAppendingFormat:@"|%@", number];
                }
                catIdsStr = [catIdsStr substringFromIndex:1];
                dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex",@"attention_people_count",@"order",catIdsStr,@"industryId",@"desc",@"direction", nil];
            }else
            {
                dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex",@"attention_people_count",@"order",@"desc",@"direction",nil];
            }
            break;
        default:
            break;
    }
   // NSLog(@"dict=%@,url=%@",dict,url);
    [NetworkService postWithURL:url paramters:dict success:^(NSData *receiveData) {
        if (receiveData.length>0) {
            id result=[NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
             //NSLog(@"result=%@",result);
            if([result isKindOfClass:[NSDictionary class]])
            {
                NSArray *array = result[@"RESULT"];
                pagetotal = [result[@"RESPCODE"]intValue];
                _modelArray = [NSMutableArray array];
                for (NSDictionary *subdic in array) {
                    StoreModel *model = [[StoreModel alloc] init];
                    [model setValuesForKeysWithDictionary:subdic];
                    [_modelArray addObject:model];
                }
                [self.tableView reloadData];
            }
        }
    }failure:^(NSError *error){
        NSLog(@"下载数据失败");
    }];
}

- (void)addTableViewTrag:(NSArray *)catIds
{
    __weak  StoreViewController  *weakself = self;
    [weakself.tableView addPullToRefreshWithActionHandler:^{
        [weakself.tableView.pullToRefreshView stopAnimating];
        //self.catIds = nil;
        [self getFirstPageData];
    }];
    [weakself.tableView addInfiniteScrollingWithActionHandler:^{
        [weakself.tableView.infiniteScrollingView stopAnimating];
        pageId++;
        if (pagesize*pageId<pagetotal)
        {
            NSMutableDictionary *dict;
            NSString *url= nil;
            GetPrivateTag tag = _selTag;
            kYHBRequestUrl(@"store/open/storeList", url);
            switch (tag) {
                case Get_All:
                {
                    if (self.catIds != nil) {//产业带不为空
                        NSString *catIdsStr = @"";
                        for (NSNumber *number in self.catIds) {
                            catIdsStr = [catIdsStr stringByAppendingFormat:@"|%@", number];
                        }
                        catIdsStr = [catIdsStr substringFromIndex:1];
                        if ([_searchTextField.text isEqualToString:@""]||_searchTextField.text ==nil) {//搜索为空
                            dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex",catIdsStr,@"industryId", nil];
                        }else{
                            dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex", _searchTextField.text,@"storeName",catIdsStr,@"industryId",nil];
                        }
                    }
                    else //产业带为空
                    {
                        if ([_searchTextField.text isEqualToString:@""]||_searchTextField.text ==nil)
                        { //搜索为空
                            dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex", nil];
                        }else
                        {
                            dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex", _searchTextField.text,@"storeName",nil];
                        }
                    }
                }
                    break;
                case GEt_hot:
                    if (catIds != nil) {
                        NSString *catIdsStr = @"";
                        for (NSNumber *number in catIds) {
                            catIdsStr = [catIdsStr stringByAppendingFormat:@"|%@", number];
                        }
                        catIdsStr = [catIdsStr substringFromIndex:1];
                        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex",@"attention_people_count",@"order",catIdsStr,@"industryId",@"desc",@"direction",nil];
                    }else
                    {
                        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex",@"attention_people_count",@"order",@"desc",@"direction",nil];
                    }
                    break;
                default:
                    break;
            }
            //NSLog(@"店铺下拉dict=%@",dict);
            [NetworkService postWithURL:url paramters:dict success:^(NSData *receiveData) {
                if (receiveData.length>0) {
                    id result=[NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
                    if([result isKindOfClass:[NSDictionary class]])
                    {
                        NSArray *array = result[@"RESULT"];
                        for (NSDictionary *subdic in array) {
                            StoreModel *model = [[StoreModel alloc] init];
                            [model setValuesForKeysWithDictionary:subdic];
                            [_modelArray addObject:model];
                        }
                        [self.tableView reloadData];
                    }
                }
            }failure:^(NSError *error){
                NSLog(@"下载数据失败");
            }];
        }
    }];
}

- (void)getFirstPageData
{
    [self getDataWithPageID:_selTag catIds:self.catIds];
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark 数据行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

#pragma mark 每行显示内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"store";
    StoreListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[StoreListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    StoreModel *model = _modelArray[indexPath.row];
    NSString *imageurl =nil;
    kZXYRequestUrl(model.logo, imageurl);
    [cell setUIWithImage:imageurl amount:@"99" Title:model.storeName attention:@"99" Type:[model.authenticationType integerValue]];
    return cell;
}

#pragma mark 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreModel *model = _modelArray[indexPath.row];
    NSLog(@"店铺ID＝%@",model.storeId);
//    ProductDetailViewController *vc = [[ProductDetailViewController alloc] initWithProductID:model.storeId];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (UIView *)searchView
{
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(50, 25, kMainScreenWidth, 40)];
        _searchView.backgroundColor = [UIColor whiteColor];
        
        UITextField *searchTf = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, kMainScreenWidth-130, 30)];
        [searchTf setBorderStyle:UITextBorderStyleRoundedRect];
        searchTf.placeholder = @"请输入关键字";
        [searchTf setClearButtonMode:UITextFieldViewModeAlways];
        searchTf.delegate = self;
        [searchTf setReturnKeyType:UIReturnKeySearch];
        _searchTextField = searchTf;
        _searchTextField.delegate =self;
        [_searchView addSubview:searchTf];
        _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(searchTf.right+2, searchTf.top, 50, searchTf.height)];
        [_searchBtn setBackgroundColor:[UIColor clearColor]];
        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        _searchBtn.titleLabel.font = kFont16;
        [_searchBtn addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_searchView addSubview:_searchBtn];
    }
    return _searchView;
}

- (void)searchButtonClick:(UIButton *)sender
{
    [_segmentView changeSelect:0];
    if ([_searchTextField.text isEqualToString:@""]||_searchTextField.text ==nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请输入关键词" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else
    {
        [_searchTextField resignFirstResponder];
        [self refreshData];
    }
}

- (void)refreshData
{
    pageId = 1;
    pagesize = 5;
    NSMutableDictionary *dict;
    NSString *url= nil;
    kYHBRequestUrl(@"store/open/storeList", url);
    if (self.catIds != nil) {
        NSString *catIdsStr = @"";
        for (NSNumber *number in self.catIds) {
            catIdsStr = [catIdsStr stringByAppendingFormat:@"|%@", number];
        }
        catIdsStr = [catIdsStr substringFromIndex:1];
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex", _searchTextField.text,@"storeName",catIdsStr,@"industryId",nil];
    }else
    {
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex", _searchTextField.text,@"storeName",nil];
    }
    //NSLog(@"搜索dict=%@",dict);
    [NetworkService postWithURL:url paramters:dict success:^(NSData *receiveData) {
        if (receiveData.length>0) {
            id result=[NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
            // NSLog(@"result=%@",result);
            if([result isKindOfClass:[NSDictionary class]])
            {
                NSArray *array = result[@"RESULT"];
                pagetotal = [result[@"RESPCODE"]intValue];
                _modelArray = [NSMutableArray array];
                for (NSDictionary *subdic in array) {
                    StoreModel *model = [[StoreModel alloc] init];
                    [model setValuesForKeysWithDictionary:subdic];
                    [_modelArray addObject:model];
                }
                [self.tableView reloadData];
            }
        }
    }failure:^(NSError *error){
        NSLog(@"下载数据失败");
    }];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.segmentView.bottom, kMainScreenWidth, kMainScreenHeight - self.segmentView.bottom) style:UITableViewStylePlain];
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
        _segmentView = [[YHBSegmentView alloc] initWithFrame:CGRectMake(0, 80, kMainScreenWidth - 95, 20) style:YHBSegmentViewStyleNormalStore];
        _segmentView.titleArray = self.titleArray;
        _segmentView.segmentViewDelegate = self;
        [_segmentView addTarget:self action:@selector(segmentViewValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentView;
}

#pragma mark - evnet response
- (void)segmentViewValueDidChanged:(YHBSegmentView *)sender
{
    _selTag = sender.selectItem;
    //self.catIds = nil;
    [self getFirstPageData];
}

- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@"综合",@"热门"];
    }
    return _titleArray;
}

-(void)addScrollToTopButton
{
    _scrollToTopButton = [[UIButton alloc] initWithFrame:CGRectMake(self.navigationController.view.frame.size.width - 50 - 20, self.navigationController.view.frame.size.height - 50 - 30, 50, 50)];
    [_scrollToTopButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [_scrollToTopButton addTarget:self action:@selector(scrollToTop) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:_scrollToTopButton];
    _scrollToTopButton.hidden = YES;
}

-(void)scrollToTop
{
    if (self.tableView.contentSize.height <= self.tableView.frame.size.height)
    {
        return;
    }
    else
    {
        [self.tableView setContentOffset:CGPointZero animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= 300.f)
    {
        _scrollToTopButton.hidden = NO;
    }
    else{
        _scrollToTopButton.hidden = YES;
    }
}

-(void)removeScrollToTopButton
{
    [_scrollToTopButton removeFromSuperview];
    _scrollToTopButton = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- dropDownListDelegate
-(void) chooseAtSection:(NSInteger)section index:(NSInteger)index
{
    NSMutableArray *array = [NSMutableArray arrayWithObjects:_IndustryIdArray[index], nil];
    self.catIds = array;
    [self getDataWithPageID:_selTag catIds:self.catIds];
}

#pragma mark -- dropdownList DataSource
-(NSInteger)numberOfSections
{
    return [chooseArray count];
}

-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    NSArray *arry =chooseArray[section];
    return [arry count];
}

-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index
{
    return chooseArray[section][index];
}

-(NSInteger)defaultShowSection:(NSInteger)section
{
    return 0;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_searchTextField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchButtonClick:_searchBtn];
    return YES;// 表示允许使用return键 
}
@end
