//
//  CYHTTPResponse.h
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/3.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//  服务器下发的数据封装的 response 对象

#import "CYDataModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 请求数据返回的状态码
typedef NS_ENUM(NSUInteger, CYHTTPResponseCode) {
    CYHTTPResponseCodeSuccess = 200,    /// 请求成功
};
    
@interface CYHTTPResponse : CYDataModel

/// 服务器返回的 data, 无数据是 NSNull
@property (nonatomic, strong, readonly) id parsedResult;

/// 服务器返回的 code
@property (nonatomic, assign, readonly) CYHTTPResponseCode code;

/// 服务器返回的 msg
@property (nonatomic, copy, readonly) NSString * msg;

- (instancetype)initWithResponseObject:(id)responseObject parsedResult:(id)parsedResult;


@end

NS_ASSUME_NONNULL_END
