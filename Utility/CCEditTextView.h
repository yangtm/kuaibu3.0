//
//  CCEditTextView.h
//  YHB_Prj
//
//  Created by yato_kami on 14/12/2.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^unary_operation_comfirm)(NSString *text);
typedef void (^unary_operation_cancel)();

@interface CCEditTextView : UIView
#define COMFIRMBLOCK      void(^)(NSString *text)
#define CANCELBLOCK      void(^)()
//错误提示内容
@property (strong, nonatomic) NSString *reminderStr;

//实例方法
+ (instancetype )sharedView;
/**
 *  show this view
 *
 *  @param title       title的文字
 *  @param text        textfield的文字
 *  @param cBlock      点击确定按钮后 执行的block
 *  @param cancleBlock 点击取消按钮后 执行的block
 */
- (void)showEditTextViewWithTitle:(NSString *)title textfieldText:(NSString *)text comfirmBlock: (BOOL(^)(NSString *txt))cBlock cancelBlock:(CANCELBLOCK)cancleBlock;

- (void)showLargeEditTextViewWithTitle:(NSString *)title textfieldText:(NSString *)text comfirmBlock: (BOOL(^)(NSString *txt))cBlock cancelBlock:(CANCELBLOCK)cancleBlock;


@end
