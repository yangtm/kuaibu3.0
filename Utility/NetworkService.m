//
//  NetworkService.m
//  LongChouDai
//
//  Created by 夏桂峰 on 15/8/10.
//  Copyright (c) 2015年 隆筹贷. All rights reserved.
//

#import "NetworkService.h"
#import "getTimestamp.h"


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
    NSMutableDictionary *postDic = [DicModel createPostDictionary];
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFHTTPResponseSerializer serializer];
    [mgr GET:url parameters:postDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    NSMutableDictionary *postDic = [DicModel createPostDictionary];
    [postDic addEntriesFromDictionary:paramters];
    
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFHTTPResponseSerializer serializer];
    [mgr POST:url parameters:postDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
            success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure)
            failure(error);
    }];
}

//登入
+(void)loginWithphone:(NSString *)phone password:(NSString *)password success:(void (^)(NSData *receiveData))success failure:(void (^)(NSError *error))failure;
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"memberNameTel",password,@"password", nil];
    NSMutableDictionary *postDic = [DicModel createPostDictionary];
   [postDic addEntriesFromDictionary:dic];

    NSString *loginUrl = nil;
    kYHBRequestUrl(@"member/memberLogin", loginUrl);
    
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFHTTPResponseSerializer serializer];
    [mgr POST:loginUrl parameters:postDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
            success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure)
            failure(error);
    }];
}

//注册
+(void)registerWithPhone:(NSString *)phone checkCode:(NSString *)checkcode passWord:(NSString *)password success:(void (^)(NSData *receiveData))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"memberNameTel",password,@"password",checkcode,@"checkcode", nil];
    NSMutableDictionary *postDic = [DicModel createPostDictionary];
    [postDic addEntriesFromDictionary:dic];
    
    NSString *registerUrl = nil;
    kYHBRequestUrl(@"member/memberRegister", registerUrl);
    
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFHTTPResponseSerializer serializer];
    [mgr POST:registerUrl parameters:postDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
            success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure)
            failure(error);
    }];
}

//获取验证码
+(void)getCheckCodeWithPhone:(NSString *)phone smstpl:(NSString *)sms success:(void (^)(NSData *receiveData))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"memberNameTel",sms,@"zone",nil];
    NSMutableDictionary *postDic = [DicModel createPostDictionary];
    [postDic addEntriesFromDictionary:dic];

    NSString *checkCodeUrl = nil;
    kYHBRequestUrl(@"sendSms/getCheckCode", checkCodeUrl);
    
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFHTTPResponseSerializer serializer];
    [mgr POST:checkCodeUrl parameters:postDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
            success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure)
            failure(error);
    }];
}


//修改密码
+(void)changePassWordWithOldPwd:(NSString *)oldpwd andNewPwd:(NSString *)newpwd success:(void (^)(NSData *receiveData))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:oldpwd,@"oldPassword",newpwd,@"newPassword",nil];
    NSMutableDictionary *postDic = [DicModel createPostDictionary];
    [postDic addEntriesFromDictionary:dic];
   
    NSString *changePassWordUrl = nil;
    kYHBRequestUrl(@"member/saveUpdateMemberPassword", changePassWordUrl);
    
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFHTTPResponseSerializer serializer];
    [mgr POST:changePassWordUrl parameters:postDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
            success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure)
            failure(error);
    }];
}

//忘记密码
+(void)findPasswordWithPhone:(NSString *)phone newPassword:(NSString *)new checkcode:(NSString *)checkcode success:(void (^)(NSData *receiveData))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"memberNameTel",new,@"password",checkcode,@"zone",nil];
    NSMutableDictionary *postDic = [DicModel createPostDictionary];
    [postDic addEntriesFromDictionary:dic];
    NSLog(@".....:%@",postDic);
    NSString *changePassWordUrl = nil;
    kYHBRequestUrl(@"member/forgetPassword", changePassWordUrl);
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFHTTPResponseSerializer serializer];
    [mgr POST:changePassWordUrl parameters:postDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    NSMutableDictionary *postDic = [DicModel createPostDictionary];
    [postDic addEntriesFromDictionary:paramters];
    
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    [mgr POST:url parameters:postDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
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
