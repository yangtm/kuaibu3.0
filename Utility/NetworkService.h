//
//  NetworkService.h
//  LongChouDai
//
//  Created by 夏桂峰 on 15/8/10.
//  Copyright (c) 2015年 隆筹贷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@interface NetworkService : NSObject


/**异步get请求数据*/
+(void)getDataWithURL:(NSString *)url withSucess:(void (^)(NSData *receiveData))success failure:(void (^)(NSError *error))failure;
//post请求
+(void)postWithURL:(NSString *)url paramters:(NSDictionary *)paramters success:(void (^)(NSData *receiveData))success failure:(void (^)(NSError *error))failure;
//文件上传
+(void)uploadFile:(NSString *)url paramters:(NSDictionary *)paramters file:(void (^)(id <AFMultipartFormData> formData))fileData success:(void (^)(NSData *receiveData))success failure:(void (^)(NSError *error))failure;

@end
