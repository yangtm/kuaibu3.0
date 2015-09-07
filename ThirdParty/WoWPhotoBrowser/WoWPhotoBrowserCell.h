//
//  WoWPhotoBrowserCell.h
//  WoWPhotoBrowser
//
//  Created by 童小波 on 15/4/20.
//  Copyright (c) 2015年 tongxiaobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WoWPhotoBrowserCellDelegate;

@interface WoWPhotoBrowserCell : UICollectionViewCell<UIScrollViewDelegate>{
    UIScrollView *_scrollView;
    UIImageView *_imageView;
    CGFloat _currentScale;
}

@property (assign, nonatomic) id<WoWPhotoBrowserCellDelegate> delegate;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSURL *fileUrl;
//恢复原来比例
- (void)recovery;

@end

@protocol WoWPhotoBrowserCellDelegate <NSObject>

- (void)singleTap;

@end
