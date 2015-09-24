//
//  YHBPdtInfoView.h
//  YHB_Prj
//
//  Created by yato_kami on 15/1/3.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kProductInfoViewHeight 115
#define kTitlefont 14

@interface YHBPdtInfoView : UIView

@property (strong, nonatomic) UIButton *privateButton;

- (void)setTitle:(NSString *)title price:(NSString *)price sale:(NSString *)sale;

@end
