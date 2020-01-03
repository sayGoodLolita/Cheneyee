//
//  CYHTTPRequest.m
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/3.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYHTTPRequest.h"
#import "CYHTTPService.h"

@interface CYHTTPRequest ()

@property (nonatomic, strong) CYURLParameters * urlParameters;

@end

@implementation CYHTTPRequest

- (instancetype)initWithParameters:(CYURLParameters *)parameters {
    self = [super init];
    if (self) {
        self.urlParameters = parameters;
    }
    return self;
}

+ (instancetype)requestWithparameters:(CYURLParameters *)parameters {
    return [self.alloc initWithParameters:parameters];
}

/// 请求数据
- (RACSignal *)enqueueResultClass:(Class)resultClass {
    return [CYHTTPService.sharedInstance enqueueRequest:self resultClass:resultClass];
}

@end
