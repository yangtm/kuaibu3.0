//
//  HomePageLatestBuyCell.m
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/12.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "HomePageLatestBuyCell.h"

@implementation HomePageLatestBuyCell
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat borderWidth = 1.0f;
        UIView *bgView = [[UIView alloc] initWithFrame:frame];
        bgView.layer.borderColor = [UIColor colorWithRed:0.7216 green:0.7255 blue:0.7294 alpha:1].CGColor;
        bgView.layer.borderWidth = borderWidth;
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 5;
        self.backgroundView = bgView;
        
        self.pruductImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,self.bounds.size.width, self.bounds.size.height/2+30)];
        self.pruductImageView.layer.masksToBounds = YES;
        self.pruductImageView.layer.cornerRadius = 5;
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.bounds.size.height/2+35, self.bounds.size.width-20, 20)];
        self.titleLabel.font = [UIFont systemFontOfSize:14];

        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, self.bounds.size.height/2+55,28,20)];
        label.text = @"采购";
        label.font = [UIFont systemFontOfSize:11];
        
        self.lengthLabel = [[UILabel alloc]init];
        self.lengthLabel.font = [UIFont systemFontOfSize:12];
        self.lengthLabel.textColor = [UIColor redColor];
     
        self.unitLabel = [[UILabel alloc]init];
        self.unitLabel.text = @"米";
        self.unitLabel.font = [UIFont systemFontOfSize:11];
        
        [self addSubview:label];
        [self addSubview:self.lengthLabel];
        [self addSubview:self.unitLabel];
        [self addSubview:self.titleLabel];
        [self addSubview:self.pruductImageView];
    }
    return self;
}

-(void)configWithLength:(NSString *)length
{
    self.lengthLabel.text = length;
    CGSize textBlockMinSize = {130, 25};
    CGSize pricesize = [self.lengthLabel.text sizeWithFont:self.lengthLabel.font constrainedToSize:textBlockMinSize lineBreakMode:NSLineBreakByCharWrapping];
    [self.lengthLabel setFrame:CGRectMake(45, self.bounds.size.height/2+55, pricesize.width, 20)];
    [self.unitLabel setFrame:CGRectMake(self.lengthLabel.width+50, self.bounds.size.height/2+55, 35, 20)];
}
@end
