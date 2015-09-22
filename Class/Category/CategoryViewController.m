//
//  CategoryViewController.m
//  YHB_Prj
//
//  Created by Johnny's on 15/1/15.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "CategoryViewController.h"
#import "SVProgressHUD.h"
#import "YHBCatManage.h"
#import "YHBCatData.h"
#import "YHBCatSubcate.h"
#import "CategoryCell.h"
#import "CategoryHeadView.h"

#define space 7
#define btnHeight 30

static NSString *const CategoryCellIdentifier = @"CategoryCellIdentifier";
static NSString *const CategoryHeadViewIdentifier = @"CategoryHeadViewIdentifier";
static NSString *const CategoryFooterViewIdentifier = @"CategoryFooterViewIdentifier";

@interface CategoryViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    YHBCatManage *manage;
    NSMutableArray *_chooseArray;
    UIButton *yesButton;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) void(^ myBlock)(NSArray *aArray);
@end

@implementation CategoryViewController

+ (CategoryViewController *)sharedInstancetype
{
    static CategoryViewController *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(236, 236, 236);
    self.title = @"筛选";
    
    [self setRightButton:nil title:@"完成" target:self action:@selector(rightBarButtonClick:)];
    [self setLeftButton:[UIImage imageNamed:@"back"] title:@"" target:self action:@selector(backButtonClikc:)];
    
    [self.view addSubview:self.collectionView];
    
    _chooseArray = [NSMutableArray array];
    
    [self showFlower];
    manage = [[YHBCatManage alloc] init];
    [manage getDataArraySuccBlock:^(NSMutableArray *aArray) {
        [self dismissFlower];
        self.dataArray = aArray;
        [self.collectionView reloadData];
    } andFailBlock:^(NSString *aStr){
        [self dismissFlower];
        [SVProgressHUD showErrorWithStatus:aStr cover:YES offsetY:kMainScreenHeight/2.0];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBar.hidden) {
        self.navigationController.navigationBar.hidden = NO;
    }
    self.rightButton.hidden = _isSingleSelect ? YES : NO;
    [self.collectionView reloadData];
    [MobClick beginLogPageView:@"分类1"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self dismissFlower];
    [MobClick endLogPageView:@"分类1"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (void)showFlower
{
    [SVProgressHUD show:YES offsetY:kMainScreenHeight/2.0];
}

- (void)dismissFlower
{
    [SVProgressHUD dismiss];
}

- (void)changeItemSelectedStatus:(NSIndexPath *)indexPath
{
    NSString *combNum = [NSString stringWithFormat:@"%ld %ld", indexPath.section, indexPath.row];
    for (int i = 0; i < _chooseArray.count; i++) {
        NSString *str = _chooseArray[i];
        if ([str isEqualToString:combNum]) {
            [_chooseArray removeObject:str];
            return;
        }
    }
    [_chooseArray addObject:combNum];
    //NSLog(@"已选择%@",_chooseArray);
}

- (BOOL)itemIsSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *combNum = [NSString stringWithFormat:@"%ld %ld", indexPath.section, indexPath.row];
    for (NSString *item in _chooseArray) {
        if ([item isEqualToString:combNum]) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)chooseCatItems
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSString *str in _chooseArray) {
        NSRange range = [str rangeOfString:@" "];
        NSString *section = [str substringToIndex:range.location];
        NSString *row = [str substringFromIndex:range.location + 1];
        YHBCatData *catData = [self.dataArray objectAtIndex:section.integerValue];
        YHBCatSubcate *subCat = [catData.children objectAtIndex:row.integerValue];
        [mutableArray addObject:subCat];
    }
    return mutableArray;
}

- (void)cleanAll
{
    [_chooseArray removeAllObjects];
}

#pragma mark - event response
- (void)backButtonClikc:(UIButton *)sender
{
    _isSingleSelect = NO;
    if (self.isPushed) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)rightBarButtonClick:(UIButton *)sender
{
    if (_myBlock != nil) {
        _myBlock([self chooseCatItems]);
        [self cleanAll];
    }
    if (self.isPushed) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    YHBCatData *catData = _dataArray[section];
    return catData.children.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CategoryCellIdentifier forIndexPath:indexPath];
    YHBCatData *catData = _dataArray[indexPath.section];
    YHBCatSubcate *subcate = catData.children[indexPath.row];
    cell.titleLabel.text = subcate.categoryName;
    cell.isSelected = [self itemIsSelectedAtIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CategoryHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CategoryHeadViewIdentifier forIndexPath:indexPath];
        YHBCatData *catData = _dataArray[indexPath.section];
        headView.titleLabel.text = catData.categoryName;
        return headView;
    }
    else{
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:CategoryFooterViewIdentifier forIndexPath:indexPath];
//        if ([footerView viewWithTag:99] == nil) {
//            footerView.backgroundColor = [UIColor whiteColor];
//            UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kMainScreenWidth, 10)];
//            barView.tag = 99;
//            barView.backgroundColor = [UIColor lightGrayColor];
//            [footerView addSubview:barView];
//        }
        return footerView;
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = (CategoryCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self changeItemSelectedStatus:indexPath];
    cell.isSelected = [self itemIsSelectedAtIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kMainScreenWidth - 20.0) / 4.0 - 10, 25);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kMainScreenWidth, 30.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(kMainScreenWidth, 20.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

#pragma mark - setters and getters
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerNib:[UINib nibWithNibName:@"CategoryCell" bundle:nil] forCellWithReuseIdentifier:CategoryCellIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:@"CategoryHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CategoryHeadViewIdentifier];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:CategoryFooterViewIdentifier];
    }
    return _collectionView;
}

- (void)setBlock:(void(^)(NSArray *aArray))aBlock
{
    self.myBlock = aBlock;
}

@end
