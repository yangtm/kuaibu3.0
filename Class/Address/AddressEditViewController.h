//
//  AddressEditViewController.h
//  kuaibu
//
//  Created by zxy on 15/9/7.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^success_Handle)();

@class AddressModel;
@interface AddressEditViewController : BaseViewController

- (instancetype)initWithAddressModel:(AddressModel *)model isNew:(BOOL)isnew SuccessHandle:(success_Handle)handel;

@end
