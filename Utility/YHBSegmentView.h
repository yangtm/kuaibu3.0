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

@protocol YHBSegmentViewDelegate <NSObject>
- (void)getDataWithPageID:(NSInteger)pageid catIds:(NSArray *)catIds;
@end

@interface YHBSegmentView : UIControl

- (instancetype)initWithFrame:(CGRect)frame style:(YHBSegmentViewStyle)style;
- (void) addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@property (assign, nonatomic) NSInteger selectItem;
@property (strong, nonatomic) NSArray *titleArray;
@property (assign, nonatomic) BOOL price;
@property(strong,nonatomic) id<YHBSegmentViewDelegate>segmentViewDelegate;
@end
