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
        
        self.rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
        [self.rightImageView setImage:[UIImage imageNamed:@"home_Pavilion_1"] ];
        self.rightImageView.layer.cornerRadius = 5.0;
        self.rightImageView.layer.masksToBounds = YES;
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 15, 200, 20)];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.text = @"采购棉布，纯棉的哦～";
        
        UILabel *amount = [[UILabel alloc]initWithFrame:CGRectMake(120, 40, 100, 20)];
        amount.text = @"采购数量:";
//        amount.textColor = [UIColor colorWithRed:0.3686 green:0.3686 blue:0.3686 alpha:1];
        amount.font = [UIFont systemFontOfSize:14];
        
        self.amountLabel = [[UILabel alloc]init];
//        self.amountLabel.textColor = [UIColor colorWithRed:0.3686 green:0.3686 blue:0.3686 alpha:1];
        self.amountLabel.font =[UIFont systemFontOfSize:14];
        
        self.unitLabel2 = [[UILabel alloc]init];
//        self.unitLabel2.textColor = [UIColor colorWithRed:0.3686 green:0.3686 blue:0.3686 alpha:1];
        self.unitLabel2.font = [UIFont systemFontOfSize:14];
        
        UILabel *creat = [[UILabel alloc]initWithFrame:CGRectMake(120, 65, 90, 20)];
        creat.text = @"报价截止日期:";
//        creat.textColor = [UIColor colorWithRed:0.3686 green:0.3686 blue:0.3686 alpha:1];
        creat.font = [UIFont systemFontOfSize:14];
        //creat.backgroundColor = [UIColor redColor];
        
        self.creatdateLabel = [[UILabel alloc]initWithFrame:CGRectMake(210, 65, 100, 20)];
//        self.creatdateLabel.textColor = [UIColor colorWithRed:0.3686 green:0.3686 blue:0.3686 alpha:1];
        self.creatdateLabel.font = [UIFont systemFontOfSize:14];
        self.creatdateLabel.text = @"2015-09-16";
        
        self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 90, 100, 20)];
        self.statusLabel.textColor = [UIColor redColor];
        self.statusLabel.font = [UIFont systemFontOfSize:14];
        self.statusLabel.text = @"寻找中";
    
        [self configWithAmount:@"200" unit:@"米"];
        [self addSubview:amount];
        [self addSubview:creat];
        [self addSubview:self.titleLabel];
        [self addSubview:self.statusLabel];
        [self addSubview:self.creatdateLabel];
        [self addSubview:self.amountLabel];
        [self addSubview:self.unitLabel2];
        [self addSubview:self.rightImageView];
    }
    return self;
}



-(void)configWithAmount:(NSString *)amount unit:(NSString *)unit
{
    self.amountLabel.text = amount;
    self.unitLabel2.text = unit;
    CGSize textBlockMinSize = {130, 25};
    CGSize amountsize = [self.amountLabel.text sizeWithFont:self.amountLabel.font constrainedToSize:textBlockMinSize lineBreakMode:NSLineBreakByCharWrapping];
    [self.amountLabel setFrame:CGRectMake(180, 40, amountsize.width, 20)];
    [self.unitLabel2 setFrame:CGRectMake(self.amountLabel.width+180, 40, 35, 20)];
    
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
