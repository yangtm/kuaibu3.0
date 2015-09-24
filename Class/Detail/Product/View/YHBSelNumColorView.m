//
//  YHBSelNumColorView.m
//  YHB_Prj
//
//  Created by yato_kami on 15/1/13.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "YHBSelNumColorView.h"
//#import "YHBProductDetail.h"
#import "CCTextfieldToolView.h"
#import "YHBSelColorCell.h"
#import "UIImageView+WebCache.h"
//#import "YHBAlbum.h"
#import "YHBNumControl.h"
#import "MWPhotoBrowser.h"
#import "YHBSkuImage.h"
#import "ProductModel.h"

#define kInfoHeight 50
#define kImageheight 30
#define kHeadHeight 25
#define kFooterHeight 50
#define kTitleFont 12
#define kCellHeight 100
#define kbtnHeight 25
#define ktitleFont 16
#define kBtnHeight 35
#define kBtnWidth 140
#define ktoolHeight 55
#define kBackColor [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]

@interface YHBSelNumColorView()<UITableViewDataSource,UITableViewDelegate,YHBSelColorCellDelefate,YHBNumControlDelegate,MWPhotoBrowserDelegate>
{
    UIImageView *_selectedImg;
    NSInteger _selectSkuIndex; //已选色块的编
    UILabel *_unitLabel;
}
@property (strong, nonatomic) ProductModel *productModel;
@property (strong, nonatomic) UIView *infoView;
@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UILabel *priceLabel;//价格label
@property (strong, nonatomic) UILabel *tipLabel;//提示信息label
@property (strong, nonatomic) UIView *headView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *numbFooterView;
@property (strong, nonatomic) YHBNumControl *numControl;//数量控件

@property (strong, nonatomic) NSMutableArray *photos;

@property (assign, nonatomic) double totalPrice;//价格
@property (assign, nonatomic) BOOL isNumFloat;//是否需要小数 数量
@property (strong, nonatomic) UIView *keybordTool;

@property (assign, nonatomic) CGFloat oldCenterY;

@end

@implementation YHBSelNumColorView

#pragma mark - getter and setter

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _oldCenterY = self.centerY;
}

- (BOOL)isNumFloat
{
    return self.numControl.isNumFloat;
}

- (void)setIsNumFloat:(BOOL)isNumFloat
{
    self.numControl.isNumFloat = isNumFloat;
}

- (double)number
{
    return self.numControl.number;
}

- (void)setNumber:(double)number
{
    self.numControl.number = number;
}

- (YHBNumControl *)numControl
{
    if (!_numControl) {
        _numControl = [[YHBNumControl alloc] init];
        _numControl.delegate = self;
    }
    return _numControl;
}

- (UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, kInfoHeight, kMainScreenWidth, kHeadHeight)];
        _headView.backgroundColor = [UIColor whiteColor];
        _headView.layer.borderColor = [kLineColor CGColor];
        _headView.layer.borderWidth = 0.5;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, (kHeadHeight-kTitleFont)/2.0, 200, kTitleFont)];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:kTitleFont];
        label.text = @"颜色";
        _tipLabel = label;
        [_headView addSubview:label];
        //长安显示大图
        label = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth - 100, (kHeadHeight-kTitleFont)/2.0, 90, kTitleFont)];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:kTitleFont];
        label.text = @"(长按显示大图)";
        //[_headView addSubview:label];
    }
    return _headView;
}

- (void )creatcartFooterView
{
    UIButton *cartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cartButton setBackgroundColor:KColor];
    [cartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    cartButton.titleLabel.font = [UIFont systemFontOfSize:ktitleFont];
    [cartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cartButton.frame = CGRectMake(0, self.height-kFooterHeight, kMainScreenWidth, kFooterHeight);
    [cartButton addTarget:self action:@selector(gotoCart) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cartButton];
}
-(void)gotoCart
{
    NSLog(@"加入购物车");
}
- (UIView *)numbFooterView
{
    if (!_numbFooterView) {
        _numbFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-kFooterHeight*2, kMainScreenWidth, kFooterHeight)];
        _numbFooterView.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.5)];
        line.backgroundColor = kLineColor;
        [_numbFooterView addSubview:line];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, (kFooterHeight-kTitleFont+5)/2.0, 25, kTitleFont)];
        
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:kTitleFont];
        label.text = @"数量";
        [_numbFooterView addSubview:label];
        
        self.numControl.left = label.right + 10;
        self.numControl.centerY = _numbFooterView.height/2.0;
        [_numbFooterView addSubview:self.numControl];
        
        UILabel *unit = [[UILabel alloc] initWithFrame:CGRectMake(self.numControl.right+10, _numControl.bottom-25, 100, 22)];
        unit.textColor = [UIColor lightGrayColor];
        unit.font = [UIFont systemFontOfSize:22-2];
        unit.text = @"米";
        _unitLabel = unit;
        [_numbFooterView addSubview:unit];
    }
    return _numbFooterView;
}

