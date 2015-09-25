//
//  YHBConnectStoreVeiw.m
//  YHB_Prj
//
//  Created by yato_kami on 15/1/4.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "YHBConnectStoreVeiw.h"
#import "UIImageView+WebCache.h"
#define kImgwidth 30
#define kbtnwidth 55
@interface YHBConnectStoreVeiw()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *attentionlabel;

@end

@implementation YHBConnectStoreVeiw

#pragma mark getter and setter

- (UILabel *)attentionlabel
{
    if (!_attentionlabel) {
        _attentionlabel = [[UILabel alloc] init];
        _attentionlabel.textColor = [UIColor colorWithRed:0.6824 green:0.6824 blue:0.6824 alpha:1];
        _attentionlabel.font = kFont11;
        _attentionlabel.backgroundColor = [UIColor clearColor];
    }
    return _attentionlabel;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kImgwidth, kImgwidth)];
        _imageView.layer.cornerRadius = 2.0f;
        _imageView.layer.borderColor = [kLineColor CGColor];
        _imageView.layer.borderWidth = 0.5;
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 250, kImgwidth)];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = kFont14;
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kMainScreenWidth, kcStoreHeight);
        self.backgroundColor = [UIColor whiteColor];
        [self creatUI];
    }
    return self;
}

- (void)creatUI
{
    UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kMainScreenWidth-kbtnwidth-10, kImgwidth)];
    detailView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchShopDetail)];
    [detailView addGestureRecognizer:gr];
    [self addSubview:detailView];
    
    [detailView addSubview:self.imageView];
    self.titleLabel.left = self.imageView.right+5;
    [detailView addSubview:self.titleLabel];
    
     UILabel *desTitle = [[UILabel alloc] initWithFrame:CGRectMake(270, 20,100, 11)];
    desTitle.text = @"易步专卖店";
    desTitle.textColor =[UIColor colorWithRed:0.0118 green:0.7059 blue:0.8863 alpha:1];
    desTitle.font = kFont15;
    [self addSubview:desTitle];
    
    self.attentionlabel.frame = CGRectMake(280, 40, 100, 11);
    [self addSubview:self.attentionlabel];

}

- (void)setUIWithTitle:(NSString *)title imageUrl:(NSString *)urlstr attention:(NSString *)attention
{
    self.titleLabel.text = title;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:nil options:SDWebImageCacheMemoryOnly];
    self.attentionlabel.text =[NSString stringWithFormat:@"%@人关注",attention];
}

#pragma mark - action
- (void)touchShopDetail
{
    if ([self.delegate respondsToSelector:@selector(touchShopDetailCell)]) {
        [self.delegate touchShopDetailCell];
    }
}

@end
