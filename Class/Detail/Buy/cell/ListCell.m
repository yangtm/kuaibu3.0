//
//  ListCell.m
//  kuaibu
//
//  Created by zxy on 15/9/11.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "ListCell.h"

@implementation ListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _rightImageView.frame = CGRectMake(10, 10, 120, 120);
    _cycleLabel.frame = CGRectMake(_rightImageView.right + 10, 10, kMainScreenWidth - 20, 20);
    _numberLabel.frame = CGRectMake(_rightImageView.right + 10, _cycleLabel.bottom + 5, kMainScreenWidth - 20, 20);
    _dateLabel.frame = CGRectMake(_rightImageView.right + 10, _numberLabel.bottom + 5, kMainScreenWidth - 20, 20);
    _indexLabel.frame = CGRectMake(_rightImageView.right + 10, _dateLabel.bottom + 5, kMainScreenWidth - 20, 20);
    _typeLabel.frame = CGRectMake(_rightImageView.right + 10, _indexLabel.bottom + 5, 70, 20);
    _clickBtn.frame = CGRectMake(_typeLabel.right + 30, _indexLabel.bottom + 5, 70, 20);
}

- (void)setup
{
    _rightImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _rightImageView.layer.cornerRadius = 5.0;
    _rightImageView.layer.masksToBounds = YES;
    _rightImageView.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:_rightImageView];
    
    _cycleLabel = [self formTitleLabel:CGRectZero title:nil];
    [self.contentView addSubview:_cycleLabel];
    
    _numberLabel = [self formTitleLabel:CGRectZero title:nil];
    [self.contentView addSubview:_numberLabel];
    
    _dateLabel = [self formTitleLabel:CGRectZero title:nil];
    [self.contentView addSubview:_dateLabel];
    
    _indexLabel = [self formTitleLabel:CGRectZero title:nil];
    [self.contentView addSubview:_indexLabel];
    
    _typeLabel = [self formTitleLabel:CGRectZero title:nil];
    _typeLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:_typeLabel];
    
    _clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_clickBtn setTitle:@"报价管理" forState:UIControlStateNormal];
    [_clickBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _clickBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    _clickBtn.backgroundColor = RGBCOLOR(250, 228, 182);
    _clickBtn.layer.cornerRadius = 6.0;
    [_clickBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_clickBtn];
    
    
}

- (void)setCycleStr:(NSString *)cycleStr{
    _cycleStr = cycleStr;
    _cycleLabel.text = _cycleStr;
}

- (void)setDataStr:(NSString *)dataStr
{
    _dataStr = dataStr;
    _dateLabel.text = _dataStr;
}

- (void)setIndexStr:(NSString *)indexStr
{
    _indexStr = indexStr;
    _indexLabel.text = _indexStr;
}

- (void)setTypeStr:(NSString *)typeStr
{
    _typeStr = typeStr;
    _typeLabel.text = _typeStr;
}

-(void)setNumberStr:(double )numberStr
{
    _numberStr = numberStr;
    _numberLabel.text = [NSString stringWithFormat:@"采购数量 : %d",(int)_numberStr];
}


- (UILabel *)formTitleLabel:(CGRect)frame title:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:14];
    label.text = title;
    return label;
}

@end