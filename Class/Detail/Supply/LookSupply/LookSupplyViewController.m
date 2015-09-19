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
#import "YHBSupplyDataSource.h"
#import "YHBLookBuyManage.h"
#import "YHBSupplyModel.h"
#import "UIImageView+WebCache.h"
#import "BuyDetailViewController.h"
#import "ProcurementModel.h"
#import "CategoryViewController.h"
#define topViewHeight 40

@interface LookSupplyViewController ()<UIScrollViewDelegate,AVAudioPlayerDelegate,UITableViewDataSource, UITableViewDelegate,LookBuyAllShowCellDelegate,MyLookBuyShowCellDelegate>
{
    BOOL _isVip;
    int  _typeid;
}
@property(nonatomic, strong) UIButton *selectAllBtn;
@property(nonatomic, strong) UIButton *selectVipBtn;

@property (nonatomic, strong) YHBSegmentView *segmentView;
@property (nonatomic, strong) UITableView *supplyTableView;

@property (nonatomic, strong) YHBLookBuyManage *buyManage;
@property (nonatomic, strong) YHBSupplyDataSource *dataSource;
//@property (nonatomic, strong) NSMutableArray *tableViewArray;
@property (nonatomic, assign) NSInteger pageId;

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
    self.title =@"查看采购";
    [self setRightButton:nil title:@"筛选" target:self action:@selector(rightBarButtonClick:)];
    
    self.supplyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight -64)];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    if (app.isLoginedIn) {
        self.supplyTableView.tableHeaderView = self.segmentView;
    }
    
    self.supplyTableView.delegate = self;
    self.supplyTableView.dataSource = self;
    self.supplyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.supplyTableView];
    
    _isAll = YES;
    
    [self addTableViewTrag];
    [self showFlower];
    [self getData];
    [self addScrollToTopButton];
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
        [self getData];
    }];
    [self presentViewController:navVc animated:YES completion:nil];
}

- (void)getData
{
    if (_isAll) {
        [self.buyManage getBuyArrayWithKeyword:_keyword typeId:_typeid catIds: self.catIds complete:^(YHBSupplyDataSource *dataSource) {
            
            [self dismissFlower];
            self.dataSource = dataSource;
            [self.supplyTableView reloadData];
        } andFail:^(NSString *aStr) {
            [self dismissFlower];
            [SVProgressHUD showErrorWithStatus:aStr cover:YES offsetY:kMainScreenHeight/2.0];
        } isVip:_isVip];
    }
    else{
        [self.buyManage getBuyArrayWithKeyword:@"my" typeId:_typeid catIds: self.catIds complete:^(YHBSupplyDataSource *dataSource) {
            
            [self dismissFlower];
            self.dataSource = dataSource;
            [self.supplyTableView reloadData];
        } andFail:^(NSString *aStr) {
            [self dismissFlower];
            [SVProgressHUD showErrorWithStatus:aStr cover:YES offsetY:kMainScreenHeight/2.0];
        } isVip:_isVip];    }
}

