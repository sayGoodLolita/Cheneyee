//
//  CYReflection.m
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/1.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYReflection.h"

SEL CYSelectorWithKeyPattern(NSString * key, const char * suffix) {
    NSUInteger keyLength = [key maximumLengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger suffixLength = strlen(suffix);
    char selector[keyLength + suffixLength + 1];
    BOOL success = [key getBytes:selector maxLength:keyLength usedLength:&keyLength encoding:NSUTF8StringEncoding options:0 range:NSMakeRange(0, key.length) remainingRange:NULL];
    if (!success) return NULL;
    memcpy(selector + keyLength, suffix, suffixLength);
    selector[keyLength + suffixLength] = '\0';
    return sel_registerName(selector);
}

SEL CYSelectorWithCapitalizedKeyPattern(const char * prefix, NSString * key, const char * suffix) {
    NSUInteger prefixLength = strlen(prefix);
    NSUInteger suffixLength = strlen(suffix);
    NSString * initial = [key substringToIndex:1].uppercaseString;
    NSUInteger initialLength = [initial maximumLengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSString * rest = [key substringFromIndex:1];
    NSUInteger restLength = [rest maximumLengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    char selector[prefixLength + initialLength + restLength + suffixLength + 1];
    memcpy(selector, prefix, prefixLength);
    BOOL success = [initial getBytes:selector + prefixLength maxLength:initialLength usedLength:&initialLength encoding:NSUTF8StringEncoding options:0 range:NSMakeRange(0, initial.length) remainingRange:NULL];
    if (!success) return NULL;
    success = [rest getBytes:selector + prefixLength + initialLength maxLength:restLength usedLength:&restLength encoding:NSUTF8StringEncoding options:0 range:NSMakeRange(0, rest.length) remainingRange:NULL];
    if (!success) return NULL;
    memcpy(selector + prefixLength + initialLength + restLength, suffix, suffixLength);
    selector[prefixLength + initialLength + restLength + suffixLength] = '\0';
    return sel_registerName(selector);
}

