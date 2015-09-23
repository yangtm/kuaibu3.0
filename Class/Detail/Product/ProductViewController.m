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
#import "YHBProductListsCell.h"
#import "ProductModel.h"
#import "SVPullToRefresh.h"
#import "ProductDetailViewController.h"

typedef enum : long {
    Get_All = 0,
    Get_Amount,
    Get_Price,
} GetPrivateTag;

@interface ProductViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,YHBSegmentViewDelegate>
{
    GetPrivateTag _selTag;
    int pagesize;
    int pageId;
    int pagetotal;
}

@property (strong, nonatomic) UITextField *navBarSearchTextField;
@property (strong, nonatomic) YHBSegmentView *segmentView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *titleArray;
@property (nonatomic, strong) NSArray *catIds;
@property (strong, nonatomic) NSMutableDictionary *modelsDic;//数据字典-存放数据模型数组 key为tag
@property (strong, nonatomic) NSMutableDictionary *pageDic;
@property (strong, nonatomic) NSMutableArray *modelArray;
@property (nonatomic, strong) UIButton *scrollToTopButton;

@end

@implementation ProductViewController

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
    UIButton *select = [[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth - 86, 80, (kMainScreenWidth - 86)/3, 20)];
    [select setTitle:@"筛选" forState:UIControlStateNormal];
    [select setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [select addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:select];
    [self.view addSubview:back];
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.tableView];
    [self getFirstPageData];
    [self addScrollToTopButton];
    [self addTableViewTrag:self.catIds];
    [self.view addSubview:self.navBarSearchTextField];
}

