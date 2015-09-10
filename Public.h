//
//  QSS_Public.h
//  Quansoso
//
//  Created by  striveliu on 14-9-13.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#ifndef Public_h
#define Public_h

#define is_IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define kMainScreenHeight [UIScreen mainScreen].bounds.size.height
#define kMainScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kRatio (kMainScreenWidth / 320)

#define DefaultAppDelegate ([UIApplication sharedApplication].delegate)

#define kAPPID (@"iosapp_kuaibu3")
#define kAPPKEY (@"iosapp_kuaibu3_20150001")

//#define EMAppKey @"yibu2015#kuaibudev"
//#define WeixinAppID @"wxdf71533663734340"
#define __hzUserCookieKey @"coolieKey"

#define kYHBBaseUrl @"http://192.168.1.119:8082/kuaibu-appService/"
#define kYHBRequestUrl(path,outUrl) do{\
  outUrl = [NSString stringWithFormat:@"%@%@",kYHBBaseUrl,path];\
}while(0)

#define kZXYFileUrl @"http://192.168.1.119:8080/kuaibu-fileService/"
#define kZXYRequestUrl(path,outUrl) do{\
outUrl = [NSString stringWithFormat:@"%@%@",kZXYFileUrl,path];\
}while(0)

#define isNull(a) [a isKindOfClass:[NSNull class]]

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:a]

#define kSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define kSofterViewsion  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#ifdef DEBUG
#define MLOG(...)  printf("\n\t<%s line%d>\n%s\n", __FUNCTION__,__LINE__,[[NSString stringWithFormat:__VA_ARGS__] UTF8String])

#else
#define MLOG(...)
#endif

#if !defined(DEBUG) && !defined (SD_VERBOSE)
#define NSLog(...)
#endif

#define kNaviTitleColor RGBCOLOR(80,180,220) // 导航栏标题颜色
#define kViewBackgroundColor RGBCOLOR(240,240,240) // 所有屏幕底色
#define kTabbarBackgroundColor RGBCOLOR(249,249,249) //tabbar的背景色
#define kIconNorColor RGBCOLOR(153,153,153) //所有icon未选中的颜色
#define kIconSelectColor RGBCOLOR(254,65,2) //所有icon选中的颜色
#define kLineColor RGBCOLOR(204,204,204) //所有线条的颜色

#define kClearColor [UIColor clearColor]

#define kFont10 [UIFont systemFontOfSize:10]
#define kFont11 [UIFont systemFontOfSize:11]
#define kFont12 [UIFont systemFontOfSize:12]
#define kFont13 [UIFont systemFontOfSize:13]
#define kFont14 [UIFont systemFontOfSize:14]
#define kFont15 [UIFont systemFontOfSize:15]
#define kFont16 [UIFont systemFontOfSize:16]
#define kFont17 [UIFont systemFontOfSize:17]
#define kFont18 [UIFont systemFontOfSize:18]
#define kFont19 [UIFont systemFontOfSize:19]
#define kFont20 [UIFont systemFontOfSize:20]
#define kFont21 [UIFont systemFontOfSize:21]
#define kFont22 [UIFont systemFontOfSize:22]
#define kFont23 [UIFont systemFontOfSize:23]
#define kFont24 [UIFont systemFontOfSize:24]
#define kFont25 [UIFont systemFontOfSize:25]
#define kFont26 [UIFont systemFontOfSize:26]
#define kFont27 [UIFont systemFontOfSize:27]
#define kFont28 [UIFont systemFontOfSize:28]
#define kFont29 [UIFont systemFontOfSize:29]
#define kFont30 [UIFont systemFontOfSize:30]

#define kFontBold13 [UIFont fontWithName:@"Helvetica-Bold" size:13]
#define kFontBold15 [UIFont fontWithName:@"Helvetica-Bold" size:15]
#define kFontBold17 [UIFont fontWithName:@"Helvetica-Bold" size:17]
#define kFontBold18 [UIFont fontWithName:@"Helvetica-Bold" size:18]
#define kFontBold19 [UIFont fontWithName:@"Helvetica-Bold" size:19]
#define kFontBold20 [UIFont fontWithName:@"Helvetica-Bold" size:20]
#define kFontBold21 [UIFont fontWithName:@"Helvetica-Bold" size:21]
#define kFontBold22 [UIFont fontWithName:@"Helvetica-Bold" size:22]
#define kFontBold23 [UIFont fontWithName:@"Helvetica-Bold" size:23]
#define kFontBold24 [UIFont fontWithName:@"Helvetica-Bold" size:24]
#define kFontBold25 [UIFont fontWithName:@"Helvetica-Bold" size:25]

