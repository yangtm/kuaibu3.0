//
//  CategoryViewController.h
//  YHB_Prj
//
//  Created by Johnny's on 15/1/15.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "BaseViewController.h"

@interface CategoryViewController : BaseViewController

@property (assign, nonatomic) BOOL isPushed;
@property (assign, nonatomic) BOOL isSingleSelect;

+ (CategoryViewController *)sharedInstancetype;
- (void)setBlock:(void(^)(NSArray *aArray))aBlock;
- (void)cleanAll;

@end
