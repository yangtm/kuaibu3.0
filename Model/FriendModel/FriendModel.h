//
//  FriendModel.h
//  kuaibu
//
//  Created by zxy on 15/8/21.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendModel : NSObject

@property (strong, nonatomic) NSString *friendId;
@property (strong, nonatomic) NSString *memberId;
@property (strong, nonatomic) NSString *friendMemberId;
@property (strong, nonatomic) NSString *groupId;
@property (strong, nonatomic) NSString *remark;
@property (assign, nonatomic) BOOL *isBlackList;
@property (strong, nonatomic) NSString *source;


@end
