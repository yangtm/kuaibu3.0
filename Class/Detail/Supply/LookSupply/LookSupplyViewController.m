//
//  LookSupplyViewController.m
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/15.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "LookSupplyViewController.h"
#import "SVPullToRefresh.h"
#import "YHBSegmentView.h"
#import "Public.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "LookBuyAllShowCell.h"
#import "MyLookBuyShowCell.h"

#define topViewHeight 40

@interface LookSupplyViewController ()<UIScrollViewDelegate,AVAudioPlayerDelegate,UITableViewDataSource, UITableViewDelegate>
{
    BOOL _isVip;
    int  _typeid;
}
@property(nonatomic, strong) UIButton *selectAllBtn;
@property(nonatomic, strong) UIButton *selectVipBtn;

@property (nonatomic, strong) YHBSegmentView *segmentView;
@property (nonatomic, strong) UITableView *supplyTableView;

//@property (nonatomic, strong) YHBLookBuyManage *buyManage;
//@property (nonatomic, strong) YHBSupplyDataSource *dataSource;
@property (nonatomic, strong) NSMutableArray *tableViewArray;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSArray *catIds;
@property (nonatomic, assign) BOOL isAll;
@property (nonatomic, strong) NSIndexPath *playSoundIndexPath;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) UIButton *scrollToTopButton;
@end

@implementation LookSupplyViewController

- (instancetype)initWithIsSupply:(BOOL)aIsSupply
{
    if (self = [super init]) {
        _typeid = 0;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    _isVip = NO;
    _page = 1;
    self.title =@"查看采购";
    //[self setRightButton:nil title:@"筛选" target:self action:@selector(rightBarButtonClick:)];
    
    self.supplyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    if (app.isLoginedIn) {
        self.supplyTableView.tableHeaderView = self.segmentView;
    }
    
    self.supplyTableView.delegate = self;
    self.supplyTableView.dataSource = self;
    self.supplyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.supplyTableView];
    
    _isAll = YES;
    
    //[self addTableViewTrag];
    //[self showFlower];
    [self getData];
    [self addScrollToTopButton];
}
- (void)addTableViewTrag
{
    __weak LookSupplyViewController *weakself = self;
    [weakself.supplyTableView addPullToRefreshWithActionHandler:^{
            if (_isAll) {
                [self stopPlaySound];
                NSString *url = nil;
                kYHBRequestUrl(@"procurement/open/getProcurementList", url);
                NSLog(@"*******%@",url);
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(_page),@"pageIndex", nil];
                
                [NetworkService postWithURL:url paramters:dic success:^(NSData *receiveData) {
                    id result = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
                    
                    if ([result isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dic = result;
                        NSLog(@"result:%@",dic);
//                        NSArray *array = dic[@"RESULT"];
//                        for (NSDictionary *subDic in array) {
//                            ProcurementModel *model = [[ProcurementModel alloc] init];
//                            model.amount = [subDic[@"amount"] doubleValue];
//                            model.offerLastDate = subDic[@"offerLastDate"];
//                            model.takeDeliveryLastDate = subDic[@"lastModifyDatetime"];
//                            model.procurementId = subDic[@"procurementId"];
//                            [_dataArray addObject:model];
//                        }
                        [weakself.supplyTableView reloadData];
                        _page++;
                    }
                } failure:^(NSError *error) {
                    NSLog(@"%@",error);
                }];
            }
            else{
//                _pageId = 1;
//                [[KBServiceEngine shareInstance] getRelatedBuyWithSort:@"" pageId:_pageId size:20 successBk:^(id result) {
//                    
//                    [self.supplyTableView.pullToRefreshView stopAnimating];
//                    _tableViewArray = [NSMutableArray arrayWithArray:result];
//                    [self.supplyTableView reloadData];
//                    _pageId++;
//                    
//                } failureBk:^(NSString *error) {
//                    
//                }];
            }
        
    }];
    
    
    [weakself.supplyTableView addInfiniteScrollingWithActionHandler:^{
//        if (self.dataSource.hasMore) {
//                if (_isAll) {
//                    [self.buyManage getNextBuyArrayWithKeyword:_keyword typeId:_typeid complete:^(YHBSupplyDataSource *dataSource) {
//                        
//                        [weakself.supplyTableView.infiniteScrollingView stopAnimating];
//                        self.dataSource = dataSource;
//                        [self.supplyTableView reloadData];
//                    } andFail:^(NSString *aStr) {
//                        [weakself.supplyTableView.infiniteScrollingView stopAnimating];
//                    }];
//                }
//                else{
//                    [[KBServiceEngine shareInstance] getRelatedBuyWithSort:@"" pageId:_pageId size:20 successBk:^(id result) {
//                        
//                        [self.supplyTableView.infiniteScrollingView stopAnimating];
//                        [_tableViewArray addObjectsFromArray:result];
//                        [self.supplyTableView reloadData];
//                        _pageId++;
//                        
//                    } failureBk:^(NSString *error) {
//                        
//                    }];
//            }
//        }
//        else{
//            [weakself.supplyTableView.infiniteScrollingView stopAnimating];
//        }
    }];
}

