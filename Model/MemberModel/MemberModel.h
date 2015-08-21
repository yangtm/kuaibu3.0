//
//  MemberModel.h
//  kuaibu
//
//  Created by zxy on 15/8/21.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberModel : NSObject

@property (strong, nonatomic) NSString *memberId;
@property (strong, nonatomic) NSString *picture;
@property (strong, nonatomic) NSString *memberName;
@property (strong, nonatomic) NSString *sex;
@property (strong, nonatomic) NSString *authenticationType;
@property (strong, nonatomic) NSString *authenticationState;
@end