#define kNSUDefaultSaveVauleAndKey(value,key) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]
#define kNSUDefaultReadKey(key) [[NSUserDefaults standardUserDefaults] valueForKey:key]
#define kSafeid(id)  do{\
if(id)\
{\
id = nil;\
}\
}while(0)
#define kIntToString(str,a) do{\
str = [NSString stringWithFormat:@"%d", a];\
}while(0)

#define kFloatToString(str,a) do{\
str=[NSString stringWithFormat:@"%.2f", a];\
}while(0)


#define AssignMentID(l, r) do { \
id V = (r); \
l = (V && !isNull(V) ? V : nil); \
} while(0)

#define AssignMentNSNumber(l, r) do { \
id V = (r); \
l = (V && !isNull(V) ? [V intValue] : 0); \
} while(0)

#define AssignMentNSNumberLong(l, r) do { \
id V = (r); \
l = (V && !isNull(V) ? [V longValue] : 0); \
} while(0)

#define AssignMentNSNumberFloat(l, r) do { \
id V = (r); \
l = (V && !isNull(V) ? [V floatValue] : 0); \
} while(0)

#define AssignMentNSNumberBool(l, r) do { \
id V = (r); \
l = (V && !isNull(V) ? [V boolValue] : 0); \
} while(0)

#define AssignMentNSNumberDouble(l, r) do { \
id V = (r); \
l = (V && !isNull(V) ? [V doubleValue] : 0); \
} while(0)

#define AssignMentNSNumberLonglong(l, r) do { \
id V = (r); \
l = (V && !isNull(V) ? [V longLongValue] : 0); \
} while(0)

#define PacketDictObject(i,dict,key) do { \
if(i) { \
[dict setObject:i forKey:key]; }\
}while(0)



#define PacketDictNumberInt(i, dict,key) do { \
NSNumber *iNum = [NSNumber numberWithInt:i];\
[dict setObject:iNum forKey:key]; \
}while(0)

#define PacketDictNumberFloat(i, dict,key) do { \
NSNumber *iNum = [NSNumber numberWithFloat:i];\
[dict setObject:iNum forKey:key]; \
}while(0)

#define PacketDictNumberDouble(i, dict,key) do { \
NSNumber *iNum = [NSNumber numberWithDouble:i];\
[dict setObject:iNum forKey:key]; \
}while(0)

#define PacketDictNumberBool(i, dict,key) do { \
NSNumber *iNum = [NSNumber numberWithBool:i];\
[dict setObject:iNum forKey:key]; \
}while(0)

#define PacketDictNumberLong(i, dict,key) do { \
NSNumber *iNum = [NSNumber numberWithLong:i];\
[dict setObject:iNum forKey:key]; \
}while(0)

#define PacketDictNumberLongLong(i, dict,key) do { \
NSNumber *iNum = [NSNumber numberWithLongLong:i];\
[dict setObject:iNum forKey:key]; \
}while(0)

//系统消息、商机推荐、报价、订单状态推送用户名


#define KColor kIconSelectColor//RGBCOLOR(225, 44, 25)
#define kNoNet @"你的网络有点问题"
#define kErrorStr ((NSString *)successDict[@"error"])?:@"未知错误"
#define kUnloginErrStr @"未登录"
#define kNoMoreErrStr @"没有更多了"
//系统消息推送账户
#define kServiceUser @"service"

#define kSSKeychainServiceName @"com.yibu.kuaibu"

#define kResult_11_CheckWithAlert if(result>=-19 && result <= -10){[[NSNotificationCenter defaultCenter] postNotificationName:KGlobalResultMessage object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:result],@"result",kErrorStr,@"error", nil]];}
#endif
