//
//  BaseViewController.h
//  kuaibu3.0
//
//  Created by zxy on 15/8/20.
//  Copyright (c) 2015年 zxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobClick.h"
#import "MJRefresh.h"

@interface BaseViewController : UIViewController
{
    MJRefreshHeaderView *_headerView;
    MJRefreshFooterView *_footerView;
     BOOL _isLoading;
}
@property (nonatomic, assign) CGFloat g_OffsetY;
@property (nonatomic, strong) UIImage *backgroundimg;
@property (nonatomic ,strong) UIButton *rightButton;
@property (nonatomic, strong) UIImageView *bgImageView;

- (void)setLeftButton:(UIImage *)aImg
                title:(NSString *)aTitle
               target:(id)aTarget
               action:(SEL)aSelector;
- (void)setRightButton:(UIImage *)aImg
                 title:(NSString *)aTitle
                target:(id)aTarget
                action:(SEL)aSelector;
- (void)settitleLabel:(NSString*)aTitle;
- (void)pushView:(UIView*)aView;

- (void)popView:(UIView*)aView completeBlock:(void(^)(BOOL isComplete))aCompleteblock;

/**
 *  警告视图
 *
 *  @param message   警告信息
 *  @param automatic 警告视图是否自动消失
 */
-(void)showAlertWithMessage:(NSString *)message automaticDismiss:(BOOL)automatic;

/**
 *  消失警告视图
 *
 *  @param alert 警告视图
 */
-(void)dismissAlertView:(UIAlertView *)alert;


@end
