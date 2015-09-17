//
//  NSDate+extensions.m
//  YHB_Prj
//
//  Created by 童小波 on 15/3/19.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "NSDate+extensions.h"

@implementation NSDate (extensions)

+ (NSDate*) dateFromString:(NSString *)dateString
{
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

@end
