//
//  YHBSelColorCell.h
//  YHB_Prj
//
//  Created by yato_kami on 15/1/14.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCellHeight 100
enum cellPart
{
    left_part = 0,
    mid_part,
    right_part
};
@protocol YHBSelColorCellDelefate<NSObject>
//点选某一块
- (void)selectCellPartWithIndexPath:(NSIndexPath *)indexPath part:(NSInteger)part imgView:(UIImageView *)imageView;
//长按某一块
- (void)longPressCellPartWithIndexPath:(NSIndexPath *)indexPath part:(NSInteger)part imgView: (UIImageView *)imagView;

@end

@interface YHBSelColorCell : UITableViewCell

@property (weak, nonatomic) id<YHBSelColorCellDelefate> delegate;
@property (strong, nonatomic) NSMutableArray *titleLabelArray;
@property (strong, nonatomic) NSMutableArray *imageViewArray;
@property (strong, nonatomic) NSIndexPath* cellIndexPath;// 必须设置
//设置UI，当title = nil时，空白显示
- (void)setUIwithTitle:(NSString *)title image:(NSString *)urlStr part:(int)part;

@end
