//
//  MyButton.h
//  kuaibu
//
//  Created by zxy on 15/9/8.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyButton : UIControl

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *imageView;

/**按钮初始化方法*/
-(instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName text:(NSString *)text;
@end
