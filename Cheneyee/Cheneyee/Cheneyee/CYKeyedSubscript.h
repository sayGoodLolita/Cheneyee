//
//  CYKeyedSubscript.h
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/3.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//  网络请求的参数

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYKeyedSubscript : NSObject

+ (instancetype)subscript;

/// 拼接一个字典
+ (instancetype)subscriptWithDictionary:(NSDictionary *)dict;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (id)objectForKeyedSubscript:(id)key;

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

/// 转换为字典
- (NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
