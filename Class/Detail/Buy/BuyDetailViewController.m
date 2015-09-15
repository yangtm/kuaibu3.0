//
//  BuyDetailViewController.m
//  kuaibu
//
//  Created by zxy on 15/9/10.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "BuyDetailViewController.h"
#import "YHBPictureAdder.h"
#import "OfferDetailController.h"


#define kBottomLineTag 99

//typedef NS_ENUM(NSInteger, ProcurementStatusType) {
//
//    ON,//("寻找中", 1)
//
//    INVALID,//("已失效", 2)
// 
//    FINISH,//("已找到", 3)
//
//    CANCEL,//("已取消", 4)
//};


@interface BuyDetailViewController ()<UIScrollViewDelegate>
{
    UIImageView *_playImageView;
    BOOL _isPlaying;
}

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) YHBPictureAdder *pictureAdder;
@property (nonatomic,strong) UIView *detailFormView;
@property (nonatomic,strong) UIView *footFormView;

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UILabel *categoryLabel;
@property (nonatomic,strong) UILabel *numberLabel;
@property (nonatomic,strong) UILabel *offLastLabel;
@property (nonatomic,strong) UILabel *takeDeliveryLabel;
@property (nonatomic,strong) UILabel *cutLabel;
@property (nonatomic,strong) UILabel *billingTypeLabel;
@property (nonatomic,strong) UITextView *detailsView;
@property (nonatomic,strong) UILabel *districtLabel;
@property (nonatomic,strong) UIButton *playButton;

@property (nonatomic,strong) UIButton *likeButton;
@property (nonatomic,strong) UIButton *contactButton;
@property (nonatomic,strong) UIButton *offButton;
@end

@implementation BuyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    [self showData];
    [self settitleLabel:@"采购详情"];
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(back)];
    self.view.backgroundColor = RGBCOLOR(241, 241, 241);
    
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.pictureAdder];

    [self.scrollView addSubview:self.detailFormView];
    [self.scrollView addSubview:self.footFormView];
    [self setupFormView];
    [self setFootView];
    
    self.scrollView.contentSize = CGSizeMake(kMainScreenWidth, self.footFormView.bottom );
   
    
}

