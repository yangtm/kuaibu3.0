//
//  YHBPdtInfoView.m
//  YHB_Prj
//
//  Created by yato_kami on 15/1/3.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "YHBPdtInfoView.h"

#define kPrice 16
#define ktext 12
#define kBtnWidth 35
@interface YHBPdtInfoView()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *saleLabel;

@end

@implementation YHBPdtInfoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kMainScreenWidth, kProductInfoViewHeight);
        self.backgroundColor = [UIColor whiteColor];
        [self creatUI];
    }
    return self;
}

- (void)creatUI
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kMainScreenWidth-30-kBtnWidth, kTitlefont*3)];
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.numberOfLines = 2;
    
    [self addSubview:self.titleLabel];
    //self.titleLabel.text = @"xxxxsdfsdfsgdfgdfgdsdfasdfasdfasdfgdxxx电视机";
    
    UILabel *priceTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, self.titleLabel.bottom+5, kTitlefont*3, kTitlefont)];
    [priceTitle setFont:[UIFont systemFontOfSize:kTitlefont]];
    [priceTitle setTextColor:[UIColor lightGrayColor]];
    priceTitle.text = @"价格：";
    //[self addSubview:priceTitle];
    
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, kPrice)];
    self.priceLabel.textColor = [UIColor redColor];
    //self.priceLabel.text = @"￥403";
    self.priceLabel.bottom = priceTitle.bottom;
    [self addSubview:self.priceLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.priceLabel.bottom+10, kMainScreenWidth, 0.5)];
    line.backgroundColor = kLineColor;
    [self addSubview:line];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth-35, self.height/2.0 -30, 30, 30)];
    arrowImageView.image = [UIImage imageNamed:@"iconfont-nextpage"];
    [arrowImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:arrowImageView];
    
    UILabel *cateTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, line.bottom+11, kTitlefont*3, kTitlefont)];
    [cateTitle setFont:[UIFont systemFontOfSize:kTitlefont]];
    [cateTitle setTextColor:[UIColor blackColor]];
    cateTitle.text = @"促销：";
    [self addSubview:cateTitle];
    
    self.saleLabel = [[UILabel alloc] initWithFrame:CGRectMake(cateTitle.right+10, line.bottom+11, kMainScreenWidth-cateTitle.right-20, kTitlefont)];
    [self.saleLabel setFont:[UIFont systemFontOfSize:kTitlefont]];
    [self.saleLabel setTextColor:[UIColor lightGrayColor]];
    //self.cateLabel.text = @"印花，丝绸，窗帘";
    [self addSubview:self.saleLabel];
    
//    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 116, kMainScreenWidth, 0.5)];
//    line.backgroundColor = kLineColor;
//    [self addSubview:line2];

}

- (void)setTitle:(NSString *)title price:(NSString *)price sale:(NSString *)sale
{
    self.titleLabel.text = title;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",price];
    self.saleLabel.text = sale;
}

@end