- (instancetype)initWithProductModel:(ProductModel *)model
{
    self = [super init];
    if (self) {
        self.productModel = model;
        self.number = 1.0;
//        self.isNumFloat = NO;
//        if ([self.productModel.typeid isEqualToString:@"0"]) {
            self.isNumFloat = NO;
//        }
        _selectSkuIndex = -1;
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, kMainScreenWidth, kHeadHeight+kInfoHeight+kFooterHeight*2+2*kCellHeight);
        [self creatUI];
        if (self.selSku != nil) {
            self.tipLabel.text = [NSString stringWithFormat:@"已选“%@”", self.selSku.specificationName];
            self.priceLabel.text = [NSString stringWithFormat:@"%0.2f", self.selSku.price];
        }
        
    }
    return self;
}

- (void)creatUI {
    
    [self creatInfoHeadView];
    [self addSubview:self.headView];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headView.bottom, kMainScreenWidth, self.height-kInfoHeight-kHeadHeight-kFooterHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = kCellHeight;
    [self addSubview:self.tableView];
    [self addSubview:self.numbFooterView];
    [self creatcartFooterView];
}
//UI
- (void)creatInfoHeadView
{
    self.infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kInfoHeight)];
    self.infoView.backgroundColor = [UIColor whiteColor];
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kImageheight, kImageheight)];
    _headImageView.layer.borderWidth = 0.5f;
    _headImageView.layer.borderColor = [kLineColor CGColor];
    _headImageView.layer.cornerRadius = 2.0f;
    _headImageView.backgroundColor = [UIColor whiteColor];
    if (self.productModel.productSpecificationList.count) {
        NSString *url=self.productModel.productSpecificationList[0][@"specificationImage"];
        NSString *HeadView=nil;
        kZXYRequestUrl(url, HeadView);
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:HeadView] placeholderImage:nil options:SDWebImageCacheMemoryOnly];
    }
    
    [self.infoView addSubview:self.headImageView];
    
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headImageView.right+10, 10, 170, kTitleFont+2)];
    self.priceLabel.backgroundColor = [UIColor clearColor];
    self.priceLabel.textColor = [UIColor redColor];
    [self.priceLabel setFont:[UIFont systemFontOfSize:kTitleFont+2]];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.totalPrice];
    [self.infoView addSubview:self.priceLabel];
    
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.priceLabel.left, self.priceLabel.bottom+3, 200, kTitleFont)];
    self.tipLabel.font = [UIFont systemFontOfSize:kTitleFont];
    self.tipLabel.backgroundColor = [UIColor clearColor];
    self.tipLabel.textColor = [UIColor lightGrayColor];
    self.tipLabel.text = @"请选择颜色、数量";
    [self.infoView addSubview:self.tipLabel];
    
    UIButton *quitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    quitButton.frame = CGRectMake(kMainScreenWidth-50, 10, 40, 30);
    //[quitButton setBackgroundImage:[UIImage imageNamed:@"quit"] forState:UIControlStateNormal];
    [quitButton setTitle:@"完成" forState:UIControlStateNormal];
    [quitButton setTitleColor:KColor forState:UIControlStateNormal];
    [quitButton setContentMode:UIViewContentModeScaleAspectFit];
    [quitButton addTarget:self action:@selector(touchQuitButton) forControlEvents:UIControlEventTouchUpInside];
    [self.infoView addSubview:quitButton];
    
    [self addSubview:self.infoView];
}

- (void)setUnit: (NSString  *)unit
{
    if (unit.length) {
        _unitLabel.text = unit;
    }
}


#pragma mark - 数据源方法
#pragma mark 数据行数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger quotient = self.productModel.productSpecificationList.count / 3;
    NSInteger remainder = self.productModel.productSpecificationList.count % 3;
    NSInteger numb = quotient;
    if (remainder > 0) {
        numb += 1;
    }
    return numb;
}

#pragma mark 每行显示内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    YHBSelColorCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YHBSelColorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.delegate = self;
    }
    cell.cellIndexPath = indexPath;
    for (int i = (int)indexPath.row * 3, j = 0; i < self.productModel.productSpecificationList.count && i < (int)indexPath.row * 3 + 3; i++, j++) {
        YHBSku *sku = [[YHBSku alloc]init];
         [sku setValuesForKeysWithDictionary:self.productModel.productSpecificationList[i]];
        NSString *imageurl =nil;
        kZXYRequestUrl(sku.specificationImage, imageurl);
       [cell setUIwithTitle:sku.specificationName image:imageurl part:j];
    }
    return cell;
}


