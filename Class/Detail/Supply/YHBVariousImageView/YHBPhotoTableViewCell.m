//
//  YHBPhotoTableViewCell.m
//  YHB_Prj
//
//  Created by Johnny's on 14/11/30.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "YHBPhotoTableViewCell.h"
#import "YHBPhotoImageView.h"

@implementation YHBPhotoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        CGFloat photoHeight = (kMainScreenWidth-9)/4;
        int interval = 9/3;
        
        for (int i=0; i<4; i++)
        {
            YHBPhotoImageView *imgView = [[YHBPhotoImageView alloc] initWithFrame:CGRectMake((interval+photoHeight)*i, 0, photoHeight, photoHeight)];
            imgView.tag=i+1;
            [self addSubview:imgView];
        }

    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (point.x<kMainScreenWidth/4)
    {
        _index=0;
    }
    else if(point.x<kMainScreenWidth/2)
    {
        _index=1;
    }
    else if(point.x<kMainScreenWidth*3/4)
    {
        _index=2;
    }
    else if(point.x<kMainScreenWidth)
    {
        _index=3;
    }
    [self.delegate selectCellWithRow:_row index:_index andCell:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
