//
//  CateViewController.m
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/25.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "CateViewController.h"
#import "CategoryCell.h"
#import "YHBCatSubcate.h"
#import "YHBCatManage.h"
#import "LSNavigationController.h"
#import "TitleCell.h"
#import "YHBCatData.h"
#import "ProductViewController.h"

NSString *const CategoryCellId = @"CategoryCellId";
NSString *const TitleCellId = @"CategoryCellId";

@interface CateViewController ()<UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) YHBCatManage *manager;
@property (assign, nonatomic) NSInteger selectCate;
@property (assign, nonatomic) BOOL multiSelect;
@property (strong, nonatomic) NSArray *selectedArray;
@property (strong, nonatomic) NSMutableArray *cateArray;

@end

@implementation CateViewController

- (instancetype)initWithSelectdItems:(NSArray *)itemArray multiSelect:(BOOL)multiSelect
{
    self = [super init];
    if (self) {
        _selectedArray = itemArray;
        _multiSelect = multiSelect;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshData];
    [_tableView registerClass:[TitleCell class] forCellReuseIdentifier:TitleCellId];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
   [_collectionView registerNib:[UINib nibWithNibName:@"CategoryCell" bundle:nil] forCellWithReuseIdentifier:CategoryCellId];
    //_tableView.backgroundColor = [UIColor redColor];
}

- (void)refreshData
{
    [self.manager getDataArraySuccBlock:^(NSMutableArray *aArray) {
        _dataArray = [[NSMutableArray alloc]init];
        _cateArray= [[NSMutableArray alloc]init];
//        NSLog(@"_dataArray.count=%lu",aArray.count);
       // NSLog(@"data=%@",aArray[0]);
        for (int i=0; i<aArray.count; i++) {
            YHBCatData *model=aArray[i];
            [_dataArray addObject:model.categoryName];
            [_cateArray addObject:model.children];
        }
        [_tableView reloadData];
        //默认选中第一行
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        [_collectionView reloadData];
    } andFailBlock:^(NSString *aStr) {
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TitleCell *cell = (TitleCell *)[tableView dequeueReusableCellWithIdentifier:TitleCellId];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    cell.titleLabel.text = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    _selectCate = indexPath.row;
   // NSLog(@"_select=%lu",indexPath.row);
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
        NSMutableArray *select = _cateArray[_selectCate];
        //NSLog(@"select=%lu",select.count);
        return  select.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *collectionViewCell = nil;
    collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:CategoryCellId forIndexPath:indexPath];
    NSMutableArray *select = _cateArray[_selectCate];
    YHBCatData *subCatData = select[indexPath.row];
    ((CategoryCell *)collectionViewCell).titleLabel.text = subCatData.categoryName;
    
    return collectionViewCell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    CGFloat width = (_collectionView.width - 10) / 3.0;
    size = CGSizeMake(width, width/3);
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = CGSizeMake(0, 0);
    size = CGSizeMake(0, 10);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 20, 30, 50);//(上，左，下，右)
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *select = _cateArray[_selectCate];
    YHBCatData *subCatData = select[indexPath.row];
        if ([_delegate respondsToSelector:@selector(categoryViewController:selectCategory:)]) {
            [_delegate categoryViewController:self selectCategory:subCatData];
        }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - setters and getters
- (YHBCatManage *)manager
{
    if (_manager == nil) {
        _manager = [[YHBCatManage alloc] init];
    }
    return _manager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
