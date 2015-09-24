//
//  YHBNumControl.h
//  YHB_Prj
//
//  Created by yato_kami on 15/1/21.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCTextfieldToolView.h"

@protocol YHBNumControlDelegate <NSObject>

- (void)numberControlValueDidChanged;

@end

@interface YHBNumControl : UIView

@property (weak, nonatomic) id<UITextFieldDelegate,YHBNumControlDelegate> delegate;
@property (assign, nonatomic) BOOL isNumFloat;
@property (assign, nonatomic) double number;
@property (strong, nonatomic) UITextField *numberTextfield;

@end
