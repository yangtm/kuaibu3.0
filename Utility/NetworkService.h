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

////获取用户信息
//+(void)getMemberWithUrl:(NSString *)phone smstpl:(NSString *)sms success:(void (^)(NSData *receiveData))success failure:(void (^)(NSError *error))failure;

//修改密码
+(void)changePassWordWithOldPwd:(NSString *)oldpwd andNewPwd:(NSString *)newpwd success:(void (^)(NSData *receiveData))success failure:(void (^)(NSError *error))failure;

//忘记密码
+(void)findPasswordWithPhone:(NSString *)phone newPassword:(NSString *)new checkcode:(NSString *)checkcode success:(void (^)(NSData *receiveData))success failure:(void (^)(NSError *error))failure;

//文件上传
+(void)uploadFile:(NSString *)url paramters:(NSDictionary *)paramters file:(void (^)(id <AFMultipartFormData> formData))fileData success:(void (^)(NSData *receiveData))success failure:(void (^)(NSError *error))failure;

/**
 *  上传带图片的内容，允许多张图片上传（URL）POST
 *
 *  @param url                 网络请求地址
 *  @param images              要上传的图片数组（注意数组内容需是图片）
 *  @param parameter           图片数组对应的参数
 *  @param parameters          其他参数字典
 *  @param ratio               图片的压缩比例（0.0~1.0之间）
 *  @param succeedBlock        成功的回调
 *  @param failedBlock         失败的回调
 *  @param uploadProgressBlock 上传进度的回调
 */
+(void)startMultiPartUploadTaskWithURL:(NSString *)url
                           imagesArray:(NSArray *)images
                     parameterOfimages:(NSString *)parameter
                        parametersDict:(NSDictionary *)parameters
                      compressionRatio:(float)ratio
                          succeedBlock:(void(^)(id operation, id responseObject))succeedBlock
                           failedBlock:(void(^)(id operation, NSError *error))failedBlock
                   uploadProgressBlock:(void(^)(float uploadPercent,long long totalBytesWritten,long long totalBytesExpectedToWrite))uploadProgressBlock;

@end
