//
//  YHBConnectStoreVeiw.h
//  YHB_Prj
//
//  Created by yato_kami on 15/1/4.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kcStoreHeight 70

@protocol YHBConStoreDelegate <NSObject>
- (void)touchShopDetailCell;
@end

@interface YHBConnectStoreVeiw : UIView

@property (weak, nonatomic) id<YHBConStoreDelegate> delegate;

- (void)setUIWithTitle:(NSString *)title imageUrl:(NSString *)urlstr attention:(NSString *)attention;

@end
