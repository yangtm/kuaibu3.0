//
//  AddressListCell.h
//  kuaibu
//
//  Created by zxy on 15/9/7.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellHeight 70
@interface AddressListCell : UITableViewCell

- (void)setUIWithName:(NSString *)aName Phone:(NSString *)aPhone address:(NSString *)aAdress isMain:(BOOL)isMain;

@end
