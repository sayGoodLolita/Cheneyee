//
//  CYAppStorePay.m
//  FFmpeg-Cheneyee
//
//  Created by Cheney on 2019/12/27.
//  Copyright © 2019 Cheney. All rights reserved.
//

#import "CYAppStorePay.h"
#import "CYHTTPService.h"
#import "CYTools.h"

@interface CYAppStorePay () <SKProductsRequestDelegate, SKPaymentTransactionObserver>

/// 记录是否有新的购买信号产生
@property (nonatomic, strong) RACSubject * buySubject;

@end

@implementation CYAppStorePay

static CYAppStorePay * pay = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pay = self.new;
        pay.buySubject = RACSubject.subject;
        [SKPaymentQueue.defaultQueue addTransactionObserver:pay];
    });
    return pay;
}

/// 购买产品
- (RACSignal *)buyProduct:(NSString *)productIdentifier {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        [[self __requestProduct:productIdentifier] subscribeNext:^(SKProduct *  _Nullable product) {
            [[self __buyProduct:product] subscribeNext:^(SKPaymentTransaction *  _Nullable transaction) {
                [subscriber sendNext:transaction];
            } error:^(NSError * _Nullable error) {
                [subscriber sendError:error];
            } completed:^{
                [subscriber sendCompleted];
            }];
        } error:^(NSError * _Nullable error) {
            [subscriber sendError:error];
        } completed:^{
            NSLog(@"请求产品成功");
        }];
        return nil;
    }];
}

/// 掉单处理
- (RACSignal *)unusualTransactions {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        __block RACDisposable * disposable = [[self.__updatedTransactions takeUntil:self.buySubject] subscribeNext:^(SKPaymentTransaction *  _Nullable transaction) {
            if (transaction.error) {
                [subscriber sendError:transaction.error];
            } else {
                [subscriber sendNext:transaction];
                [subscriber sendCompleted];
            }
            [disposable dispose];
        }];
        return nil;
    }];
}

/// 恢复购买产品
- (RACSignal *)restoreProduct {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        [SKPaymentQueue.defaultQueue restoreCompletedTransactions];
        [[[[self rac_signalForSelector:@selector(paymentQueue:restoreCompletedTransactionsFailedWithError:) fromProtocol:@protocol(SKPaymentTransactionObserver)] merge: [self rac_signalForSelector:@selector(paymentQueueRestoreCompletedTransactionsFinished:) fromProtocol:@protocol(SKPaymentTransactionObserver)]] flattenMap:^__kindof RACSignal * _Nullable(RACTuple *  _Nullable tuple) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull mapSubscriber) {
                if (tuple.count > 1) {
                    // 恢复失败
                    [subscriber sendError:tuple.last];
                    return nil;
                }
                // 恢复成功
                SKPaymentQueue * queue = tuple.first;
                [subscriber sendNext:queue.transactions];
                [subscriber sendCompleted];
                return nil;
            }];
        }] subscribe:subscriber];
        return nil;
    }];
}

/// 检查收据, 建议在服务端处理而不是调用此方法
- (RACSignal *)checkReceipt:(NSData *)receipt sharedSecret:(NSString *)secret {
    if (!receipt) receipt = [NSData dataWithContentsOfURL:NSBundle.mainBundle.appStoreReceiptURL];
    NSError * error = nil;
    NSData * jsonData = secret.length ? [NSJSONSerialization dataWithJSONObject:@{@"receipt-data":cy_base64(receipt), @"password":secret} options:NSJSONWritingPrettyPrinted error:&error] : [NSJSONSerialization dataWithJSONObject:@{@"receipt-data":cy_base64(receipt)} options:NSJSONWritingPrettyPrinted error:&error];
    NSString * verifyReceiptURLStr;
#if DEBUG
    verifyReceiptURLStr = @"https://sandbox.itunes.apple.com/verifyReceipt";
#else
    verifyReceiptURLStr = @"https://buy.itunes.apple.com/verifyReceipt";
#endif
    return [[CYHTTPService.sharedInstance cy_POST:verifyReceiptURLStr body:jsonData] reduceEach:^RACStream *(NSURLResponse * response, NSData * responseObject) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSDictionary * result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            [subscriber sendNext:result];
            [subscriber sendCompleted];
            return nil;
        }];
    }].concat;
}

