//
//  AddressListCell.m
//  kuaibu
//
//  Created by zxy on 15/9/7.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "AddressListCell.h"
#define ktitlefont 14
#define ksmallfont 12
@interface AddressListCell ()<UIActionSheetDelegate>

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *phoneLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *defaultLabel;

@end

@implementation AddressListCell

- (UILabel *)defaultLabel
{
    if (!_defaultLabel) {
        _defaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.nameLabel.bottom+6, 40, ksmallfont)];
        _defaultLabel.backgroundColor = [UIColor clearColor];
        _defaultLabel.textColor = KColor;
        _defaultLabel.font = [UIFont systemFontOfSize:ksmallfont];
        _defaultLabel.textAlignment = NSTextAlignmentLeft;
        _defaultLabel.text = @"[默认]";
    }
    return _defaultLabel;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, ktitlefont)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:ktitlefont];
    }
    return _nameLabel;
}

- (UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-10-150, 10, 150, ktitlefont)];
        _phoneLabel.backgroundColor = [UIColor clearColor];
        _phoneLabel.textColor = [UIColor blackColor];
        _phoneLabel.font = [UIFont systemFontOfSize:ktitlefont];
        _phoneLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _phoneLabel;
}

- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.defaultLabel.right, self.defaultLabel.top, kMainScreenWidth-self.defaultLabel.right-40, 20)];
        _addressLabel.backgroundColor = [UIColor clearColor];
        _addressLabel.textColor = [UIColor lightGrayColor];
        _addressLabel.font = [UIFont systemFontOfSize:ksmallfont];
        _addressLabel.numberOfLines = 2;
    }
    return _addressLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.phoneLabel];
        [self.contentView addSubview:self.defaultLabel];
        self.defaultLabel.hidden = YES;
        [self.contentView addSubview:self.addressLabel];
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    return self;
}

- (void)setUIWithName:(NSString *)aName Phone:(NSString *)aPhone address:(NSString *)aAdress isMain:(BOOL)isMain
{
    self.nameLabel.text = aName;
    self.phoneLabel.text = aPhone;
    self.defaultLabel.hidden = !isMain;
    
    CGRect frame = self.addressLabel.frame;
    CGSize size = [aAdress sizeWithFont:self.addressLabel.font constrainedToSize:CGSizeMake(frame.size.width, ksmallfont * 2.5)];
    frame.size = CGSizeMake(frame.size.width, size.height);
    self.addressLabel.frame = frame;
    self.addressLabel.text = aAdress;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
