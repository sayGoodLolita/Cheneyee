//
//  CYReflection.h
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/1.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//  创建方法

#import <Foundation/Foundation.h>

/// 从 key 和 suffix 创建 SEL
/// key - The key to insert into the generated selector. This key should be in its natural case.
/// suffix - A string to append to the key as part of the selector.
/// Returns a selector, or NULL if the input strings cannot form a valid selector.
SEL CYSelectorWithKeyPattern(NSString * key, const char * suffix) __attribute__((pure, nonnull(1, 2)));

/// 从 key 和 prefix, suffix 创建 SEL
/// prefix - A string to prepend to the key as part of the selector.
/// key - The key to insert into the generated selector. This key should be in its natural case, and will have its first letter capitalized when inserted.
/// suffix - A string to append to the key as part of the selector.
/// Returns a selector, or NULL if the input strings cannot form a valid selector.
SEL CYSelectorWithCapitalizedKeyPattern(const char * prefix, NSString * key, const char * suffix) __attribute__((pure, nonnull(1, 2, 3)));

