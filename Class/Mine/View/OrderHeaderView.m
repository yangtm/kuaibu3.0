//
//  OrderHeaderView.m
//  kuaibu
//
//  Created by 朱新余 on 15/9/25.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "OrderHeaderView.h"
//NOTCOMPLETE = 1,//未处理
//AUDIT,          //已审核
//SHUTDOWNORDER,  //已关闭
//NOTPAYMENT,     //未付款
//PAYMENT,        //待发货
//DELIVERED,      //待收货
//COMPLETE        //已完成、待评价


@implementation OrderHeaderView

- (instancetype)initWithFrame:(CGRect)frame orderType:(NSInteger)tpye
{
   if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
       if (tpye == -1) {
           [self setup1];
       }else if (tpye == 4){
           [self setup2];
       }else if (tpye == 5){
           [self setup3];
       }else if (tpye == 6){
           [self setup4];
       }else if (tpye == 7){
           [self setup5];
       }
       
    }
    return self;
}

//已完成、待评价
- (void)setup5
{
    //    _selectImageView = [MyUtil createButton:CGRectMake(10, 10, 20, 20) title:nil BtnImage:@"weixuanzhong"selectImageName:@"xuanzhong" target:self action:@selector(selectAction)];
    //    //    _selectImageView = [MyUtil createImageView:CGRectMake(10, 10, 20, 20) imageName:@"weixuanzhong"];
    //    [self addSubview:_selectImageView];
    
    _storeNameLabel = [MyUtil createLabel:CGRectZero text:@"店铺名" alignment:NSTextAlignmentLeft fontSize:15];
    [self addSubview:_storeNameLabel];
    _storeNameLabel.width = [MyUtil labelAutoCalculateRectWith:_storeNameLabel.text FontSize:15 MaxSize:CGSizeMake(150, 40)];
    _storeNameLabel.frame = CGRectMake(20, 10, _storeNameLabel.width, 20);
    _arrowImageView = [MyUtil createImageView:CGRectMake(_storeNameLabel.right, 10, 20, 20) imageName:@"right"];
    [self addSubview:_arrowImageView];
    _storeNameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStoreNameLabel)];
    [_storeNameLabel addGestureRecognizer:tap];
    
    
    _payLabel = [MyUtil createLabel:CGRectZero text:@"待评价" alignment:NSTextAlignmentRight fontSize:13];
    _payLabel.width = [MyUtil labelAutoCalculateRectWith:_payLabel.text FontSize:15 MaxSize:CGSizeMake(100, 40)];
    _payLabel.frame = CGRectMake(self.right - _payLabel.width - 20, 10, _payLabel.width, 20);
    _payLabel.textColor = [UIColor grayColor];
    [self addSubview:_payLabel];
    
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 40, kMainScreenWidth-20, 1 )];
    line.backgroundColor = kNaviTitleColor;
    [self addSubview:line];
}
//待收货
- (void)setup4
{
    //    _selectImageView = [MyUtil createButton:CGRectMake(10, 10, 20, 20) title:nil BtnImage:@"weixuanzhong"selectImageName:@"xuanzhong" target:self action:@selector(selectAction)];
    //    //    _selectImageView = [MyUtil createImageView:CGRectMake(10, 10, 20, 20) imageName:@"weixuanzhong"];
    //    [self addSubview:_selectImageView];
    
    _storeNameLabel = [MyUtil createLabel:CGRectZero text:@"店铺名" alignment:NSTextAlignmentLeft fontSize:15];
    [self addSubview:_storeNameLabel];
    _storeNameLabel.width = [MyUtil labelAutoCalculateRectWith:_storeNameLabel.text FontSize:15 MaxSize:CGSizeMake(150, 40)];
    _storeNameLabel.frame = CGRectMake(20, 10, _storeNameLabel.width, 20);
    _arrowImageView = [MyUtil createImageView:CGRectMake(_storeNameLabel.right, 10, 20, 20) imageName:@"right"];
    [self addSubview:_arrowImageView];
    _storeNameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStoreNameLabel)];
    [_storeNameLabel addGestureRecognizer:tap];
    
    
    _payLabel = [MyUtil createLabel:CGRectZero text:@"待收货" alignment:NSTextAlignmentRight fontSize:13];
    _payLabel.width = [MyUtil labelAutoCalculateRectWith:_payLabel.text FontSize:15 MaxSize:CGSizeMake(100, 40)];
    _payLabel.frame = CGRectMake(self.right - _payLabel.width - 20, 10, _payLabel.width, 20);
    _payLabel.textColor = [UIColor grayColor];
    [self addSubview:_payLabel];
    
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 40, kMainScreenWidth-20, 1 )];
    line.backgroundColor = kNaviTitleColor;
    [self addSubview:line];
}