- (void)showData
{
    
    
    NSString *url = nil;
    kYHBRequestUrl(@"procurement/open/procurementDetail", url);
//    NSLog(@"%d",_ListId);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(_ListId),@"procurementId", nil];
    
    [NetworkService postWithURL:url paramters:dic success:^(NSData *receiveData) {
        id result = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dic = result[@"RESULT"];
            NSLog(@"%@",dic);
            _nameLabel.text = dic[@"productName"];
            _timeLabel.text = [NSString stringWithFormat:@"发布时间 : %@",dic[@"createDate"]];
            if ([dic[@"procurementStatus"] integerValue] == 1) {
                _typeLabel.text = @"状态 : 寻找中";
            }else if ([dic[@"procurementStatus"] integerValue] == 2){
                _typeLabel.text = @"状态 : 已失效";
            }else if ([dic[@"procurementStatus"] integerValue] == 3){
                _typeLabel.text = @"状态 : 已找到";
            }else if ([dic[@"procurementStatus"] integerValue] == 4){
                _typeLabel.text = @"状态 : 已取消";
            }
            _categoryLabel.text = [NSString stringWithFormat:@"分类 : %@",dic[@"catId"]];
            _numberLabel.text = [NSString stringWithFormat:@"采购数量 : %@%@",dic[@"amount"],dic[@"amountUnit"]];
            _offLastLabel.text = [NSString stringWithFormat:@"报价截止时间 : %@",dic[@"offerLastDate"]];
            _takeDeliveryLabel.text = [NSString stringWithFormat:@"收货截止时间 : %@",dic[@"takeDeliveryLastDate"]];
            _cutLabel.text = [NSString stringWithFormat:@"是否需要剪样 : %@",dic[@"isSampleCut"]?@"是":@"否"];
            if ([dic[@"billingType"] integerValue] == 3) {
                _billingTypeLabel.text = [NSString stringWithFormat:@"发票类型 : %@",@"增值税发票"];
            }else if ([dic[@"billingType"] integerValue] == 1){
                _billingTypeLabel.text = [NSString stringWithFormat:@"发票类型 : %@",@"无"];
            }else if ([dic[@"billingType"] integerValue] == 2){
                _billingTypeLabel.text = [NSString stringWithFormat:@"发票类型 : %@",@"普通发票"];
            }
            _detailsView.text = [NSString stringWithFormat:@"面料详情 : %@",dic[@"details"]];
            
            
        }

    } failure:^(NSError *error) {

        NSLog(@"%@",error);
    }];
    
   
}

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UI
- (void)setupFormView
{
    UIView *view1 = [self productNameForm:CGRectMake(0, 0, kMainScreenWidth, 60)];
    UIView *view2 = [self typeForm:CGRectMake(0, view1.bottom, kMainScreenWidth, 44)];
    UIView *view3 = [self categoryFrom:CGRectMake(0, view2.bottom, kMainScreenWidth, view2.height)];
    UIView *view4 = [self procurementFrom:CGRectMake(0, view3.bottom, kMainScreenWidth, view3.height)];
    UIView *view5 = [self offLastFrom:CGRectMake(0, view4.bottom, kMainScreenWidth, view4.height)];
    UIView *view6 = [self takeDeliveryFrom:CGRectMake(0, view5.bottom, kMainScreenWidth, view5.height)];
    UIView *view7 = [self isSampleCutFrom:CGRectMake(0, view6.bottom, kMainScreenWidth, view6.height)];
    UIView *view8 = [self billingTypeFrom:CGRectMake(0, view7.bottom, kMainScreenWidth, view7.height)];
    UIView *view9 = [self detailsFrom:CGRectMake(0, view8.bottom, kMainScreenWidth, 60)];
    UIView *view10 = [self setupPlayButtonWithFrame:CGRectMake(0, view9.bottom+10, kMainScreenWidth, 50)];
    [_detailFormView addSubview:view1];
    [_detailFormView addSubview:view2];
    [_detailFormView addSubview:view3];
    [_detailFormView addSubview:view4];
    [_detailFormView addSubview:view5];
    [_detailFormView addSubview:view6];
    [_detailFormView addSubview:view7];
    [_detailFormView addSubview:view8];
    [_detailFormView addSubview:view9];
    [_detailFormView addSubview:view10];
    _detailFormView.frame = CGRectMake(0, self.pictureAdder.bottom, kMainScreenWidth, view10.bottom);
}

- (void)setFootView
{
    UIView *view = [self footViewFrom:CGRectMake(0,0, kMainScreenWidth, 49)];
    [_footFormView addSubview:view];
    _footFormView.frame = CGRectMake(0, self.detailFormView.bottom+10, kMainScreenWidth, 49);
}

#pragma mark -标题UI
- (UIView *)productNameForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    UIView *topLineView = [[UIView alloc]
                           initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.5)];
    topLineView.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:topLineView];
    _nameLabel = [self formTitleLabel:CGRectMake(10, topLineView.bottom+10, kMainScreenWidth-60 , 18) title:@"商品名 : "];
//    _nameLabel.text = _procModel.productName;
//    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, topLineView.bottom+10, kMainScreenWidth-80, 18)];
//    nameLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:_nameLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom+10, kMainScreenWidth-60, 15)];
    _timeLabel.font = kFont12;
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.text = @"发布时间 : ";
//    _timeLabel.text = [NSString stringWithFormat:@"发布时间 : %@",_procModel.offerLastDate];
    [view addSubview:_timeLabel];
    [self addBottomLine:view];
    return view;
}

#pragma mark - 状态UI
- (UIView *)typeForm:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    _typeLabel = [self formTitleLabel:CGRectMake(10, 0, kMainScreenWidth-60, view.height) title:@"状态 : "];
//    if ([_procModel.procurementStatus integerValue] == 1) {
//        _typeLabel.text = @"寻找中";
//    }else if ([_procModel.procurementStatus integerValue] == 2){
//        _typeLabel.text = @"已失效";
//    }else if ([_procModel.procurementStatus integerValue] == 3){
//        _typeLabel.text = @"已找到";
//    }else if ([_procModel.procurementStatus integerValue] == 4){
//        _typeLabel.text = @"已取消";
//    }
//    _typeLabel.text = []
    [view addSubview:_typeLabel];
    [self addBottomLine:view];
    return view;
}