#pragma mark - Action
- (void)touchQuitButton
{
    if ([self.numControl.numberTextfield isFirstResponder]) {
        [self.numControl.numberTextfield resignFirstResponder];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if ([self.delegate respondsToSelector:@selector(selViewShouldDismissWithSelNum:andSelSku:)]) {
        [self.delegate selViewShouldDismissWithSelNum:self.number andSelSku:self.selSku];
    }
}

//- (void)calulatePrice
//{
//    self.totalPrice = [self.productModel.price doubleValue] * self.number;
//    self.priceLabel.text = self.isNumFloat ? [NSString stringWithFormat:@"%.2f",self.totalPrice] : [NSString stringWithFormat:@"%d",(int)self.totalPrice];
//}

#pragma mark - cell Delegate
#pragma mark 点击色块
- (void)selectCellPartWithIndexPath:(NSIndexPath *)indexPath part:(NSInteger)part imgView:(UIImageView *)imageView
{
    MLOG(@"touch cell part");
    NSInteger index = indexPath.row *3 + part;
    if (self.productModel.productSpecificationList.count > index) {
        YHBSku *sku = [[YHBSku alloc]init];
        [sku setValuesForKeysWithDictionary:self.productModel.productSpecificationList[index]];
        self.tipLabel.text = [NSString stringWithFormat:@"已选“%@”",sku.specificationName];
        if (sku.type ==1) {
            self.priceLabel.text = [NSString stringWithFormat:@"%0.2f", sku.typePrice];
        }else
        {
            self.priceLabel.text = [NSString stringWithFormat:@"%0.2f", sku.price];
        }
        if (_selectedImg) {
            _selectedImg.layer.borderColor = [kLineColor CGColor];
        }
        _selectedImg = imageView;
        _selectedImg.layer.borderColor = [KColor CGColor];
        _selectSkuIndex = index;
        self.selSku = sku;
    }
}
#pragma mark 长按色块
- (void)longPressCellPartWithIndexPath:(NSIndexPath *)indexPath part:(NSInteger)part imgView:(UIImageView *)imagView
{
    
    MLOG(@"long press part");
    
    NSInteger index = indexPath.row * 3 + part;
    
    if (index < self.productModel.productSpecificationList.count) {
        _photos = [[NSMutableArray alloc] init];
        //YHBSku *sku = _productModel.productSpecificationList[index];
        //for (NSInteger i = 0; i < _productModel.productSpecificationList.count; i++) {
            NSString *imageurl=nil;
            NSString *url=self.productModel.productSpecificationList[index][@"imageUrl"];
            kZXYRequestUrl(url, imageurl);
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:imageurl?:@""]];
            [_photos addObject:photo];
        //}
        [self showPhotoBrownserWithIndex:0];
    }
}


#pragma mark - 照片浏览
- (void)showPhotoBrownserWithIndex:(NSInteger)num
{
    BOOL displayActionButton = NO;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;//分享按钮,默认是
    browser.displayNavArrows = displayNavArrows;//左右分页切换,默认否
    browser.displaySelectionButtons = displaySelectionButtons;//是否显示选择按钮在图片上,默认否
    browser.alwaysShowControls = displaySelectionButtons;//控制条件控件 是否显示,默认否
    browser.zoomPhotosToFill = NO;//是否全屏,默认是
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;//是否全屏
#endif
    browser.enableGrid = enableGrid;//是否允许用网格查看所有图片,默认是
    browser.startOnGrid = startOnGrid;//是否第一张,默认否
    browser.enableSwipeToDismiss = YES;
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    [browser setCurrentPhotoIndex:num];
    //browser.photoTitles = @[@"000",@"111",@"222",@"333"];//标题
    
   // [self presentViewController:browser animated:YES completion:nil];
    //[self.navigationController pushViewController:browser animated:NO];
    if ([self.delegate respondsToSelector:@selector(selViewShouldPushViewController:)]) {
        [self.delegate selViewShouldPushViewController:browser];
    }
}

#pragma mark - YHBNumControlDelegate
- (void)numberControlValueDidChanged
{
    UITextField *textField = _numControl.numberTextfield;
    int count = (int)ceilf(textField.text.floatValue);
    if (count == 0) {
        count = 1;
    }
    textField.text = [NSString stringWithFormat:@"%d", count];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id )photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (void)registerForKeyboradNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHid:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keybordWillShow:(NSNotification *)notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    self.centerY = _oldCenterY - keyboardSize.height + 60;
}

- (void)keyboardWillHid:(NSNotification *)notif
{
    self.bottom = kMainScreenHeight-64;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
