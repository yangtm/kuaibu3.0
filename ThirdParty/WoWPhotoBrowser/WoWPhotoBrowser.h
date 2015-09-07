//
//  WoWPhotoBrowser.h
//  WoWPhotoBrowser
//
//  Created by 童小波 on 15/4/17.
//  Copyright (c) 2015年 tongxiaobo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WoWPhoto.h"

@interface WoWPhotoBrowser : UIViewController

@property (strong, nonatomic)NSArray *photoArray;
@property (assign, nonatomic)NSInteger currentPage;
@property (assign, nonatomic)BOOL enableSave;
@property (strong, nonatomic)void(^cBlock)(NSInteger showIndex);

/**
 *  弹出照片查看器
 *
 *  @param photos 数组的元素必须是WoWPhoto类型
 *  @param index  当前显示的照片序号
 *  @param view
 *  @param cBlock 完成时回调
 */
+ (void)showWithPhotos:(NSArray *)photos
          currentIndex:(NSInteger)index
              showView:(UIView *)view
              complete:(void(^)(NSInteger showIndex))cBlock;

+ (void)setPresentController:(UIViewController *)presentController;
+ (void)setEnableSave:(BOOL)enable;

@end
