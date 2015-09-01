//
//  MineHeadView.h
//  YHB_Prj
//
//  Created by 童小波 on 15/5/18.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MineHeadViewType) {
    MineHeadViewTypeBuyer,
    MineHeadViewTypeSeller,
    MineHeadViewTypeWithTitle,
};

@protocol MineHeadViewDelegate;

@interface MineHeadView : UIView

@property (assign, nonatomic) id<MineHeadViewDelegate> delegate;
@property (strong, nonatomic) UIImageView *backgroudImageView;
@property (strong, nonatomic) UIImageView *portraitImageView;
@property (assign, nonatomic) BOOL isLogin;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) NSArray *numOfOrderArray;
@property (assign, nonatomic) MineHeadViewType type;
@property (strong, nonatomic) UIImageView *titleImageView;

- (instancetype)initWithFrame:(CGRect)frame type:(MineHeadViewType)type;

@end

@protocol MineHeadViewDelegate <NSObject>

@optional
- (void) mineHeadViewPortraitDidTap:(MineHeadView *)headView;
- (void) mineHeadViewButtonDidTap:(MineHeadView *)headView buttonNum:(NSInteger)num;

@end
