//
//  CYURLParameters.h
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/3.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//  网络请求的所需的数据

#import <Foundation/Foundation.h>
#import "CYKeyedSubscript.h"
#import "CYHTTPServiceConstant.h"
#import "CYConstParameters.h"
#import "CYConstHeaderParameters.h"

NS_ASSUME_NONNULL_BEGIN

@interface CYURLParameters : NSObject

/// 路径 (v14/order)
@property (nonatomic, strong) NSString * path;
/// 参数列表
@property (nonatomic, strong) NSDictionary * parameters;
/// 请求方式
@property (nonatomic, strong) NSString * method;

/// 项目公共参数
@property (nonatomic, strong) CYConstParameters * constParameters;

/// 项目请求头参数
@property (nonatomic, strong) CYConstHeaderParameters * constHeaderParameters;


/// 参数配置
+ (instancetype)urlParametersWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters;

@end

NS_ASSUME_NONNULL_END