- (void)getData
{
    if (_isAll) {
        NSString *url = nil;
        kYHBRequestUrl(@"procurement/open/getProcurementList", url);
        NSLog(@"%@",url);
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(_page),@"pageIndex", nil];
        
        [NetworkService postWithURL:url paramters:dic success:^(NSData *receiveData) {
            [self dismissFlower];
            id result = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = result;
                NSLog(@"result:%@",dic);
                //                        NSArray *array = dic[@"RESULT"];
                //                        for (NSDictionary *subDic in array) {
                //                            ProcurementModel *model = [[ProcurementModel alloc] init];
                //                            model.amount = [subDic[@"amount"] doubleValue];
                //                            model.offerLastDate = subDic[@"offerLastDate"];
                //                            model.takeDeliveryLastDate = subDic[@"lastModifyDatetime"];
                //                            model.procurementId = subDic[@"procurementId"];
                //                            [_dataArray addObject:model];
                //                        }
                [self.supplyTableView reloadData];
                _page++;
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [self dismissFlower];
        }];
;
    }
    else{
//        _page = 1;
//        [[KBServiceEngine shareInstance] getRelatedBuyWithSort:@"" pageId:_pageId size:20 successBk:^(id result) {
//            
//            [self dismissFlower];
//            _tableViewArray = [NSMutableArray arrayWithArray:result];
//            [self.supplyTableView reloadData];
//            _page++;
//            
//        } failureBk:^(NSString *error) {
//            
//        }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"查看采购"];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self dismissFlower];
    
    [self stopPlaySound];
    
    [MobClick endLogPageView:@"查看采购"];
   
    [self removeScrollToTopButton];
}
#pragma mark - setters and getters
- (YHBSegmentView *)segmentView
{
    if (_segmentView == nil) {
        YHBSegmentViewStyle style;
        NSArray *titleArray;
        CGRect rect;
            style = YHBSegmentViewStyleArrow;
            titleArray = @[@"全部采购", @"我的关注"];
            rect = CGRectMake(0, 0, kMainScreenWidth, 25);
        _segmentView = [[YHBSegmentView alloc] initWithFrame:rect style:style];
        _segmentView.titleArray = titleArray;
        [_segmentView addTarget:self action:@selector(segmentViewDidValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentView;
}

- (void)segmentViewDidValueChanged:(YHBSegmentView *)sender
{
    _typeid = (int)sender.selectItem;
        if (sender.selectItem == 0) {
            _isAll = YES;
            [self setRightButtonActive];
        }
        else if (sender.selectItem == 1){
            [self setRightButtonUnAcitve];
            [self stopPlaySound];
            _isAll = NO;
        }
    [self showFlower];
   // [self getData];
}

- (void)setRightButtonUnAcitve
{
    [self.rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.rightButton.userInteractionEnabled = NO;
}

- (void)setRightButtonActive
{
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.rightButton.userInteractionEnabled = YES;
}

-(void)removeScrollToTopButton
{
    [_scrollToTopButton removeFromSuperview];
    _scrollToTopButton = nil;
}

- (void)stopPlaySound
{
    if (_isPlaying) {
        [_audioPlayer stop];
        LookBuyAllShowCell *cell = (LookBuyAllShowCell *)[_supplyTableView cellForRowAtIndexPath:_playSoundIndexPath];
        //cell.isPlay = NO;
        _isPlaying = NO;
        _playSoundIndexPath = nil;
    }
}

- (void)showFlower
{
    [SVProgressHUD show:YES offsetY:kMainScreenHeight/2.0];
}

- (void)dismissFlower
{
    [SVProgressHUD dismiss];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= 300.f) {
        _scrollToTopButton.hidden = NO;
    }
    else{
        _scrollToTopButton.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isAll){
        MyLookBuyShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        if (cell == nil) {
            cell = [[MyLookBuyShowCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else{
        LookBuyAllShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        if (cell == nil) {
            cell = [[LookBuyAllShowCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    if (self.supplyTableView.contentSize.height <= self.supplyTableView.frame.size.height)
    {
        return;
    }
    else
    {
        [self.supplyTableView setContentOffset:CGPointZero animated:YES];
    }
}


@end