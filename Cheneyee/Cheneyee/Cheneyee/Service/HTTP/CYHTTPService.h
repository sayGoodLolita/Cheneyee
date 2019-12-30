//
//  CYHTTPService.h
//  Cheneyee
//
//  Created by Cheney Mars on 2019/6/29.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//  全局用来网络请求的类

#import <AFNetworking/AFNetworking.h>
#import "AFHTTPSessionManager+CYSupport.h"
#import "CYHTTPRequest.h"
#import "CYHTTPResponse.h"

NS_ASSUME_NONNULL_BEGIN

/// 所有 CYHTTPService 错误的 domain
FOUNDATION_EXTERN NSString * const CYHTTPServiceErrorDomain ;

/// 数据解析错误
FOUNDATION_EXTERN NSInteger const CYHTTPServiceErrorJSONParsingFailed ;


@interface CYHTTPService : AFHTTPSessionManager

+ (instancetype)sharedInstance;

/// 当前网络状态
@property (nonatomic, assign) AFNetworkReachabilityStatus reachabilityStatus;

/// 排队请求数据
- (RACSignal *)enqueueRequest:(CYHTTPRequest * _Nonnull)request resultClass:(Class _Nullable)resultClass;

/// 上传数据 fileDatas: 要上传的文件数据, name: 服务器的资源文件名, mimeType: 文件资源类型 http://www.jianshu.com/p/a3e77751d37c 传 nil 默认为 application/octet-stream
- (RACSignal *)enqueueUploadRequest:(CYHTTPRequest * _Nonnull)request resultClass:(Class _Nullable)resultClass fileDatas:(NSArray <NSData *> *)fileDatas name:(NSString * _Nonnull)name mimeType:(NSString *)mimeType;


@end

NS_ASSUME_NONNULL_END
