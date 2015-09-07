//
//  YHBPictureAdder.h
//  YHB_Prj
//
//  Created by 童小波 on 15/5/15.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHBPictureAdder : UIView

/**
 *  获取imageArray时，第一张默认为封面
 */
@property (strong, nonatomic) UIViewController *contentController;
@property (strong, nonatomic) NSArray *imageArray;
@property (assign, nonatomic) NSInteger maxImageNum;
@property (assign, nonatomic, readonly) NSInteger imageCount;
@property (assign, nonatomic) BOOL enableEdit;
@property (assign, nonatomic) BOOL enableSaveImage;

- (instancetype) initWithFrame:(CGRect)frame contentController:(UIViewController *)viewController;

@end

@protocol YHBPictureAdderDelegate <NSObject>



@end
