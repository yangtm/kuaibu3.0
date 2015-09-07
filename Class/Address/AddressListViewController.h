//
//  AddressListViewController.h
//  kuaibu
//
//  Created by zxy on 15/9/7.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "BaseViewController.h"

@class AddressModel;
@class MineInfoSetViewController;

@protocol AddressListDelegate <NSObject>

//用户选择了一个地址
- (void)choosedAddressModel:(AddressModel *)model;

@end

@interface AddressListViewController : BaseViewController

@property (weak, nonatomic) id<AddressListDelegate> delegate;

//判别是否来自订单确认页
@property (assign, nonatomic) BOOL isfromOrder;
@property (strong, nonatomic) MineInfoSetViewController *infoSetViewController;

@end
