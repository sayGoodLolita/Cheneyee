//
//  CYHTTPService.m
//  Cheneyee
//
//  Created by Cheney Mars on 2019/6/29.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYHTTPService.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "AFHTTPSessionManager+CYSupport.h"

NSString * const CYHTTPServiceErrorDomain = @"CYHTTPServiceErrorDomain";

NSInteger const CYHTTPServiceErrorJSONParsingFailed = 669;

@interface CYHTTPService ()

@end

@implementation CYHTTPService

static CYHTTPService * service = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [self.alloc initWithBaseURL:[NSURL URLWithString:CYHTTPServiceBaseUrl] sessionConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
    });
    return service;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [super allocWithZone:zone];
    });
    return service;
}

- (id)copyWithZone:(NSZone *)zone {
    return service;
}

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self) {
        AFJSONResponseSerializer * responseSerializer = AFJSONResponseSerializer.serializer;
#if DEBUG
        // 把 NSNull 转化为 nil
        responseSerializer.removesKeysWithNullValues = NO;
#else
        responseSerializer.removesKeysWithNullValues = YES;
#endif
        responseSerializer.readingOptions = NSJSONReadingAllowFragments;
        // config
        self.responseSerializer = responseSerializer;
        self.requestSerializer = AFHTTPRequestSerializer.serializer;
        // 网络安全策略
        AFSecurityPolicy * securityPolicy = AFSecurityPolicy.defaultPolicy;
        // allowInvalidCertificates: 是否允许无效证书 (自建证书), 默认 NO
        securityPolicy.allowInvalidCertificates = YES;
        // validatesDomainName: 是否需要验证域名, 默认 YES
        // 证书域名与请求域名不一致, 需要把该值设置为 NO
        // 用于客户端请求子域名, 而证书域名不一致, 因为 SSL 证书域名相互独立, 比如 www.google.com 为证书注册域名, main.google.com 无法验证通过, 土豪可注册通配符域名 *.google 无视该问题
        securityPolicy.validatesDomainName = NO;
        self.securityPolicy = securityPolicy;
        /// 支持解析
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", @"text/html; charset=UTF-8", nil];
        /// 开启网络监测
        AFNetworkActivityIndicatorManager.sharedManager.enabled = YES;
        [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusUnknown) {
                NSLog(@"未知网络");
            } else if (status == AFNetworkReachabilityStatusNotReachable) {
                NSLog(@"无网络");
            } else {
                NSLog(@"有网络");
            }
        }];
        [self.reachabilityManager startMonitoring];
     }
    return self;
}

/// 排队请求数据
- (RACSignal *)enqueueRequest:(CYHTTPRequest * _Nonnull)request resultClass:(Class _Nullable)resultClass {
    /// request 必须有值
    if (!request) return [RACSignal error:[NSError errorWithDomain:CYHTTPServiceErrorDomain code:-1 userInfo:nil]];
    @weakify(self);
    /// 覆盖请求序列化
    self.requestSerializer = [self requestSerializerWithRequest:request];
    /// 这里加上公共参数

    NSMutableDictionary * newParameters = request.urlParameters.parameters.mutableCopy;
    [newParameters addEntriesFromDictionary:request.urlParameters.constParameters.toJSONObject];
    /// 发起请求
    return [[self cy_requestPath:request.urlParameters.path parameters:newParameters method:request.urlParameters.method] reduceEach:^RACStream *(NSURLResponse * response, NSDictionary * responseObject) {
        @strongify(self);
        /// 请求成功, 解析数据
        return [[self parsedResponseOfClass:resultClass fromJSON:responseObject] map:^id _Nullable(id  _Nullable parsedResult) {
            CYHTTPResponse * parsedResponse = [CYHTTPResponse.alloc initWithResponseObject:responseObject parsedResult:parsedResult];
            NSAssert(parsedResponse != nil, @"Could not create CYHTTPResponse with response %@ and parsedResult %@", response, parsedResult);
            return parsedResponse;
        }];
    }].concat;
}

/// 上传数据 fileDatas: 要上传的文件数据, name: 服务器的资源文件名, mimeType: 文件资源类型 http://www.jianshu.com/p/a3e77751d37c 传 nil 默认为 application/octet-stream
- (RACSignal *)enqueueUploadRequest:(CYHTTPRequest * _Nonnull)request resultClass:(Class _Nullable)resultClass fileDatas:(NSArray <NSData *> *)fileDatas name:(NSString * _Nonnull)name mimeType:(NSString *)mimeType {
    /// request 必须有值
    if (!request) return [RACSignal error:[NSError errorWithDomain:CYHTTPServiceErrorDomain code:-1 userInfo:nil]];
    NSAssert(name.length > 0, @"name is empty: %@", name);
    @weakify(self);
    /// 覆盖请求序列化
    self.requestSerializer = [self requestSerializerWithRequest:request];
    /// 加上公共参数
    NSMutableDictionary * newParameters = request.urlParameters.parameters.mutableCopy;
    [newParameters addEntriesFromDictionary:request.urlParameters.constParameters.toJSONObject];
    /// 发起请求
    return [[self cy_POST:request.urlParameters.path parameters:newParameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSInteger count = fileDatas.count;
        for (int i = 0; i < count; i++) {
            /// 取出 fileData
            NSData * fileData = fileDatas[i];
            NSAssert([fileData isKindOfClass:NSData.class], @"fileData is not an NSData class: %@", fileDatas);
            /// 为避免重名问题用系统时间作为文件名
            static NSDateFormatter * formatter = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                formatter = NSDateFormatter.new;
            });
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString * dateStr = [formatter stringFromDate:NSDate.date];
            NSString * fileName = [NSString stringWithFormat:@"empty_%@_%d", dateStr, i];
            [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType.length ? mimeType :@"application/octet-stream"];
        }
    }] reduceEach:^RACStream *(NSURLResponse * response, NSDictionary * responseObject){
        @strongify(self);
        /// 请求成功, 解析数据
        return [[self parsedResponseOfClass:resultClass fromJSON:responseObject] map:^id _Nullable(id  _Nullable parsedResult) {
            CYHTTPResponse * parsedResponse = [CYHTTPResponse.alloc initWithResponseObject:responseObject parsedResult:parsedResult];
            NSAssert(parsedResponse != nil, @"Could not create CYHTTPResponse with response %@ and parsedResult %@", response, parsedResult);
            return parsedResponse;
        }];
    }].concat;
}

