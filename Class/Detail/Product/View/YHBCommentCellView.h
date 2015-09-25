//
//  YHBCommentView.h
//  YHB_Prj
//
//  Created by yato_kami on 15/1/3.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCommentCellHeight 90

@interface YHBCommentCellView : UIView

- (void)setUIWithName:(NSString *)name image:(NSString *)urlstr comment:(NSString *)comment date:(NSString *)date;

- (void)isNoComment;

@end
