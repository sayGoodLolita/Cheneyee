//
//  CYURLParameters.m
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/3.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYURLParameters.h"

@implementation CYURLParameters

+ (instancetype)urlParametersWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters {
    return [self.alloc initWithUrlParametersWithMethod:method path:path parameters:parameters];
}

- (instancetype)initWithUrlParametersWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters {
    self = [super init];
    if (self) {
        self.method = method;
        self.path = path;
        self.parameters = parameters;
        self.constParameters = CYConstParameters.new;
        self.constHeaderParameters = CYConstHeaderParameters.new;
    }
    return self;
}

@end
