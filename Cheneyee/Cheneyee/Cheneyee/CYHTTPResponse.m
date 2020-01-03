//
//  CYHTTPResponse.m
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/3.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYHTTPResponse.h"
#import "CYHTTPServiceConstant.h"

@interface CYHTTPResponse ()

/// 服务器返回的 data, 无数据是 NSNull
@property (nonatomic, strong) id parsedResult;

/// 服务器返回的 code
@property (nonatomic, assign) CYHTTPResponseCode code;

/// 服务器返回的 msg
@property (nonatomic, copy) NSString * msg;

@end

@implementation CYHTTPResponse

- (instancetype)initWithResponseObject:(id)responseObject parsedResult:(id)parsedResult {
    self = [super init];
    if (self) {
        self.parsedResult = parsedResult ?: NSNull.null;
        self.code = [responseObject[CYHTTPServiceResponseCodeKey] integerValue];
        self.msg = responseObject[CYHTTPServiceResponseMsgKey];
    }
    return self;
}

@end