- (void)addTableViewTrag
{
    __weak LookSupplyViewController *weakself = self;
    [weakself.supplyTableView addPullToRefreshWithActionHandler:^{
            if (_isAll) {
                [self stopPlaySound];
                [self.buyManage getBuyArrayWithKeyword:_keyword typeId:_typeid  catIds:self.catIds complete:^(YHBSupplyDataSource *dataSource) {
                    [weakself.supplyTableView.pullToRefreshView stopAnimating];
                    self.dataSource = dataSource;
                    [self.supplyTableView reloadData];
                } andFail:^(NSString *aStr) {
                    [weakself.supplyTableView.pullToRefreshView stopAnimating];
                    [SVProgressHUD showErrorWithStatus:aStr cover:YES offsetY:kMainScreenHeight/2.0];
                } isVip:_isVip];
            }
            else{
                [self stopPlaySound];
                [self.buyManage getBuyArrayWithKeyword:@"my" typeId:_typeid  catIds:self.catIds complete:^(YHBSupplyDataSource *dataSource) {
                    [weakself.supplyTableView.pullToRefreshView stopAnimating];
                    self.dataSource = dataSource;
                    [self.supplyTableView reloadData];
                } andFail:^(NSString *aStr) {
                    [weakself.supplyTableView.pullToRefreshView stopAnimating];
                    [SVProgressHUD showErrorWithStatus:aStr cover:YES offsetY:kMainScreenHeight/2.0];
                } isVip:_isVip];
            }
    }];
    [weakself.supplyTableView addInfiniteScrollingWithActionHandler:^{
        if (self.dataSource.hasMore) {
                if (_isAll) {
                    [self.buyManage getNextBuyArrayWithKeyword:_keyword typeId:_typeid complete:^(YHBSupplyDataSource *dataSource) {
                        
                        [weakself.supplyTableView.infiniteScrollingView stopAnimating];
                        self.dataSource = dataSource;
                        [self.supplyTableView reloadData];
                    } andFail:^(NSString *aStr) {
                        [weakself.supplyTableView.infiniteScrollingView stopAnimating];
                    }];
                }
                else{
                    [self.buyManage getNextBuyArrayWithKeyword:@"my" typeId:_typeid complete:^(YHBSupplyDataSource *dataSource) {
                        
                        [weakself.supplyTableView.infiniteScrollingView stopAnimating];
                        self.dataSource = dataSource;
                        [self.supplyTableView reloadData];
                    } andFail:^(NSString *aStr) {
                        [weakself.supplyTableView.infiniteScrollingView stopAnimating];
                    }];
            }
        }
        else{
            [weakself.supplyTableView.infiniteScrollingView stopAnimating];
        }
    }];
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

-(YHBLookBuyManage *)buyManage
{
    if (!_buyManage) {
        _buyManage = [[YHBLookBuyManage alloc] init];
    }
    return _buyManage;
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
    [self getData];
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
        cell.isPlay = NO;
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
    return self.dataSource.numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource rowsOfSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (!_isAll){
        MyLookBuyShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        if (cell == nil) {
            cell = [[MyLookBuyShowCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
       [self configShowCell:cell indexPath:indexPath];
        return cell;
    }
    else{
        LookBuyAllShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        if (cell == nil) {
            cell = [[LookBuyAllShowCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
            cell.hasSound =YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        [self configAllShowCell:cell indexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YHBSupplyModel *model = nil;
    if (_isAll) {
        model = [self.dataSource objectForSection:indexPath.section andRow:indexPath.row];
    }
    else{
       // model = [self.tableViewArray objectAtIndex:indexPath.row];
        model = [self.dataSource objectForSection:indexPath.section andRow:indexPath.row];
    }
    BuyDetailViewController *vc = [[BuyDetailViewController alloc] init];
    vc.ListId = [model.procurementId integerValue];
    vc.procModel = (ProcurementModel *)model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)configAllShowCell:(LookBuyAllShowCell *)cell indexPath:(NSIndexPath *)indexPath
{
    YHBSupplyModel *model = [self.dataSource objectForSection:indexPath.section andRow:indexPath.row];
    //[cell.rightImageView sd_setImageWithURL:[NSURL URLWithString:model.imageurl]];
    cell.titleLabel.text = model.productName;
    [cell configWithAmount:[NSString stringWithFormat:@"%0.2f",model.amount] unit:model.amountUnit type:[model.procurementStatus integerValue]];
    cell.creatdateLabel.text = model.offerLastDate;
   
    if ([model.recording isEqualToString:@""] || model.recording == nil) {
        cell.hasSound = NO;
    }
    else{
        cell.hasSound = YES;
        if (_isPlaying && _playSoundIndexPath.row == indexPath.row) {
            cell.isPlay = YES;
        }
    }
}

- (void)configShowCell:(MyLookBuyShowCell *)cell indexPath:(NSIndexPath *)indexPath
{
    YHBSupplyModel *model = [self.dataSource objectForSection:indexPath.section andRow:indexPath.row];
   //[cell.rightImageView sd_setImageWithURL:[NSURL URLWithString:model.imageurl]];
    cell.titleLabel.text = model.productName;
    [cell configWithAmount:[NSString stringWithFormat:@"%0.2f",model.amount] storenum:@"20" unit:model.amountUnit type:[model.procurementStatus integerValue]];
    cell.creatdateLabel.text = model.offerLastDate;
    if ([model.recording isEqualToString:@""] || model.recording == nil) {
        cell.hasSound = NO;
    }
    else{
        cell.hasSound = YES;
        if (_isPlaying && _playSoundIndexPath.row == indexPath.row) {
            cell.isPlay = YES;
        }
    }
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

#pragma mark - YHBMySupplyAllShowCellDelegate
- (void)cellDidBeginPlaySound:(LookBuyAllShowCell *)cell
{
    NSLog(@"begin");
    NSIndexPath *indexPath = [_supplyTableView indexPathForCell:cell];
    
    YHBSupplyModel *model = nil;
    if (_isAll) {
        model = [self.dataSource objectForSection:indexPath.section andRow:indexPath.row];
    }
    else{
        model = [self.dataSource objectForSection:indexPath.section andRow:indexPath.row];
    }
    
    NSString *str = model.recording;
    str = [str substringFromIndex:1];
    NSString *url = [NSString stringWithFormat:@"%@%@", kYHBBaseUrl, str];
    //[self startPalySoundWithUrl:url];
    
    if (_playSoundIndexPath != nil) {
        LookBuyAllShowCell *prePlayCell = (LookBuyAllShowCell *)[_supplyTableView cellForRowAtIndexPath:_playSoundIndexPath];
        prePlayCell.isPlay = NO;
    }
    _playSoundIndexPath = [_supplyTableView indexPathForCell:cell];
    _isPlaying = YES;
}

- (void)cellDidEndPlaySound:(LookBuyAllShowCell *)cell
{
    [self stopPlaySound];
}

- (void)MycellDidBeginPlaySound:(MyLookBuyShowCell *)cell
{
//    NSLog(@"begin");
    NSIndexPath *indexPath = [_supplyTableView indexPathForCell:cell];
    
    YHBSupplyModel *model = nil;
    if (_isAll) {
        model = [self.dataSource objectForSection:indexPath.section andRow:indexPath.row];
    }
    else{
        model = [self.dataSource objectForSection:indexPath.section andRow:indexPath.row];
    }
    
    NSString *str = model.recording;
    str = [str substringFromIndex:1];
    NSString *url = [NSString stringWithFormat:@"%@%@", kYHBBaseUrl, str];
    //[self startPalySoundWithUrl:url];
    
    if (_playSoundIndexPath != nil) {
        MyLookBuyShowCell *prePlayCell = (MyLookBuyShowCell*)[_supplyTableView cellForRowAtIndexPath:_playSoundIndexPath];
        prePlayCell.isPlay = NO;
    }
    _playSoundIndexPath = [_supplyTableView indexPathForCell:cell];
    _isPlaying = YES;
}

- (void)MycellDidEndPlaySound:(MyLookBuyShowCell *)cell
{
    [self stopPlaySound];
}



@end