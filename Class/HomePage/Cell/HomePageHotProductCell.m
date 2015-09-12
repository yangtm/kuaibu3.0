//
//  HomePageHotProductCell.m
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/11.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "HomePageHotProductCell.h"

@implementation HomePageHotProductCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.pruductImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,(self.bounds.size.width/2) - 5, self.bounds.size.height)];
        self.pruductImageView.layer.masksToBounds = YES;
        self.pruductImageView.layer.cornerRadius = 5;
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.pruductImageView.bounds.size.width + 5, 3, self.bounds.size.width/2, self.bounds.size.height/3)];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.pruductImageView.bounds.size.width + 5, self.titleLabel.bounds.size.height + 5,28,self.bounds.size.height/4)];
        label.text = @"价格:";
        label.font = [UIFont systemFontOfSize:11];
        label.backgroundColor = [UIColor redColor];
        
        self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.pruductImageView.bounds.size.width + 5 +label.bounds.size.width,self.titleLabel.bounds.size.height + 1, 50, self.bounds.size.height/3)];
        self.priceLabel.font = [UIFont systemFontOfSize:15];
        self.priceLabel.backgroundColor = [UIColor redColor];
        
        CGSize textBlockMinSize = {130, 25};
        CGSize price = [self.priceLabel.text sizeWithFont:self.priceLabel.font constrainedToSize:textBlockMinSize lineBreakMode:NSLineBreakByCharWrapping];
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(self.pruductImageView.bounds.size.width + 5 +label.bounds.size.width + price.width, self.titleLabel.bounds.size.height + 5, 30, self.bounds.size.height/4)];
        label1.text = @"元/m";
        label1.font = [UIFont systemFontOfSize:11];
        
        [self addSubview:label1];
        [self addSubview:self.priceLabel];
        [self addSubview:label];
        [self addSubview:self.titleLabel];
        [self addSubview:self.pruductImageView];
        
        
    }
    
    
    return self;
}


@end
