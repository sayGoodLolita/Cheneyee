//
//  CYAppStorePay.h
//  FFmpeg-Cheneyee
//
//  Created by Cheney on 2019/12/27.
//  Copyright © 2019 Cheney. All rights reserved.
//  苹果内购

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
@import StoreKit;

NS_ASSUME_NONNULL_BEGIN

@interface CYAppStorePay : NSObject

+ (instancetype)sharedInstance;

/// 购买产品, SKPaymentTransaction * transaction
- (RACSignal *)buyProduct:(NSString *)productIdentifier;

/// 恢复购买产品, NSArray<SKPaymentTransaction *>
- (RACSignal *)restoreProduct;

/// 掉单处理, SKPaymentTransaction * transaction
- (RACSignal *)unusualTransactions;

/// 检查收据, 建议在服务端处理而不是调用此方法
- (RACSignal *)checkReceipt:(NSData *)receipt sharedSecret:(NSString *)secret;

/// 获取产品价格
- (RACSignal *)localePrice:(SKProduct *)product;


@end

NS_ASSUME_NONNULL_END