#pragma mark - 分类UI
- (UIView *)categoryFrom:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    _categoryLabel = [self formTitleLabel:CGRectMake(10, 0, kMainScreenWidth-60, view.height) title:@"分类 : "];
    [view addSubview:_categoryLabel];
    [self addBottomLine:view];
    return view;
}

#pragma mark - 采购数量UI
- (UIView *)procurementFrom:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    _numberLabel = [self formTitleLabel:CGRectMake(10, 0, kMainScreenWidth-60, view.height) title:@"采购数量 : "];
    [view addSubview:_numberLabel];
    [self addBottomLine:view];
    return view;
}

#pragma mark - 报价截止时间UI
- (UIView *)offLastFrom:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    _offLastLabel = [self formTitleLabel:CGRectMake(10, 0, kMainScreenWidth - 60, view.height) title:@"报价截止时间 : "];
    [view addSubview:_offLastLabel];
    [self addBottomLine:view];
    return view;
}

#pragma mark - 收货截止时间UI
- (UIView *)takeDeliveryFrom:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    _takeDeliveryLabel = [self formTitleLabel:CGRectMake(10, 0, kMainScreenWidth - 60, view.height) title:@"收货截止时间 : "];
    [view addSubview:_takeDeliveryLabel];
    [self addBottomLine:view];
    return view;
}

#pragma mark -是否需要剪样UI
- (UIView *)isSampleCutFrom:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    _cutLabel = [self formTitleLabel:CGRectMake(10, 0, kMainScreenWidth - 60, view.height) title:@"是否需要剪样 : "];
    [view addSubview:_cutLabel];
    [self addBottomLine:view];
    return view;
}

#pragma mark - 发票UI
- (UIView *)billingTypeFrom:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    _billingTypeLabel = [self formTitleLabel:CGRectMake(10, 0, kMainScreenWidth - 60, view.height) title:@"发票类型 : "];
    [view addSubview:_billingTypeLabel];
    [self addBottomLine:view];
    return view;
}

#pragma mark - 面料详情UI
- (UIView *)detailsFrom:(CGRect)frame
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    _detailsView = [[UITextView alloc]
                      initWithFrame:CGRectMake(10, 0, kMainScreenWidth - 20, view.height)];
    _detailsView.backgroundColor = [UIColor clearColor];
    _detailsView.textColor = [UIColor lightGrayColor];
    _detailsView.font = kFont15;
    _detailsView.text = @"面料详情 : ";
    [_detailsView setEditable:NO];
    [view addSubview:_detailsView];
    return view;
}

