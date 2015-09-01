//
//  HZCookie.h
//  iHuiZhong
//
//  Created by Mike on 15/2/12.
//  Copyright (c) 2015年 惠众金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

@interface HZCookie : NSObject

//保存cookie
+(void)saveCookie;

//设置cookie
+(void)setCookie;

//删除cookie
+(void)removeCookie;

@end
