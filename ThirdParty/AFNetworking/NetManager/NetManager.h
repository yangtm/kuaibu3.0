//
//  NetManager.h
//  JieJiong
//
//  Created by xie licai on 12-12-21.
//  Copyright (c) 2012年 xie licai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyHttpClient.h"

#define SUCCESSBLOCK      void(^)(NSDictionary* successDict)
#define FAILUREBLOCK      void(^)(NSDictionary *failDict, NSError *error)
#define PROGRESSBLOCK     void(^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)

@interface NetManager : NSObject

+ (NetManager *)shareInstance;
- (void)setUserid:(NSInteger)aUserid;
- (void)setLat:(float)alat;
- (void)setLon:(float)alon;
- (void)setAreaId:(NSString *)aAreaId;

//- (void)set
/******************************************************
 *  aDict   body数据 如果没有业务数据此值为nil
 *  aUrl
 *  aMethod
 *  aEncoding
 *  success
 *  failure
 */
+ (void)requestWith:(NSDictionary *)aDict
                url:(NSString *)aUrl
             method:(NSString *)aMethod
       operationKey:(NSString *)aKey
     parameEncoding:(AFHTTPClientParameterEncoding)aEncoding
               succ:(SUCCESSBLOCK)success
            failure:(FAILUREBLOCK)failure;

+ (void)uploadImg:(UIImage*)aImg
       parameters:(NSDictionary*)aParam
        uploadUrl:(NSString*)aUrl
    uploadimgName:(NSString*)aImgname
   parameEncoding:(AFHTTPClientParameterEncoding)aEncoding
    progressBlock:(PROGRESSBLOCK)block
             succ:(SUCCESSBLOCK)success
          failure:(FAILUREBLOCK)failure;

+ (void)uploadImg:(UIImage*)aImg
       parameters:(NSDictionary*)aParam
        uploadUrl:(NSString*)aUrl
             name:(NSString*)name
    uploadimgName:(NSString*)aImgname
   parameEncoding:(AFHTTPClientParameterEncoding)aEncoding
    progressBlock:(PROGRESSBLOCK)block
             succ:(SUCCESSBLOCK)success
          failure:(FAILUREBLOCK)failure;

////支持一次上传多张图片
+ (void)uploadArryImg:(NSArray*)aImgArry
           parameters:(NSDictionary*)aParam
            uploadUrl:(NSString*)aUrl
        uploadimgName:(NSString*)aImgname
       parameEncoding:(AFHTTPClientParameterEncoding)aEncoding
        progressBlock:(PROGRESSBLOCK)block
                 succ:(SUCCESSBLOCK)success
              failure:(FAILUREBLOCK)failure;

+ (void)cancelOperation:(id)aOperationKey;

+ (void)uploadFile:(NSData *)fileData
        parameters:(NSDictionary*)aParam
         uploadUrl:(NSString*)aUrl
    uploadFileName:(NSString*)fileName
    parameEncoding:(AFHTTPClientParameterEncoding)aEncoding
     progressBlock:(PROGRESSBLOCK)block
              succ:(SUCCESSBLOCK)success
           failure:(FAILUREBLOCK)failure;

+ (void)downloadFileWithUrl:(NSString *)aUrl
                 parameters:(NSDictionary *)aParam
              progressBlock:(PROGRESSBLOCK)block
                       succ:(void(^)(NSData *data))success
                    failure:(FAILUREBLOCK)failure;

@end
