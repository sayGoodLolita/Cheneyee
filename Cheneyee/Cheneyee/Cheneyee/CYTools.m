//
//  CYTools.m
//  CYRebatee
//
//  Created by Cheney Mars on 2019/10/3.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYTools.h"
#import <CommonCrypto/CommonDigest.h>
#import <Masonry/Masonry.h>
#import "GTMBase64.h"

/// 创建等宽 view
void cy_makeEqualWidthViews(NSArray * views, UIView * containerView, CGFloat LRpadding, CGFloat viewPadding) {
    UIView * lastView;
    for (UIView * view in views) {
        [containerView addSubview:view];
        if (lastView) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(containerView);
                make.left.equalTo(lastView.mas_right).offset(viewPadding);
                make.width.equalTo(lastView);
            }];
        } else {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(containerView).offset(LRpadding);
                make.top.bottom.equalTo(containerView);
            }];
        }
        lastView=view;
    }
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(containerView).offset(-LRpadding);
    }];
}

NSString * cy_md5(NSString * inPutText) {
    const char * cStr = inPutText.UTF8String;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
            ].lowercaseString;
}

UIViewController * cy_getCurrentVC() {
    UIViewController * result = nil;    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray * windows = UIApplication.sharedApplication.windows;
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIView * frontView = window.subviews[0];
    id nextResponder = frontView.nextResponder;
    if ([nextResponder isKindOfClass:UIViewController.class])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}

NSString * cy_base64(NSData * data) {
    return [GTMBase64 stringByEncodingData:data];
}

static const char * cy_encryptWithKeyAndType(const char * text, CCOperation encryptOperation, char * key) {
    NSString * textStr = [NSString stringWithCString:text encoding:NSUTF8StringEncoding];
    const void * dataIn;
    size_t dataInLength;
    if (encryptOperation == kCCDecrypt) {
        NSData * decryptData = [GTMBase64 decodeData:[textStr dataUsingEncoding:NSUTF8StringEncoding]];
        dataInLength = decryptData.length;
        dataIn = decryptData.bytes;
    } else {
        NSData * encryptData = [textStr dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = encryptData.length;
        dataIn = encryptData.bytes;
    }
    
    CCCryptorStatus ccStatus;
    uint8_t * dataOut = NULL;
    size_t dataOutAvailable = 0;
    size_t dataOutMoved = 0;
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc(dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 00, dataOutAvailable);
    const void * vkey = key;
    const void * iv = (const void *)key;
    ccStatus = CCCrypt(encryptOperation, kCCAlgorithmDES, kCCOptionPKCS7Padding, vkey, kCCKeySizeDES, iv, dataIn, dataInLength, dataOut, dataOutAvailable, &dataOutMoved);
    NSString * result = nil;
    if (encryptOperation == kCCDecrypt) {
        result = [NSString.alloc initWithData:[NSData dataWithBytes:dataOut length:dataOutMoved] encoding:NSUTF8StringEncoding];
    } else {
        NSData * data = [NSData dataWithBytes:dataOut length:dataOutMoved];
        result = cy_base64(data);
    }
    return result.UTF8String;
}

NSString * cy_encryptWithContent(NSString * content, CCOperation type, NSString * aKey) {
    const char * contentChar = content.UTF8String;
    char * keyChar =(char *)aKey.UTF8String;
    const char * miChar;
    miChar = cy_encryptWithKeyAndType(contentChar, type, keyChar);
    return  [NSString stringWithCString:miChar encoding:NSUTF8StringEncoding];
}
