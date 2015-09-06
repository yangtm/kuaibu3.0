//
//  getTimestamp.m
//  iHuiZhongApp
//
//  Created by Mike on 15/2/3.
//  Copyright (c) 2015年 HuiZhong,Inc. All rights reserved.
//

#import "getTimestamp.h"

@implementation getTimestamp

+(NSString*)getcurrentTimestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%f",time];
    NSString *timestamp = [timeStr componentsSeparatedByString:@"."][0]; //精确到秒
    return timestamp;
    
}

@end