/// 获取产品价格
- (RACSignal *)localePrice:(SKProduct *)product {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        if (!product) {
            [subscriber sendError:[NSError errorWithDomain:@"" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"没有产品"}]];
            return nil;
        }
        NSNumberFormatter * formatter = NSNumberFormatter.new;
        formatter.formatterBehavior = NSNumberFormatterBehavior10_4;
        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
        formatter.locale = product.priceLocale;
        [subscriber sendNext:[formatter stringFromNumber:product.price]];
        return nil;
    }];
}

- (void)dealloc {
    [SKPaymentQueue.defaultQueue removeTransactionObserver:self];
}

#pragma mark - Private Method

/// 请求产品
- (RACSignal *)__requestProduct:(NSString *)productIdentifier {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        SKProductsRequest * request = [SKProductsRequest.alloc initWithProductIdentifiers:[NSSet setWithObject:productIdentifier]];
        request.delegate = self;
        [request start];
        [[[self rac_signalForSelector:@selector(productsRequest:didReceiveResponse:) fromProtocol:@protocol(SKProductsRequestDelegate)] flattenMap:^__kindof RACSignal * _Nullable(RACTuple * _Nullable value) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull mapSubscriber) {
                SKProductsResponse * response = value.last;
                if (response.products.count) {
                    [subscriber sendNext:response.products.firstObject];
                    [subscriber sendCompleted];
                } else {
                    [subscriber sendError:[NSError errorWithDomain:@"" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"没有找到产品, 请检查 productIdentifier"}]];
                }
                return [RACDisposable disposableWithBlock:^{
                    [request cancel];
                }];
            }];
        }] subscribe:subscriber];
        return nil;
    }];
}

- (RACSignal *)__buyProduct:(SKProduct *)product {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        [self.buySubject sendCompleted];
        SKPayment * payment = [SKPayment paymentWithProduct:product];
        [SKPaymentQueue.defaultQueue addPayment:payment];
        __block RACDisposable * disposable = [self.__updatedTransactions subscribeNext:^(SKPaymentTransaction *  _Nullable transaction) {
            if (transaction.error) {
                [subscriber sendError:transaction.error];
            } else {
                [subscriber sendNext:transaction];
                [subscriber sendCompleted];
            }
            [disposable dispose];
        }];
        return nil;
    }];
}

/// 产品购买状态信号
- (RACSignal *)__updatedTransactions {
    return [[self rac_signalForSelector:@selector(paymentQueue:updatedTransactions:) fromProtocol:@protocol(SKPaymentTransactionObserver)] flattenMap:^__kindof RACSignal * _Nullable(RACTuple * _Nullable value) {
        NSArray<SKPaymentTransaction *> * transactions = value.last;
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            for (SKPaymentTransaction * transaction in transactions) {
                switch (transaction.transactionState) {
                    case SKPaymentTransactionStatePurchasing:
                        // 用户正在购买
                        NSLog(@"正在购买...");
                        break;
                    case SKPaymentTransactionStatePurchased:
                        // 完成购买(已扣费)
                        [SKPaymentQueue.defaultQueue finishTransaction:transaction];
                        [subscriber sendNext:transaction];
                        break;
                    case SKPaymentTransactionStateFailed:
                        // 购买失败(未扣费)
                        if (transaction.error.code != SKErrorPaymentCancelled)
                            NSLog(@"不是用户取消了请求, error: %@, errorCode: %ld", transaction.error.localizedDescription, transaction.error.code);
                        [SKPaymentQueue.defaultQueue finishTransaction:transaction];
                        [subscriber sendNext:transaction];
                        break;
                    case SKPaymentTransactionStateRestored:
                        // 恢复购买(未扣费)
                        [SKPaymentQueue.defaultQueue finishTransaction:transaction];
                        [subscriber sendNext:transaction];
                        break;
                    case SKPaymentTransactionStateDeferred:
                        NSLog(@"状态未确定");
                        break;
                    default:
                        break;
                }
            }
            return nil;
        }];
    }];
}


#pragma mark - Useless Method

- (void)productsRequest:(nonnull SKProductsRequest *)request didReceiveResponse:(nonnull SKProductsResponse *)response {
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions API_AVAILABLE(ios(3.0), macos(10.7)) {
    
}

@end
