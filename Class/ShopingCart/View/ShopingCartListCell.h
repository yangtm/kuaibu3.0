//
//  ShopingCartListCell.h
//  kuaibu
//
//  Created by 朱新余 on 15/9/28.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHBNumControl.h"

@class ShopingCartListCell;
@protocol ShopingCartListCellDelegate <NSObject>

//- (void)numberControlValueDidChanged:(ShopingCartListCell *)cell;
- (void)clickSelectBtn:(ShopingCartListCell *)cell;
- (void)clickIncreaseBtn:(ShopingCartListCell *)cell;
- (void)clickReduceBtn:(ShopingCartListCell *)cell;

@end


@interface ShopingCartListCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic,strong)UIButton *selectButton;
@property (nonatomic,strong)UIImageView *productImage;
@property (nonatomic,strong)UILabel *detailLabel;
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)UIButton *reduceButton;
@property (nonatomic,strong)UIButton *increaseButton;
@property (nonatomic,strong)UITextField *showTextField;
@property (assign, nonatomic) NSInteger number;
//@property (nonatomic,strong) YHBNumControl *numControl;

@property (nonatomic,assign) id<ShopingCartListCellDelegate,UITextFieldDelegate>delegate;
@end