/// 解析数据
- (RACSignal *)parsedResponseOfClass:(Class)resultClass fromJSON:(NSDictionary *)responseObject {
    /// 必须是 CYDataModel 的子类
    NSParameterAssert((resultClass == nil || [resultClass isSubclassOfClass:CYDataModel.class]));
    responseObject = responseObject[CYHTTPServiceResponseDataKey];
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        if ([responseObject isKindOfClass:NSArray.class]) {
            if (resultClass == nil) {
                [subscriber sendNext:responseObject];
            } else {
                /// 数组保证里面装的是同一种 dict
                for (NSDictionary * dict in responseObject) {
                    if ([dict isKindOfClass:NSDictionary.class]) {
                        NSString * failureReason = [NSString stringWithFormat:NSLocalizedString(@"Invalid JSON array element: %@", @""), dict];
                        [subscriber sendError:[self parsingErrorWithFailureReason:failureReason]];
                        return nil;
                    }
                }
                /// 字典数组转模型
                NSArray * parsedObjects = [NSArray modelArrayWithClass:resultClass.class json:responseObject];
                /// 解析是否 CYDataModel 子类
                for (id parsedObject in parsedObjects) {
                    /// 确保歇息出来的类为 CYDataModel
                    NSAssert([parsedObject isKindOfClass:CYDataModel.class], @"Parsed model object is not an CYDataModel: %@", parsedObject);
                }
                [subscriber sendNext:parsedObjects];
            }
            [subscriber sendCompleted];
        } else if ([responseObject isKindOfClass:NSDictionary.class]) {
            /// 解析字典
            if (resultClass == nil) {
                [subscriber sendNext:responseObject];
            } else {
                /// 取出 data{"list":[]}
                NSArray * jsonArr = responseObject[CYHTTPServiceResponseDataListKey];
                if ([jsonArr isKindOfClass:NSArray.class]) {
                    /// 字典数组转模型
                    NSArray * parsedObjects = [NSArray modelArrayWithClass:resultClass.class json:jsonArr];
                    /// 解析是否 CYDataModel 子类
                    for (id parsedObject in parsedObjects) {
                        /// 确保歇息出来的类为 CYDataModel
                        NSAssert([parsedObject isKindOfClass:CYDataModel.class], @"Parsed model object is not an CYDataModel: %@", parsedObject);
                    }
                    [subscriber sendNext:parsedObjects];
                } else {
                    /// 字典转模型
                    CYDataModel * parsedObject = [resultClass modelWithDictionary:responseObject];
                    if (parsedObject == nil) {
                        NSError * error = [NSError errorWithDomain:@"" code:2222 userInfo:@{}];
                        [subscriber sendError:error];
                    }
                    NSAssert([parsedObject isKindOfClass:CYDataModel.class], @"Parsed model object is not an CYDataModel: %@", parsedObject);
                    [subscriber sendNext:parsedObject];
                }
            }
            [subscriber sendCompleted];
        } else if (responseObject == nil || [responseObject isKindOfClass:NSNull.class]) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        } else {
            NSString * failureReason = [NSString stringWithFormat:NSLocalizedString(@"Response wasn't an array or dictionary (%@): %@", @""), [responseObject class], responseObject];
            [subscriber sendError:[self parsingErrorWithFailureReason:failureReason]];
        }
        return nil;
    }];
}

/// 解析错误
- (NSError *)parsingErrorWithFailureReason:(NSString *)localizedFailureReason {
    NSMutableDictionary * userInfo = NSMutableDictionary.dictionary;
    userInfo[NSLocalizedDescriptionKey] = NSLocalizedString(@"Could not parse the service response.", @"");
    if (localizedFailureReason != nil) userInfo[NSLocalizedFailureReasonErrorKey] = localizedFailureReason;
    return [NSError errorWithDomain:CYHTTPServiceErrorDomain code:CYHTTPServiceErrorJSONParsingFailed userInfo:userInfo];
}

#pragma mark - 请求序列化
- (AFHTTPRequestSerializer *)requestSerializerWithRequest:(CYHTTPRequest *)request {
    /// 获取请求头参数
    AFHTTPRequestSerializer * serializer = AFHTTPRequestSerializer.serializer;
    NSDictionary * headerDic = request.urlParameters.constHeaderParameters.toJSONObject;
    if (headerDic) {
        for (NSString * httpHeaderField in headerDic.allKeys) {
            NSString * value = headerDic[httpHeaderField];
            [serializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    return serializer;
}

@end
