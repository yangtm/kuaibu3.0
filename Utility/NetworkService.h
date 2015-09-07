//
//  NetworkService.h
//  LongChouDai
//
//  Created by 夏桂峰 on 15/8/10.
//  Copyright (c) 2015年 隆筹贷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "DicModel.h"


@interface NetworkService : NSObject




/**异步get请求数据*/
+(void)getDataWithURL:(NSString *)url withSucess:(void (^)(NSData *receiveData))success failure:(void (^)(NSError *error))failure;

//post请求
+(void)postWithURL:(NSString *)url paramters:(NSDictionary *)paramters success:(void (^)(NSData *receiveData))success failure:(void (^)(NSError *error))failure;

//登入
+(void)loginWithphone:(NSString *)phone password:(NSString *)password success:(void (^)(NSData *receiveData))success failure:(void (^)(NSError *error))failure;

//注册
+(void)registerWithPhone:(NSString *)phone checkCode:(NSString *)checkcode passWord:(NSString *)password success:(void (^)(NSData *receiveData))success failure:(void (^)(NSError *error))failure;

//获取验证码
+(void)getCheckCodeWithPhone:(NSString *)phone smstpl:(NSString *)sms success:(void (^)(NSData *receiveData))success failure:(void (^)(NSError *error))failure;

//修改密码
+(void)changePassWordWithOldPwd:(NSString *)oldpwd andNewPwd:(NSString *)newpwd success:(void (^)(NSData *receiveData))success failure:(void (^)(NSError *error))failure;

//忘记密码
+(void)findPasswordWithPhone:(NSString *)phone newPassword:(NSString *)new checkcode:(NSString *)checkcode success:(void (^)(NSData *receiveData))success failure:(void (^)(NSError *error))failure;

//文件上传
+(void)uploadFile:(NSString *)url paramters:(NSDictionary *)paramters file:(void (^)(id <AFMultipartFormData> formData))fileData success:(void (^)(NSData *receiveData))success failure:(void (^)(NSError *error))failure;

@end
