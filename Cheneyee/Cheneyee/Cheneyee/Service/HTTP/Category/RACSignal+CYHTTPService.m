//
//  RACSignal+CYHTTPService.m
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/3.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "RACSignal+CYHTTPService.h"
#import "CYHTTPResponse.h"

@implementation RACSignal (CYHTTPService)

- (RACSignal *)cy_parsedResults {
    return [self map:^id _Nullable(CYHTTPResponse *  _Nullable response) {
        NSAssert([response isKindOfClass:CYHTTPResponse.class], @"Expected %@ to be an CYHTTPResponse.", response);
        return response.parsedResult;
    }];
}

@end
