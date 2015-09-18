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
        //self.titleLabel.text = @"采购棉布，纯棉的哦～";
        
        UILabel *amount = [[UILabel alloc]initWithFrame:CGRectMake(120, 40, 100, 20)];
        amount.text = @"采购数量:";
//        amount.textColor = [UIColor colorWithRed:0.3686 green:0.3686 blue:0.3686 alpha:1];
        amount.font = [UIFont systemFontOfSize:14];
        
        self.amountLabel = [[UILabel alloc]init];
        self.amountLabel.font =[UIFont systemFontOfSize:14];
        
        self.unitLabel2 = [[UILabel alloc]init];
        self.unitLabel2.font = [UIFont systemFontOfSize:14];
        
        UILabel *creat = [[UILabel alloc]initWithFrame:CGRectMake(120, 65, 90, 20)];
        creat.text = @"报价截止时间:";
        creat.font = [UIFont systemFontOfSize:14];
        
        self.creatdateLabel = [[UILabel alloc]initWithFrame:CGRectMake(210, 65, 100, 20)];
        self.creatdateLabel.font = [UIFont systemFontOfSize:14];
        //self.creatdateLabel.text = @"2015-09-16";
        
        self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 90, 100, 20)];
        self.statusLabel.textColor = [UIColor redColor];
        self.statusLabel.font = [UIFont systemFontOfSize:14];
        self.statusLabel.text = @"寻找中";
    
        self.soundButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 90, 90, 20)];
        [self.soundButton addSubview:self.soundPlayImageView];
        [self.soundButton addTarget:self action:@selector(soundButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.soundButton setBackgroundImage:[UIImage imageNamed:@"sound_image"] forState:UIControlStateNormal];
        
        //[self configWithAmount:@"200" unit:@"米"];
        [self addSubview:amount];
        [self addSubview:creat];
        [self addSubview:self.titleLabel];
        [self addSubview:self.statusLabel];
        [self addSubview:self.creatdateLabel];
        [self addSubview:self.amountLabel];
        [self addSubview:self.unitLabel2];
        [self addSubview:self.rightImageView];
        [self addSubview:self.soundButton];
    }
    return self;
}

- (void)soundButtonClick:(id)sender {
    
    if (_isPlay) {
        [self stopPlaySound];
        if ([_delegate respondsToSelector:@selector(cellDidEndPlaySound:)]) {
            [_delegate cellDidEndPlaySound:self];
        }
    }
    else{
        [self startPlaySound];
        if ([_delegate respondsToSelector:@selector(cellDidBeginPlaySound:)]) {
            [_delegate cellDidBeginPlaySound:self];
        }
    }
    _isPlay = !_isPlay;
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

-(void)configWithAmount:(NSString *)amount unit:(NSString *)unit type:(NSInteger) type
{
    self.amountLabel.text = amount;
    self.unitLabel2.text = unit;
    CGSize textBlockMinSize = {130, 25};
    CGSize amountsize = [self.amountLabel.text sizeWithFont:self.amountLabel.font constrainedToSize:textBlockMinSize lineBreakMode:NSLineBreakByCharWrapping];
    [self.amountLabel setFrame:CGRectMake(180, 40, amountsize.width, 20)];
    [self.unitLabel2 setFrame:CGRectMake(self.amountLabel.width+180, 40, 35, 20)];
    
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
