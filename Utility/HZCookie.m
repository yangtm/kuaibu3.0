//
//  HZCookie.m
//  iHuiZhong
//
//  Created by Mike on 15/2/12.
//  Copyright (c) 2015年 惠众金融. All rights reserved.
//

#import "HZCookie.h"
#import "Public.h"



@implementation HZCookie

+(void)saveCookie
{
    //取得cookie
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:kYHBBaseUrl]];
//    NSLog(@"保存的cookie:%@",cookies);
    //转换为data，保存到沙盒
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:__hzUserCookieKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(void)setCookie
{
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:__hzUserCookieKey];
    if([data length])
    {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        NSLog(@"取出的cookie:%@",cookies);
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
}

+(void)removeCookie
{

    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:__hzUserCookieKey];
    if([data length])
    {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        NSLog(@"将要删除的cookie:%@",cookies);
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage]deleteCookie:cookie];
    }
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:__hzUserCookieKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

@end
