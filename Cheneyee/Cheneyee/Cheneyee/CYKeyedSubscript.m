//
//  CYKeyedSubscript.m
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/3.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYKeyedSubscript.h"

@interface CYKeyedSubscript ()

/// 字典
@property (nonatomic, strong) NSMutableDictionary * kvs;

@end

@implementation CYKeyedSubscript

+ (instancetype)subscript {
    return self.new;
}

/// 拼接一个字典
+ (instancetype)subscriptWithDictionary:(NSDictionary *)dict {
    return [self.alloc initWithDictionary:dict];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.kvs = @{}.mutableCopy;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self.kvs addEntriesFromDictionary:dict];
    }
    return self;
}

- (id)objectForKeyedSubscript:(id)key {
    return key ? self.kvs[key] : nil;
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key {
    if (key) {
        if (obj) {
            self.kvs[key] = obj;
        } else {
            [self.kvs removeObjectForKey:key];
        }
    }
}

/// 转换为字典
- (NSDictionary *)dictionary {
    return self.kvs.copy;
}

@end
