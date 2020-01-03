//
//  CYHTTPRequest.h
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/3.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//  网络请求对象, 可直接发起网络请求(不推荐)

#import <Foundation/Foundation.h>
#import "RACSignal+CYHTTPService.h"
#import "CYURLParameters.h"

NS_ASSUME_NONNULL_BEGIN

@interface CYHTTPRequest : NSObject

/// 请求参数
@property (nonatomic, strong, readonly) CYURLParameters * urlParameters;

/// 获取请求类
+ (instancetype)requestWithparameters:(CYURLParameters *)parameters;

/// 入队, class 必须为 CYDataModel, 方便 request 直接发起请求
- (RACSignal *)enqueueResultClass:(Class _Nullable)resultClass;

@end

NS_ASSUME_NONNULL_END
