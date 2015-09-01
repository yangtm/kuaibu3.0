//
//  NetworkService.m
//  LongChouDai
//
//  Created by 夏桂峰 on 15/8/10.
//  Copyright (c) 2015年 隆筹贷. All rights reserved.
//

#import "NetworkService.h"

@implementation NetworkService

/**
 *  异步get请求数据
 *
 *  @param url     地址
 *  @param success 下载成功的回调代码块
 *  @param failure 下载失败的回调代码块
 */
+(void)getDataWithURL:(NSString *)url withSucess:(void (^)(NSData *))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFHTTPResponseSerializer serializer];
    [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
            success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure)
            failure(error);
    }];
}
/**
 *  post请求数据
 *
 *  @param url       url地址
 *  @param paramters 参数字典
 *  @param success   下载成功回调的代码块
 *  @param failure   下载失败的回调代码块
 */
+(void)postWithURL:(NSString *)url paramters:(NSDictionary *)paramters success:(void (^)(NSData *))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFHTTPResponseSerializer serializer];
    [mgr POST:url parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
            success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure)
            failure(error);
    }];
}
/**
 *  上传文件
 *
 *  @param url       url地址
 *  @param paramters 非文件参数
 *  @param fileData  文件
 *  @param success   上传成功调用的代码块
 *  @param failure   上传失败调用的代码块
 */
+(void)uploadFile:(NSString *)url paramters:(NSDictionary *)paramters file:(void (^)(id<AFMultipartFormData>))fileData success:(void (^)(NSData *))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    [mgr POST:url parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(fileData)
            fileData(formData);
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
            success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure)
            failure(error);
    }];
}
@end
