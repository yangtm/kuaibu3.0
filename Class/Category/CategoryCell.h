//
//  CategoryCell.h
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/18.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (assign, nonatomic) BOOL isSelected;
@end
