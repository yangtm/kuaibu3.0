//
//  LookBuyAllShowCell.m
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/15.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "LookBuyAllShowCell.h"

@implementation LookBuyAllShowCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 160, 120)];
        [self.rightImageView setImage:[UIImage imageNamed:@"home_Pavilion_1"] ];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 15, 200, 20)];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.text = @"采购棉布，纯棉的哦～";
        
        UILabel *lastdate = [[UILabel alloc]initWithFrame:CGRectMake(190, 40, 60, 20)];
        lastdate.text = @"采购周期:";
        lastdate.textColor = [UIColor colorWithRed:0.3686 green:0.3686 blue:0.3686 alpha:1];
        lastdate.font = [UIFont systemFontOfSize:13];
        
        self.lastdateLabel = [[UILabel alloc]init];
        self.lastdateLabel.textColor = [UIColor colorWithRed:0.3686 green:0.3686 blue:0.3686 alpha:1];
        self.lastdateLabel.font = [UIFont systemFontOfSize:13];
        
        self.unitLabel1 = [[UILabel alloc]init];
        self.unitLabel1.text = @"天";
        self.unitLabel1.textColor = [UIColor colorWithRed:0.3686 green:0.3686 blue:0.3686 alpha:1];
        self.unitLabel1.font = [UIFont systemFontOfSize:13];
        
        UILabel *amount = [[UILabel alloc]initWithFrame:CGRectMake(190, 60, 60, 20)];
        amount.text = @"采购数量:";
        amount.textColor = [UIColor colorWithRed:0.3686 green:0.3686 blue:0.3686 alpha:1];
        amount.font = [UIFont systemFontOfSize:13];
        
        self.amountLabel = [[UILabel alloc]init];
        self.amountLabel.textColor = [UIColor colorWithRed:0.3686 green:0.3686 blue:0.3686 alpha:1];
        self.amountLabel.font =[UIFont systemFontOfSize:13];
        
        self.unitLabel2 = [[UILabel alloc]init];
        self.unitLabel2.textColor = [UIColor colorWithRed:0.3686 green:0.3686 blue:0.3686 alpha:1];
        self.unitLabel2.font = [UIFont systemFontOfSize:13];
        
        UILabel *creat = [[UILabel alloc]initWithFrame:CGRectMake(190, 80, 60, 20)];
        creat.text = @"发布日期:";
        creat.textColor = [UIColor colorWithRed:0.3686 green:0.3686 blue:0.3686 alpha:1];
        creat.font = [UIFont systemFontOfSize:13];
        
        self.creatdateLabel = [[UILabel alloc]initWithFrame:CGRectMake(255, 80, 100, 20)];
        self.creatdateLabel.textColor = [UIColor colorWithRed:0.3686 green:0.3686 blue:0.3686 alpha:1];
        self.creatdateLabel.font = [UIFont systemFontOfSize:13];
        self.creatdateLabel.text = @"2015-09-16";
        
        self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 105, 100, 20)];
        self.statusLabel.textColor = [UIColor redColor];
        self.statusLabel.font = [UIFont systemFontOfSize:14];
        self.statusLabel.text = @"寻找中";
    
        [self addSubview:amount];
        [self addSubview:lastdate];
        [self addSubview:creat];
        [self addSubview:self.titleLabel];
        [self addSubview:self.statusLabel];
        [self addSubview:self.creatdateLabel];
        [self addSubview:self.amountLabel];
        [self addSubview:self.unitLabel1];
        [self addSubview:self.unitLabel2];
        [self addSubview:self.lastdateLabel];
        [self addSubview:self.rightImageView];
    }
    return self;
}



-(void)configWithLastdate:(NSString *)Lastdate amount:(NSString *)amount unit:(NSString *)unit
{
    self.lastdateLabel.text = Lastdate;
    CGSize textBlockMinSize = {130, 25};
    CGSize lastdatesize = [self.lastdateLabel.text sizeWithFont:self.lastdateLabel.font constrainedToSize:textBlockMinSize lineBreakMode:NSLineBreakByCharWrapping];
    [self.lastdateLabel setFrame:CGRectMake(255, 40, lastdatesize.width, 20)];
    [self.unitLabel1 setFrame:CGRectMake(self.lastdateLabel.width+255, 40, 35, 20)];
    
    self.amountLabel.text = amount;
    CGSize amountsize = [self.amountLabel.text sizeWithFont:self.amountLabel.font constrainedToSize:textBlockMinSize lineBreakMode:NSLineBreakByCharWrapping];
    [self.amountLabel setFrame:CGRectMake(255, 60, amountsize.width, 20)];
    [self.unitLabel2 setFrame:CGRectMake(self.amountLabel.width+255, 60, 35, 20)];
    
    self.unitLabel2.text = unit;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