#pragma mark 网络请求
- (void)getDataWithPageID:(NSInteger)pageid catIds:(NSArray *)catIds
{
    pageId = 1;
    pagesize = 10;
    NSMutableDictionary *dict;
    NSString *url= nil;
    kYHBRequestUrl(@"product/open/searchProduct", url);
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
                NSString *allConditions = [NSString stringWithFormat:@"categoryId:%@",catIdsStr];
                dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex",allConditions,@"allConditions", nil];
            }else
            {
                dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex", nil];
            }
        }
            break;
        case Get_Amount:
            if (catIds != nil) {
                NSString *catIdsStr = @"";
                for (NSNumber *number in catIds) {
                    catIdsStr = [catIdsStr stringByAppendingFormat:@"|%@", number];
                }
                catIdsStr = [catIdsStr substringFromIndex:1];
                NSString *allConditions = [NSString stringWithFormat:@"categoryId:%@",catIdsStr];
                dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex",@"sales_amount.desc",@"orderBy",allConditions,@"allConditions", nil];
            }else
            {
                dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex",@"sales_amount.desc",@"orderBy",nil];
            }
            break;
        case Get_Price:
        {
            NSLog(@"");
            if (catIds != nil) {
                NSString *catIdsStr = @"";
                for (NSNumber *number in catIds) {
                    catIdsStr = [catIdsStr stringByAppendingFormat:@"|%@", number];
                }
                catIdsStr = [catIdsStr substringFromIndex:1];
                NSString *allConditions = [NSString stringWithFormat:@"categoryId:%@",catIdsStr];
                if (_segmentView.price) {
                    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex",@"price.desc",@"orderBy",allConditions,@"allConditions", nil];
                }else
                {
                    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex",@"price.asc",@"orderBy",allConditions,@"allConditions", nil];
                }
            }else
            {
                if (_segmentView.price) {
                    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex",@"price.desc",@"orderBy",nil];
                }else
                {
                    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex",@"price.asc",@"orderBy",nil];
                }
            }
        }
            break;
        default:
            break;
    }
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
                    ProductModel *model = [[ProductModel alloc] init];
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
    __weak ProductViewController *weakself = self;
    [weakself.tableView addPullToRefreshWithActionHandler:^{
        [weakself.tableView.pullToRefreshView stopAnimating];
        [self getFirstPageData];
    }];
    [weakself.tableView addInfiniteScrollingWithActionHandler:^{
     [weakself.tableView.infiniteScrollingView stopAnimating];
        pageId++;
        if (pagesize*pageId<pagetotal)
        {
            NSMutableDictionary *dict;
            if (catIds != nil) {
                NSString *catIdsStr = @"";
                for (NSNumber *number in catIds) {
                    catIdsStr = [catIdsStr stringByAppendingFormat:@"|%@", number];
                }
                catIdsStr = [catIdsStr substringFromIndex:1];
                NSString *allConditions = [NSString stringWithFormat:@"categoryId:%@",catIdsStr];
                dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex",allConditions,@"allConditions", nil];
            }else
            {
                dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex", nil];
            }
            NSString *url= nil;
            GetPrivateTag tag = _selTag;
            kYHBRequestUrl(@"product/open/searchProduct", url);
            switch (tag) {
                case Get_All:
                {
                    if (catIds != nil) {
                        NSString *catIdsStr = @"";
                        for (NSNumber *number in catIds) {
                            catIdsStr = [catIdsStr stringByAppendingFormat:@"|%@", number];
                        }
                        catIdsStr = [catIdsStr substringFromIndex:1];
                        NSString *allConditions = [NSString stringWithFormat:@"categoryId:%@",catIdsStr];
                        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex",allConditions,@"allConditions", nil];
                    }else
                    {
                        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex", nil];
                    }
                }
                    break;
                case Get_Amount:
                    if (catIds != nil) {
                        NSString *catIdsStr = @"";
                        for (NSNumber *number in catIds) {
                            catIdsStr = [catIdsStr stringByAppendingFormat:@"|%@", number];
                        }
                        catIdsStr = [catIdsStr substringFromIndex:1];
                        NSString *allConditions = [NSString stringWithFormat:@"categoryId:%@",catIdsStr];
                        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex",@"sales_amount.desc",@"orderBy",allConditions,@"allConditions", nil];
                    }else
                    {
                        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex",@"sales_amount.desc",@"orderBy",nil];
                    }
                    break;
                case Get_Price:
                {
                    NSLog(@"");
                    if (catIds != nil) {
                        NSString *catIdsStr = @"";
                        for (NSNumber *number in catIds) {
                            catIdsStr = [catIdsStr stringByAppendingFormat:@"|%@", number];
                        }
                        catIdsStr = [catIdsStr substringFromIndex:1];
                        NSString *allConditions = [NSString stringWithFormat:@"categoryId:%@",catIdsStr];
                        if (_segmentView.price) {
                            dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex",@"price.desc",@"orderBy",allConditions,@"allConditions", nil];
                        }else
                        {
                            dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex",@"price.asc",@"orderBy",allConditions,@"allConditions", nil];
                        }
                    }else
                    {
                        if (_segmentView.price)
                        {
                            dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex",@"price.desc",@"orderBy",nil];
                        }else
                        {
                            dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageId],@"pageIndex",@"price.asc",@"orderBy",nil];
                        }
                    }
                }
                    break;
                default:
                    break;
            }
            [NetworkService postWithURL:url paramters:dict success:^(NSData *receiveData) {
                if (receiveData.length>0)
                {
                    id result=[NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
                    if([result isKindOfClass:[NSDictionary class]])
                    {
                        NSArray *array = result[@"RESULT"];
                        for (NSDictionary *subdic in array) {
                            ProductModel *model = [[ProductModel alloc] init];
                            [model setValuesForKeysWithDictionary:subdic];
                            [_modelArray addObject:model];
                        }
                        [self.tableView reloadData];
                    }
                }
            }failure:^(NSError *error){
            [weakself.tableView.pullToRefreshView stopAnimating];
        }];
      }
    }];
}

- (void)getFirstPageData
{
    [self getDataWithPageID:_selTag catIds:self.catIds];
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
      [self getDataWithPageID:_selTag catIds:self.catIds];
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
    return _modelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark 每行显示内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSMutableArray *dataArray = self.modelsDic[[NSString stringWithFormat:@"%lu",_selTag]];
    static NSString *cellIdentifier = @"product";
    YHBProductListsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YHBProductListsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ProductModel *model = _modelArray[indexPath.row];
    NSString *imageurl =nil;
    kZXYRequestUrl(model.productImage, imageurl);
    [cell setUIWithImage:imageurl Title:model.productName Price:model.price Type:[model.authenticationType integerValue]];
    return cell;
}

#pragma mark 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductModel *model = _modelArray[indexPath.row];
    ProductDetailViewController *vc = [[ProductDetailViewController alloc] initWithProductID:model.productId];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
        _segmentView = [[YHBSegmentView alloc] initWithFrame:CGRectMake(0, 80, kMainScreenWidth - 86, 20) style:YHBSegmentViewStyleNormal];
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
    [self getFirstPageData];
}

- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@"综合",@"销量",@"价格"];
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


@end
