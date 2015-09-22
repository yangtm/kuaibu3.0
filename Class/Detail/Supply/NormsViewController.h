//
//  NormsViewController.h
//  kuaibu
//
//  Created by zxy on 15/9/22.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "BaseViewController.h"
#import "NormsManager.h"

@interface NormsViewController : BaseViewController
- (void)useBlock:(void(^)(NSArray *normsArray))aBlock;

- (void)strBlock:(void(^)(NSString *title))aBlock;

@property (nonatomic,strong) NormsManager *manager;
@end
