//
//  RACSignal+CYHTTPService.h
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/3.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//  直接拿到接口数据中的 data

#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface RACSignal (CYHTTPService)

/// 获取下发数据的 data
- (RACSignal *)cy_parsedResults;

@end

NS_ASSUME_NONNULL_END
