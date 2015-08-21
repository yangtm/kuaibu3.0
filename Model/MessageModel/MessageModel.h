//
//  MessageModel.h
//  kuaibu
//
//  Created by zxy on 15/8/21.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (strong, nonatomic) NSString *messageId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *messageType;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *fromMemberId;
@property (strong, nonatomic) NSString *fromMemberName;
@property (strong, nonatomic) NSString *toMemberId;
@property (strong, nonatomic) NSString *toMemberName;
@property (strong, nonatomic) NSString *createDatetime;
@property (strong, nonatomic) NSString *ip;
@property (strong, nonatomic) NSString *tatus;
@property (strong, nonatomic) NSString *parentMessageId;

@end
