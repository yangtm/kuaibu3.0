//
//  ShopingCartListHeaderView.h
//  kuaibu
//
//  Created by 朱新余 on 15/9/28.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopingCartListHeaderView;
@protocol ShopingCartListHeaderViewDelegate <NSObject>

- (BOOL)clickAction:(ShopingCartListHeaderView *)headerView;
- (void)tapStoreName:(ShopingCartListHeaderView *)headerView;

@end
@interface ShopingCartListHeaderView : UIView

@property (nonatomic,strong)UIButton *selectAllButton;
@property (nonatomic,strong) UIImageView *arrowImageView;
@property (nonatomic,strong) UILabel *storeNameLabel;
@property (nonatomic,assign) id<ShopingCartListHeaderViewDelegate>delegate;
@end
