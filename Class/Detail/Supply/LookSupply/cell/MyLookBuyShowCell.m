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
        
        self.rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
        [self.rightImageView setImage:[UIImage imageNamed:@"home_Pavilion_1"] ];
        self.rightImageView.layer.cornerRadius = 5.0;
        self.rightImageView.layer.masksToBounds = YES;
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 10, 200, 20)];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.text = @"采购棉布，纯棉的哦～";
        
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(120, 30, 30, 20)];
        label.text = @"采购";
       // label.textColor = [UIColor colorWithRed:0.3686 green:0.3686 blue:0.3686 alpha:1];
        label.font = [UIFont systemFontOfSize:14];
        
        self.amountLabel = [[UILabel alloc]init];
        self.amountLabel.textColor = [UIColor redColor];
        self.amountLabel.font = [UIFont systemFontOfSize:14];
        
        self.unitLabel1 = [[UILabel alloc]init];
      //  self.unitLabel1.textColor = [UIColor colorWithRed:0.3686 green:0.3686 blue:0.3686 alpha:1];
        self.unitLabel1.font = [UIFont systemFontOfSize:14];
        
        self.amountStoreLabel = [[UILabel alloc]init];
        self.amountStoreLabel.textColor = [UIColor redColor];
        self.amountStoreLabel.font = [UIFont systemFontOfSize:14];
        
        self.unitLabel2 = [[UILabel alloc]init];
        self.unitLabel2.font = [UIFont systemFontOfSize:14];
        self.unitLabel2.text =@"家供应商";
      //  self.unitLabel2.textColor = [UIColor colorWithRed:0.3686 green:0.3686 blue:0.3686 alpha:1];
        
        self.creatdateLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 70, 100, 20)];
       // self.creatdateLabel.textColor = [UIColor colorWithRed:0.3686 green:0.3686 blue:0.3686 alpha:1];
        self.creatdateLabel.font = [UIFont systemFontOfSize:14];
        self.creatdateLabel.text =@"2015-9-16";
        
        self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 90, 100, 20)];
        self.statusLabel.textColor = [UIColor redColor];
        self.statusLabel.font = [UIFont systemFontOfSize:14];
        self.statusLabel.text = @"寻找中";
        
        self.soundButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 90, 90, 20)];
        [self.soundButton addSubview:self.soundPlayImageView];
        [self.soundButton addTarget:self action:@selector(soundButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.soundButton setBackgroundImage:[UIImage imageNamed:@"sound_image"] forState:UIControlStateNormal];
        
        [self configWithAmount:@"1000" storenum:@"200" unit:@"米" type:1];
        [self addSubview:label];
        [self addSubview:self.unitLabel1];
        [self addSubview:self.unitLabel2];
        [self addSubview:self.amountLabel];
        [self addSubview:self.titleLabel];
        [self addSubview:self.creatdateLabel];
        [self addSubview:self.statusLabel];
        [self addSubview:self.amountStoreLabel];
        [self addSubview:self.rightImageView];
        [self addSubview:self.soundButton];
        
    }
    
    return self;
}

-(void)configWithAmount:(NSString *)amount storenum:(NSString *)number unit:(NSString *)unit type:(NSInteger) type
{
    self.amountLabel.text = amount;
    CGSize textBlockMinSize = {130, 25};
    CGSize amountsize = [self.amountLabel.text sizeWithFont:self.amountLabel.font constrainedToSize:textBlockMinSize lineBreakMode:NSLineBreakByCharWrapping];
    [self.amountLabel setFrame:CGRectMake(150, 30, amountsize.width, 20)];
    [self.unitLabel1 setFrame:CGRectMake(self.amountLabel.width+150, 30, 35, 20)];
    
    self.amountStoreLabel.text = number;
    CGSize amountStoresize = [self.amountStoreLabel.text sizeWithFont:self.amountStoreLabel.font constrainedToSize:textBlockMinSize lineBreakMode:NSLineBreakByCharWrapping];
    [self.amountStoreLabel setFrame:CGRectMake(120, 50, amountsize.width, 20)];
    [self.unitLabel2 setFrame:CGRectMake(self.amountStoreLabel.width+120, 50, 100, 20)];
    
    self.unitLabel1.text = unit;
    switch (type) {
        case 1:
            self.statusLabel.text = @"寻找中";
            break;
        case 2:
            self.statusLabel.text = @"已失效";
            break;
        case 3:
            self.statusLabel.text = @"已找到";
            break;
        case 4:
            self.statusLabel.text = @"已取消";
            break;
        default:
            break;
    }
}

- (void)soundButtonClick:(id)sender {
    
    if (_isPlay) {
        [self stopPlaySound];
        if ([_delegate respondsToSelector:@selector(MycellDidEndPlaySound:)]) {
            [_delegate MycellDidEndPlaySound:self];
        }
    }
    else{
        [self startPlaySound];
        if ([_delegate respondsToSelector:@selector(MycellDidBeginPlaySound:)]) {
            [_delegate MycellDidBeginPlaySound:self];
        }
    }
    _isPlay = !_isPlay;
}

- (void)setIsPlay:(BOOL)isPlay
{
    _isPlay = isPlay;
    if (_isPlay) {
        [self startPlaySound];
    }
    else{
        [self stopPlaySound];
    }
}

- (void)setHasSound:(BOOL)hasSound
{
    _hasSound = hasSound;
    _soundButton.hidden = !hasSound;
}


- (void)startPlaySound
{
    NSArray *array = @[[UIImage imageNamed:@"ReceiverVoiceNodePlaying001"],
                       [UIImage imageNamed:@"ReceiverVoiceNodePlaying002"],
                       [UIImage imageNamed:@"ReceiverVoiceNodePlaying003"]];
    _soundPlayImageView.animationImages = array;
    _soundPlayImageView.contentMode = UIViewContentModeScaleAspectFit;
    _soundPlayImageView.animationDuration = 1.0;
    _soundPlayImageView.animationRepeatCount = 0;
    [_soundPlayImageView startAnimating];
}

- (void)stopPlaySound
{
    [_soundPlayImageView stopAnimating];
    _soundPlayImageView.image = [UIImage imageNamed:@"ReceiverVoiceNodePlaying"];
}

#pragma mark -setters and getters
- (UIImageView *)soundPlayImageView
{
    if (_soundPlayImageView == nil) {
        _soundPlayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 2, 15, 15)];
        _soundPlayImageView.image = [UIImage imageNamed:@"Record_voice_disable"];
        _soundPlayImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _soundPlayImageView;
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
