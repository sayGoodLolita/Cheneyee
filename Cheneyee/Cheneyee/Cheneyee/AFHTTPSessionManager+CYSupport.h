//
//  AFHTTPSessionManager+CYSupport.h
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/3.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//  网络请求方法(不携带默认参数)

#import <AFNetworking/AFNetworking.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const RACAFNResponseObjectErrorKey;

@interface AFHTTPSessionManager (CYSupport)

/// 发起 GET 请求, 信号内容包括 NSURLResponse * response, id responseObject
- (RACSignal *)cy_GET:(NSString *)path parameters:(id)parameters;

/// 发起 HEAD 请求, 信号内容包括 NSURLResponse * response, id responseObject
- (RACSignal *)cy_HEAD:(NSString *)path parameters:(id)parameters;

/// 发起 POST 请求, 信号内容包括 NSURLResponse * response, id responseObject
- (RACSignal *)cy_POST:(NSString *)path parameters:(id)parameters;

/// 发起 PUT 请求, 信号内容包括 NSURLResponse * response, id responseObject
- (RACSignal *)cy_PUT:(NSString *)path parameters:(id)parameters;

/// 发起 PATCH 请求, 信号内容包括 NSURLResponse * response, id responseObject
- (RACSignal *)cy_PATCH:(NSString *)path parameters:(id)parameters;

/// 发起 DELETE 请求, 信号内容包括 NSURLResponse * response, id responseObject
- (RACSignal *)cy_DELETE:(NSString *)path parameters:(id)parameters;

/// 发起请求, 信号内容包括 NSURLResponse * response, id responseObject
- (RACSignal *)cy_requestPath:(NSString *)path parameters:(id)parameters method:(NSString *)method;

/// 上传数据, 信号内容包括  NSURLResponse * response, id responseObject
- (RACSignal *)cy_POST:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block;

/// 直接 POST 一个 body 来获取数据, 信号内容包括 NSURLResponse * response, id responseObject
- (RACSignal *)cy_POST:(NSString *)path body:(NSData *)body;

/// 参数加密后发起请求, 信号内容包括 responseObject
- (RACSignal *)cy_POST:(NSString *)path encryptParameters:(NSDictionary *)encryptParameters aKey:(NSString *)aKey;


@end

NS_ASSUME_NONNULL_END
