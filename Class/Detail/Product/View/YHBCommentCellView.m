//
//  YHBCommentView.m
//  YHB_Prj
//
//  Created by yato_kami on 15/1/3.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "YHBCommentCellView.h"
#import "UIImageView+WebCache.h"
#define kimgwidth 25
#define kTitleFont 12

@interface YHBCommentCellView()

@property (strong, nonatomic) UIImageView *headImageVeiw;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *commentLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UIView *noCommentView;

@end

@implementation YHBCommentCellView
- (UIImageView *)headImageVeiw
{
    if (!_headImageVeiw) {
        _headImageVeiw = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kimgwidth, kimgwidth)];
        _headImageVeiw.layer.cornerRadius = kimgwidth/2.0f;
        _headImageVeiw.layer.borderWidth = 0.5;
        _headImageVeiw.layer.borderColor = [kLineColor CGColor];
    }
    return _headImageVeiw;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor lightGrayColor];
        _nameLabel.font = [UIFont systemFontOfSize:kTitleFont];
        _nameLabel.backgroundColor = [UIColor clearColor];
    }
    return _nameLabel;
}

- (UILabel *)commentLabel
{
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.textColor = [UIColor blackColor];
        _commentLabel.numberOfLines = 2;
        [_commentLabel setFont:[UIFont systemFontOfSize:kTitleFont]];
    }
    return _commentLabel;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = [UIColor lightGrayColor];
        [_dateLabel setFont:[UIFont systemFontOfSize:kTitleFont-2]];
        _dateLabel.backgroundColor = [UIColor clearColor];
    }
    return _dateLabel;
}

- (UIView *)noCommentView
{
    if (!_noCommentView) {
        _noCommentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _noCommentView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kMainScreenWidth-100)/2.0, self.height/2.0-10, 100, 20)];
        label.font = kFont12;
        label.text = @"暂无评论";
        [_noCommentView addSubview:label];
    }
    return _noCommentView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, kMainScreenWidth, kCommentCellHeight);
        [self creatUI];
    }
    return self;
}

- (void)creatUI
{
    [self addSubview:self.headImageVeiw];
    self.nameLabel.frame = CGRectMake(self.headImageVeiw.right+4, 10, 200, kTitleFont);
    self.nameLabel.centerY = self.headImageVeiw.centerY;
    [self addSubview:self.nameLabel];
    self.commentLabel.frame = CGRectMake(15, self.headImageVeiw.bottom+5, kMainScreenWidth-30, kTitleFont*2.5);
    [self addSubview:self.commentLabel];
    
    self.dateLabel.frame = CGRectMake(10, self.height-kTitleFont-5, kMainScreenWidth-20, kTitleFont);
    [self addSubview:self.dateLabel];
}
- (void)isNoComment
{
    [self addSubview:self.noCommentView];
}

- (void)setUIWithName:(NSString *)name image:(NSString *)urlstr comment:(NSString *)comment date:(NSString *)date
{
    [self.headImageVeiw sd_setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:nil options:SDWebImageCacheMemoryOnly];
    self.nameLabel.text = name;
    self.commentLabel.text = comment;
    self.dateLabel.text = date;
    if (_noCommentView && [_noCommentView superview]) {
        [_noCommentView removeFromSuperview];
    }
}

@end
