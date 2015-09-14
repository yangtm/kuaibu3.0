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

        CGFloat borderWidth = 1.0f;
        UIView *bgView = [[UIView alloc] initWithFrame:frame];
        bgView.layer.borderColor = [UIColor colorWithRed:0.7216 green:0.7255 blue:0.7294 alpha:1].CGColor;
        bgView.layer.borderWidth = borderWidth;
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 5;
        self.backgroundView = bgView;
        
        self.pruductImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,(self.bounds.size.width/2) - 5, self.bounds.size.height)];
        self.pruductImageView.layer.masksToBounds = YES;
        self.pruductImageView.layer.cornerRadius = 5;
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.pruductImageView.bounds.size.width + 5, 3, self.bounds.size.width, self.bounds.size.height/3)];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.pruductImageView.bounds.size.width + 5, self.titleLabel.bounds.size.height + 8,28,self.bounds.size.height/4)];
        label.text = @"价格:";
        label.font = [UIFont systemFontOfSize:11];
        
        self.priceLabel = [[UILabel alloc]init];
        self.priceLabel.font = [UIFont systemFontOfSize:17];
        self.priceLabel.textColor = [UIColor redColor];
        
        UIImageView *attentionImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.pruductImageView.bounds.size.width + 5, self.bounds.size.height *3/4 +4, 12, 9)];
        [attentionImage setImage:[UIImage imageNamed:@"home_attention"]];
        //attentionImage.backgroundColor = [UIColor redColor];
        
        self.attention = [[UILabel alloc]initWithFrame:CGRectMake(self.pruductImageView.bounds.size.width + 19, self.bounds.size.height *3/4 +4, self.bounds.size.width/4, 10)];
        self.attention.font = [UIFont systemFontOfSize:7];
        
        UIImageView *timeImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width*3/4 -2, self.bounds.size.height *3/4 +4, 10, 10)];
        [timeImage setImage:[UIImage imageNamed:@"home_time"]];
        
        self.time = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width*3/4 +10, self.bounds.size.height *3/4 +4, self.bounds.size.width/4, 10)];
        self.time.font = [UIFont systemFontOfSize:7];
        
        self.unitLabel = [[UILabel alloc]init];
        self.unitLabel.text = @"元/m";
        self.unitLabel.font = [UIFont systemFontOfSize:11];
        
        [self addSubview:self.unitLabel];
        [self addSubview:self.priceLabel];
        [self addSubview:self.time];
        [self addSubview:timeImage];
        [self addSubview:self.attention];
        [self addSubview:attentionImage];
        [self addSubview:label];
        [self addSubview:self.titleLabel];
        [self addSubview:self.pruductImageView];
    }
    return self;
}

-(void)configWithPrice:(NSString *)price
{
    self.priceLabel.text = price;
    CGSize textBlockMinSize = {130, 25};
    CGSize pricesize = [self.priceLabel.text sizeWithFont:self.priceLabel.font constrainedToSize:textBlockMinSize lineBreakMode:NSLineBreakByCharWrapping];
    [self.priceLabel setFrame:CGRectMake(self.pruductImageView.bounds.size.width + 5 +28, self.titleLabel.bounds.size.height + 5, pricesize.width, pricesize.height)];
    [self.unitLabel setFrame:CGRectMake(self.pruductImageView.bounds.size.width + 5 +28+ pricesize.width + 2, self.titleLabel.bounds.size.height + 8, 35, self.bounds.size.height/4)];
}

@end
