//
//  MyLookBuyShowCell.m
//  kuaibu
//
//  Created by 孙琴琴 on 15/9/15.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "MyLookBuyShowCell.h"

@implementation MyLookBuyShowCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 160, 120)];
        [self.rightImageView setImage:[UIImage imageNamed:@"home_Pavilion_1"] ];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 15, 200, 20)];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.text = @"采购棉布，纯棉的哦～";
        
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(190, 40, 30, 20)];
        label.text = @"采购";
        label.textColor = [UIColor colorWithRed:0.3686 green:0.3686 blue:0.3686 alpha:1];
        label.font = [UIFont systemFontOfSize:13];
        
        self.amountLabel = [[UILabel alloc]init];
        self.amountLabel.textColor = [UIColor redColor];
        self.amountLabel.font = [UIFont systemFontOfSize:13];
        
        self.unitLabel1 = [[UILabel alloc]init];
        self.unitLabel1.textColor = [UIColor colorWithRed:0.3686 green:0.3686 blue:0.3686 alpha:1];
        self.unitLabel1.font = [UIFont systemFontOfSize:13];
        
        self.amountStoreLabel = [[UILabel alloc]init];
        self.amountStoreLabel.textColor = [UIColor redColor];
        self.amountStoreLabel.font = [UIFont systemFontOfSize:13];
        
        self.unitLabel2 = [[UILabel alloc]init];
        self.unitLabel2.font = [UIFont systemFontOfSize:13];
        self.unitLabel2.text =@"家供应商";
        self.unitLabel2.textColor = [UIColor colorWithRed:0.3686 green:0.3686 blue:0.3686 alpha:1];
        
        self.creatdateLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 80, 100, 20)];
        self.creatdateLabel.textColor = [UIColor colorWithRed:0.3686 green:0.3686 blue:0.3686 alpha:1];
        self.creatdateLabel.font = [UIFont systemFontOfSize:13];
        self.creatdateLabel.text =@"2015-9-16";
        
        self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 105, 100, 20)];
        self.statusLabel.textColor = [UIColor redColor];
        self.statusLabel.font = [UIFont systemFontOfSize:14];
        self.statusLabel.text = @"寻找中";
        
        [self addSubview:label];
        [self addSubview:self.unitLabel1];
        [self addSubview:self.unitLabel2];
        [self addSubview:self.amountLabel];
        [self addSubview:self.titleLabel];
        [self addSubview:self.creatdateLabel];
        [self addSubview:self.statusLabel];
        [self addSubview:self.amountStoreLabel];
        [self addSubview:self.rightImageView];
        
    }
    
    return self;
}

-(void)configWithAmount:(NSString *)amount storenum:(NSString *)number unit:(NSString *)unit
{
    self.amountLabel.text = amount;
    CGSize textBlockMinSize = {130, 25};
    CGSize amountsize = [self.amountLabel.text sizeWithFont:self.amountLabel.font constrainedToSize:textBlockMinSize lineBreakMode:NSLineBreakByCharWrapping];
    [self.amountLabel setFrame:CGRectMake(220, 40, amountsize.width, 20)];
    [self.unitLabel1 setFrame:CGRectMake(self.amountLabel.width+225, 40, 35, 20)];
    
    self.amountStoreLabel.text = number;
    CGSize amountStoresize = [self.amountStoreLabel.text sizeWithFont:self.amountStoreLabel.font constrainedToSize:textBlockMinSize lineBreakMode:NSLineBreakByCharWrapping];
    [self.amountStoreLabel setFrame:CGRectMake(190, 60, amountsize.width, 20)];
    [self.unitLabel2 setFrame:CGRectMake(self.amountStoreLabel.width+190, 60, 100, 20)];
    
    self.unitLabel1.text = unit;
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
