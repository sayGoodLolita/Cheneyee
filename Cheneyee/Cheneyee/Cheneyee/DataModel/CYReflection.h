//
//  CYReflection.h
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/1.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//  创建方法

#import <Foundation/Foundation.h>

/// 从 key 和 suffix 创建 SEL
SEL CYSelectorWithKeyPattern(NSString * key, const char * suffix) __attribute__((pure, nonnull(1, 2)));

/// 从 key 和 prefix, suffix 创建 SEL
SEL CYSelectorWithCapitalizedKeyPattern(const char * prefix, NSString * key, const char * suffix) __attribute__((pure, nonnull(1, 2, 3)));

