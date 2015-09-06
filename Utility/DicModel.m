//
//  DicModel.m
//  kuaibu
//
//  Created by zxy on 15/9/6.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import "DicModel.h"

@implementation DicModel

+ (NSMutableDictionary *)createPostDictionary
{
    
    NSString *nonce = [NSString stringWithFormat:@"%d",arc4random_uniform(1000)+1];
    
    NSString *sign = [[NSString stringWithFormat:@"%@||%@||%@||%@",kAPPID,nonce,[getTimestamp getcurrentTimestamp],kAPPKEY] MD5Hash];
    NSString *newSign = [sign substringWithRange:NSMakeRange(12, 8)];
    NSMutableDictionary *postDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:kAPPID,@"app_id",[getTimestamp getcurrentTimestamp],@"timestamp",nonce,@"nonce",newSign,@"sign", nil];
    return postDic;
}
@end