//待发货
- (void)setup3
{
    //    _selectImageView = [MyUtil createButton:CGRectMake(10, 10, 20, 20) title:nil BtnImage:@"weixuanzhong"selectImageName:@"xuanzhong" target:self action:@selector(selectAction)];
    //    //    _selectImageView = [MyUtil createImageView:CGRectMake(10, 10, 20, 20) imageName:@"weixuanzhong"];
    //    [self addSubview:_selectImageView];
    
    _storeNameLabel = [MyUtil createLabel:CGRectZero text:@"店铺名" alignment:NSTextAlignmentLeft fontSize:15];
    [self addSubview:_storeNameLabel];
    _storeNameLabel.width = [MyUtil labelAutoCalculateRectWith:_storeNameLabel.text FontSize:15 MaxSize:CGSizeMake(150, 40)];
    _storeNameLabel.frame = CGRectMake(20, 10, _storeNameLabel.width, 20);
    _arrowImageView = [MyUtil createImageView:CGRectMake(_storeNameLabel.right, 10, 20, 20) imageName:@"right"];
    [self addSubview:_arrowImageView];
    _storeNameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStoreNameLabel)];
    [_storeNameLabel addGestureRecognizer:tap];
    
    
    _payLabel = [MyUtil createLabel:CGRectZero text:@"待发货" alignment:NSTextAlignmentRight fontSize:13];
    _payLabel.width = [MyUtil labelAutoCalculateRectWith:_payLabel.text FontSize:15 MaxSize:CGSizeMake(100, 40)];
    _payLabel.frame = CGRectMake(self.right - _payLabel.width - 20, 10, _payLabel.width, 20);
    _payLabel.textColor = [UIColor grayColor];
    [self addSubview:_payLabel];
    
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 40, kMainScreenWidth-20, 1 )];
    line.backgroundColor = kNaviTitleColor;
    [self addSubview:line];
}

//未付款
- (void)setup2
{
    _selectImageView = [MyUtil createButton:CGRectMake(10, 10, 20, 20) title:nil BtnImage:@"weixuanzhong"selectImageName:@"xuanzhong" target:self action:@selector(selectAction)];
    //    _selectImageView = [MyUtil createImageView:CGRectMake(10, 10, 20, 20) imageName:@"weixuanzhong"];
    [self addSubview:_selectImageView];
    
    _storeNameLabel = [MyUtil createLabel:CGRectZero text:@"店铺名" alignment:NSTextAlignmentLeft fontSize:15];
    [self addSubview:_storeNameLabel];
    _storeNameLabel.width = [MyUtil labelAutoCalculateRectWith:_storeNameLabel.text FontSize:15 MaxSize:CGSizeMake(150, 40)];
    _storeNameLabel.frame = CGRectMake(_selectImageView.right + 10, 10, _storeNameLabel.width, 20);
    _arrowImageView = [MyUtil createImageView:CGRectMake(_storeNameLabel.right, 10, 20, 20) imageName:@"right"];
    [self addSubview:_arrowImageView];
    _storeNameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStoreNameLabel)];
    [_storeNameLabel addGestureRecognizer:tap];
    
    
    _payLabel = [MyUtil createLabel:CGRectZero text:@"待付款" alignment:NSTextAlignmentRight fontSize:13];
    _payLabel.width = [MyUtil labelAutoCalculateRectWith:_payLabel.text FontSize:15 MaxSize:CGSizeMake(100, 40)];
    _payLabel.frame = CGRectMake(self.right - _payLabel.width - 20, 10, _payLabel.width, 20);
    _payLabel.textColor = kBackgroundColor;
    [self addSubview:_payLabel];
    
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 40, kMainScreenWidth-20, 1 )];
    line.backgroundColor = kNaviTitleColor;
    [self addSubview:line];
}
//未付款
- (void)setup1
{
    _selectImageView = [MyUtil createButton:CGRectMake(10, 10, 20, 20) title:nil BtnImage:@"weixuanzhong"selectImageName:@"xuanzhong" target:self action:@selector(selectAction)];
        //    _selectImageView = [MyUtil createImageView:CGRectMake(10, 10, 20, 20) imageName:@"weixuanzhong"];
    [self addSubview:_selectImageView];
   
    _storeNameLabel = [MyUtil createLabel:CGRectZero text:@"店铺名" alignment:NSTextAlignmentLeft fontSize:15];
    [self addSubview:_storeNameLabel];
    _storeNameLabel.width = [MyUtil labelAutoCalculateRectWith:_storeNameLabel.text FontSize:15 MaxSize:CGSizeMake(150, 40)];
    _storeNameLabel.frame = CGRectMake(_selectImageView.right+ 10, 10, _storeNameLabel.width, 20);
    _arrowImageView = [MyUtil createImageView:CGRectMake(_storeNameLabel.right, 10, 20, 20) imageName:@"right"];
    [self addSubview:_arrowImageView];
    _storeNameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStoreNameLabel)];
    [_storeNameLabel addGestureRecognizer:tap];
    
    
    _payLabel = [MyUtil createLabel:CGRectZero text:@"等待买家付款" alignment:NSTextAlignmentRight fontSize:13];
    _payLabel.width = [MyUtil labelAutoCalculateRectWith:_payLabel.text FontSize:15 MaxSize:CGSizeMake(100, 40)];
    _payLabel.frame = CGRectMake(self.right - _payLabel.width - 20, 10, _payLabel.width, 20);
    _payLabel.textColor = kBackgroundColor;
    [self addSubview:_payLabel];
  
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 40, kMainScreenWidth-20, 1 )];
    line.backgroundColor = kNaviTitleColor;
    [self addSubview:line];
}

- (void)selectAction{
    if ([_delegate respondsToSelector:@selector(clickAction:)]) {
        [_delegate clickAction:self];
    }
}

- (void)tapStoreNameLabel{
    if ([_delegate respondsToSelector:@selector(tapStoreName:)]) {
        [_delegate tapStoreName:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
