//
//  AFHTTPSessionManager+CYSupport.m
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/3.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "AFHTTPSessionManager+CYSupport.h"
#import "CYHTTPServiceConstant.h"
#import "CYTools.h"

NSString *const RACAFNResponseObjectErrorKey = @"responseObject";

@implementation AFHTTPSessionManager (CYSupport)

- (RACSignal *)cy_GET:(NSString *)path parameters:(id)parameters {
    return [[self cy_requestPath:path parameters:parameters method:@"GET"] setNameWithFormat:@"%@ -cy_GET: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)cy_HEAD:(NSString *)path parameters:(id)parameters {
    return [[self cy_requestPath:path parameters:parameters method:@"HEAD"] setNameWithFormat:@"%@ -cy_HEAD: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)cy_POST:(NSString *)path parameters:(id)parameters {
    return [[self cy_requestPath:path parameters:parameters method:@"POST"] setNameWithFormat:@"%@ -cy_POST: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)cy_PUT:(NSString *)path parameters:(id)parameters {
    return [[self cy_requestPath:path parameters:parameters method:@"PUT"] setNameWithFormat:@"%@ -cy_PUT: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)cy_PATCH:(NSString *)path parameters:(id)parameters {
    return [[self cy_requestPath:path parameters:parameters method:@"PATCH"] setNameWithFormat:@"%@ -cy_PATCH: %@, parameters: %@", self.class, path, parameters];    
}

- (RACSignal *)cy_DELETE:(NSString *)path parameters:(id)parameters {
    return [[self cy_requestPath:path parameters:parameters method:@"DELETE"] setNameWithFormat:@"%@ -cy_DELETE: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)cy_requestPath:(NSString *)path parameters:(id)parameters method:(NSString *)method {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        // 获取 request 对象
        NSError * serializationError = nil;
        NSURLRequest * request =  [self.requestSerializer requestWithMethod:method URLString:[NSURL URLWithString:path relativeToURL:self.baseURL].absoluteString parameters:parameters error:&serializationError];
        if (serializationError) {
            /// 出现错误
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                [subscriber sendError:serializationError];
            });
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }
        NSURLSessionDataTask * task = [self dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                NSMutableDictionary * userInfo = error.userInfo.mutableCopy;
                if (responseObject) {
                    userInfo[RACAFNResponseObjectErrorKey] = responseObject;
                }
                NSError * errorWithRes = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo.copy];
                [subscriber sendError:errorWithRes];
            } else {
                /// 断言
                NSAssert([responseObject isKindOfClass:NSDictionary.class], @"responseObject is not an NSDictionary: %@", responseObject);
                [subscriber sendNext:RACTuplePack(response, responseObject)];
                [subscriber sendCompleted];
            }
        }];
        [task resume];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }].replayLazily;
}

- (RACSignal *)cy_POST:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> _Nonnull))block {
    return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        /// 获取 request 对象
        NSError * serializationError = nil;
        NSMutableURLRequest * request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[NSURL URLWithString:path relativeToURL:self.baseURL].absoluteString parameters:parameters constructingBodyWithBlock:block error:&serializationError];
        if (serializationError) {
            /// 出现错误
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                [subscriber sendError:serializationError];
            });
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }
        NSURLSessionDataTask * task = [self dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                NSMutableDictionary * userInfo = error.userInfo.mutableCopy;
                if (responseObject) {
                    userInfo[RACAFNResponseObjectErrorKey] = responseObject;
                }
                /// 这里可以解析错误
                NSError * errorWithRes = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo.copy];
                [subscriber sendError:errorWithRes];
            } else {
                [subscriber sendNext:RACTuplePack(response, responseObject)];
                [subscriber sendCompleted];
            }
        }];
        [task resume];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] setNameWithFormat:@"%@ -cy_POST: %@, parameters: %@, constructingBodyWithBlock", self.class, path, parameters];
}

- (RACSignal *)cy_POST:(NSString *)path body:(NSData *)body {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        AFURLSessionManager * manager = [AFURLSessionManager.alloc initWithSessionConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
        NSMutableURLRequest * request = [AFHTTPRequestSerializer.serializer requestWithMethod:@"POST" URLString:path parameters:nil error:nil];
        request.timeoutInterval = 20;
        request.HTTPBody = body;
        AFHTTPResponseSerializer * responseSerializer = AFHTTPResponseSerializer.serializer;
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", @"text/plain", nil];
        manager.responseSerializer = responseSerializer;
        NSURLSessionDataTask * task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                NSMutableDictionary * userInfo = error.userInfo.mutableCopy;
                if (responseObject) {
                    userInfo[RACAFNResponseObjectErrorKey] = responseObject;
                }
                /// 这里可以解析错误
                NSError * errorWithRes = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo.copy];
                [subscriber sendError:errorWithRes];
            } else {
                [subscriber sendNext:RACTuplePack(response, responseObject)];
                [subscriber sendCompleted];
            }
        }];
        [task resume];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }].replayLazily;
}

- (RACSignal *)cy_POST:(NSString *)path encryptParameters:(NSDictionary *)encryptParameters aKey:(NSString *)aKey {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSArray * sortKeys = [encryptParameters.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        NSString * signStr = @"";
        for(NSString * key in sortKeys) {
            NSString* value = [NSString stringWithFormat:@"%@", [encryptParameters objectForKey:key]];
            signStr = [NSString stringWithFormat:@"%@%@=%@&", signStr, [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*'\"();:@&=+$,/?%#[]% "].invertedSet], [value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*'\"();:@&=+$,/?%#[]% "].invertedSet]];
        }
        signStr = [signStr stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"&"]];
        NSData * body = [cy_encryptWithContent(signStr, 0, aKey) dataUsingEncoding:NSUTF8StringEncoding];
        AFURLSessionManager * manager = [AFURLSessionManager.alloc initWithSessionConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
        NSMutableURLRequest * request = [AFHTTPRequestSerializer.serializer requestWithMethod:@"POST" URLString:path parameters:nil error:nil];
        request.timeoutInterval = 20;
        request.HTTPBody = body;
        AFHTTPResponseSerializer * responseSerializer = AFHTTPResponseSerializer.serializer;
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", @"text/plain", nil];
        manager.responseSerializer = responseSerializer;
        NSURLSessionDataTask * task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                NSMutableDictionary * userInfo = error.userInfo.mutableCopy;
                if (responseObject) {
                    userInfo[RACAFNResponseObjectErrorKey] = responseObject;
                }
                /// 这里可以解析错误
                NSError * errorWithRes = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo.copy];
                [subscriber sendError:errorWithRes];
            } else {
                NSString * resultStrEncrypt = [NSString.alloc initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSString * resultStr = cy_encryptWithContent(resultStrEncrypt, 1, aKey);
                NSData * jsonData = [resultStr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary * result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                [subscriber sendNext:result];
                [subscriber sendCompleted];
            }
        }];
        [task resume];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }].replayLazily;
}


@end
