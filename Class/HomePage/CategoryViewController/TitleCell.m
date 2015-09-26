//
//  TitleCell.m
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/25.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "TitleCell.h"

@implementation TitleCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 1)];
        label.backgroundColor = [UIColor colorWithRed:0.7373 green:0.7373 blue:0.7373 alpha:1];
        [self addSubview:self.titleLabel];
        [self addSubview:label];
        self.backgroundColor = [UIColor colorWithRed:0.8980 green:0.8680 blue:0.8980 alpha:1];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
