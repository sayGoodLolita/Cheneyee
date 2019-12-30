//
//  CYTools.h
//  CYRebatee
//
//  Created by Cheney Mars on 2019/10/3.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCryptor.h>

/// md5 加密
NSString *
cy_md5(NSString * inPutText);

/// 获取当前控制器
UIViewController *
cy_getCurrentVC(void);

/// 对称加密 (type = 0 为加密, type = 1 为解密)
NSString *
cy_encryptWithContent(NSString * content, CCOperation type, NSString * aKey);

/// base64 编码
NSString *
cy_base64(NSData * data);

/// 获取时间字符串 (yyyyMMddHHmmss)
CG_INLINE NSString *
cy_getDateStr(NSDate * date, NSString * format) {
    static NSDateFormatter * formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = NSDateFormatter.new;
    });
    formatter.dateFormat = format;
    return [formatter stringFromDate:date];
}

/// 获取时间 (yyyyMMddHHmmss)
CG_INLINE NSDate *
cy_getDate(NSString * dateStr, NSString * format) {
    static NSDateFormatter * formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = NSDateFormatter.new;
    });
    formatter.dateFormat = format;
    return [formatter dateFromString:dateStr];
}

/// 获取本地视频的缩略图
UIImage *
cy_getVideoFirstImage(NSString * path);

CG_INLINE BOOL
cy_isURLAddress(NSString * URL) {
    NSString * reg = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate * urlPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    return [urlPredicate evaluateWithObject:URL];
}


