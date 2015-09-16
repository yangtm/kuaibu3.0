//
//  YHBSegmentView.h
//  YHB_Prj
//
//  Created by 童小波 on 15/3/25.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YHBSegmentViewStyle) {
    YHBSegmentViewStyleNormal,
    YHBSegmentViewStyleSeparate,
    YHBSegmentViewStyleBorder,
    YHBSegmentViewStyleArrow,
    YHBSegmentViewStyleBottomLine
};

@interface YHBSegmentView : UIControl

- (instancetype)initWithFrame:(CGRect)frame style:(YHBSegmentViewStyle)style;
- (void) addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@property (assign, nonatomic) NSInteger selectItem;
@property (strong, nonatomic) NSArray *titleArray;

@end