#pragma mark - footView
- (UIView *)footViewFrom:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeButton.frame = CGRectMake(0, 0, kMainScreenWidth/3, view.height);
    [_likeButton setTitle:@"收藏" forState:UIControlStateNormal];
    [_likeButton setTitleColor:kNaviTitleColor forState:UIControlStateNormal];
    [_likeButton addTarget:self action:@selector(clickLikeBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_likeButton];
    _contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _contactButton.frame = CGRectMake(_likeButton.right, 0, kMainScreenWidth/3, view.height);
    [_contactButton setTitle:@"联系卖家" forState:UIControlStateNormal];
    [_contactButton setTitleColor:kNaviTitleColor forState:UIControlStateNormal];
    [_contactButton addTarget:self action:@selector(clickContactBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_contactButton];
    _offButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _offButton.frame = CGRectMake(_contactButton.right, 0, kMainScreenWidth/3, view.height);
    [_offButton setTitle:@"我要报价" forState:UIControlStateNormal];
    [_offButton setTitleColor:kNaviTitleColor forState:UIControlStateNormal];
    [_offButton addTarget:self action:@selector(clickOffBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_offButton];
    
    return view;
}

#pragma mark - 按钮点击响应
- (void)clickLikeBtn
{
    NSLog(@"收藏");
}

- (void)clickContactBtn
{
    NSLog(@"联系卖家");
}

- (void)clickOffBtn
{
//    NSLog(@"我要报价");
    OfferDetailController *vc = [[OfferDetailController alloc] init];
    vc.number = [_numberLabel.text integerValue];
    [self presentViewController:[[LSNavigationController alloc] initWithRootViewController:vc] animated:YES completion:^{
        
    }];
}

#pragma mark - 播放按钮UI
- (UIView *)setupPlayButtonWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    if (_playButton == nil) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.frame = CGRectMake(20, 0, kMainScreenWidth-40, 40);
        _playButton.layer.cornerRadius = 4.0;
        _playButton.layer.borderColor = [UIColor colorWithRed:230/255.0 green:69/255.0 blue:14/255.0 alpha:1].CGColor;
        _playButton.layer.borderWidth = 1.0;
        [_playButton setTitle:@"点击播放" forState:UIControlStateNormal];
        [_playButton setTitleColor:[UIColor colorWithRed:230/255.0 green:69/255.0 blue:14/255.0 alpha:1] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _playImageView = [[UIImageView alloc] init];
        _playImageView.frame = CGRectMake(10, 10, 20, 20);
        [_playButton addSubview:_playImageView];
        [self setPlayImageViewNormal];
        [view addSubview:_playButton];
        [self addBottomLine:view];
    }
    return view;
}

- (void)stopPlaySound
{
    [self setPlayImageViewNormal];
    [_playButton setTitle:@"点击播放" forState:UIControlStateNormal];
    _isPlaying = NO;
}

- (void)setPlayImageViewPlay
{
    NSArray *array = @[[UIImage imageNamed:@"ReceiverVoiceNodePlaying001"],
                       [UIImage imageNamed:@"ReceiverVoiceNodePlaying002"],
                       [UIImage imageNamed:@"ReceiverVoiceNodePlaying003"]];
    _playImageView.animationImages = array;
    _playImageView.contentMode = UIViewContentModeScaleAspectFit;
    _playImageView.animationDuration = 1.0;
    _playImageView.animationRepeatCount = 0;
    [_playImageView startAnimating];
    //    [self playSound];
}

- (void)setPlayImageViewNormal
{
    [_playImageView stopAnimating];
    _playImageView.image = [UIImage imageNamed:@"ReceiverVoiceNodePlaying"];
    //    [self stopPalySound];
}




- (void)playButtonClick:(UIButton *)sender
{
    if (_isPlaying) {
        [self setPlayImageViewNormal];
        [sender setTitle:@"点击播放" forState:UIControlStateNormal];
        if ([_delegate respondsToSelector:@selector(buyDetailViewDidSEndPalySound:)]) {
            [_delegate buyDetailViewDidSEndPalySound:self];
        }
    }
    else{
        [self setPlayImageViewPlay];
        [sender setTitle:@"点击停止" forState:UIControlStateNormal];
        if ([_delegate respondsToSelector:@selector(buyDetailViewDidBeginPalySound:)]) {
            [_delegate buyDetailViewDidBeginPalySound:self];
        }
    }
    _isPlaying = !_isPlaying;
}

#pragma mark -getter&setter
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64)];
//        _scrollView.backgroundColor = [UIColor redColor];
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (YHBPictureAdder *)pictureAdder
{
    if (_pictureAdder == nil) {
        _pictureAdder = [[YHBPictureAdder alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 120) contentController:self];
        _pictureAdder.enableEdit = NO;
        _pictureAdder.enableSaveImage = YES;
    }
    return _pictureAdder;
}

- (UIView *)detailFormView
{
    if (_detailFormView == nil) {
        _detailFormView = [[UIView alloc] initWithFrame:CGRectZero];
        _detailFormView.backgroundColor = [UIColor whiteColor];
    }
    return _detailFormView;
}

- (UIView *)footFormView
{
    if (_footFormView == nil) {
        _footFormView = [[UIView alloc] initWithFrame:CGRectZero];
        _footFormView.backgroundColor = [UIColor whiteColor];
    }
    return _footFormView;
}

- (UILabel *)formTitleLabel:(CGRect)frame title:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:15];
    label.text = title;
    [self shadedStar:label];
    return label;
}

- (void) shadedStar:(UILabel *)label
{
    if ([label.text hasPrefix:@"*"]) {
        NSMutableAttributedString *attrubuteStr = [[NSMutableAttributedString alloc] initWithString:label.text];
        [attrubuteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
        [attrubuteStr addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:-2.0] range:NSMakeRange(0, 1)];
        label.attributedText = attrubuteStr;
    }
}

- (void)addBottomLine:(UIView *)view
{
    UIView *lineView = [self lineView:CGRectMake(0, view.height - 0.5, 0, 0)];
    lineView.tag = kBottomLineTag;
    [view addSubview:lineView];
}

- (UIView *)lineView:(CGRect)frame
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, kMainScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    return lineView;
}
@end
