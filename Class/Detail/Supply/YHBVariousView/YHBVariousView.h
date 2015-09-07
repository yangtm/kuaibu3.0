//
//  YHBVariousView.h
//  TestButton
//
//  Created by Johnny's on 14/11/17.
//  Copyright (c) 2014年 Johnny's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewAdditions.h"

@interface YHBVariousView : UIView<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, assign) NSUInteger selectedItem;
@property(nonatomic, strong) NSArray *itemArray;
@property(nonatomic, assign) CGRect trueFrame;
@property(nonatomic, assign) CGRect hideFrame;
@property(nonatomic, assign) CGRect trueViewFrame;
@property(nonatomic, assign) CGRect hideViewFrame;
@property(nonatomic, assign) BOOL isExtend;
@property(nonatomic, strong) UILabel *itemLabel;
@property(nonatomic, strong) UITableView *showItemTableView;
@property(nonatomic, strong) UIImageView *backImg;
@property(nonatomic, strong) UIImageView *indicateImageView;

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame andItemArray:(NSArray *)aItemArray andSelectedItem:(int)aSelectedIndex;
- (void)setAItemArray:(NSArray *)aItemArray andSelectedItem:(int)aSelectedIndex;
@end
