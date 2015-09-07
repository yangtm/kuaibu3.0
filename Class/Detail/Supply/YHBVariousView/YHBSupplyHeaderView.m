//
//  YHBSupplyHeaderView.m
//  YHB_Prj
//
//  Created by 童小波 on 15/3/20.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "YHBSupplyHeaderView.h"

@implementation YHBSupplyHeaderView

- (instancetype) initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.dateLabel = [[UILabel alloc] init];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        self.dateLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:self.dateLabel];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.dateLabel.frame = self.bounds;
}

@end
