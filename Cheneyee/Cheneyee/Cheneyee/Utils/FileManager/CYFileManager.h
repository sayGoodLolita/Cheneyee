//
//  CYFileManager.h
//  RingtoneMaker
//
//  Created by Cheney Mars on 2019/9/2.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cheneyee.h"


/// 获取路径
CG_INLINE NSString *
cy_path(NSURL * url) {
    return [url.absoluteString stringByReplacingOccurrencesOfString:@"file://" withString:@""].stringByRemovingPercentEncoding;
}

/// 获取当前时间戳
CG_INLINE NSString *
cy_timestamp(void) {
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
    return [NSString stringWithFormat:@"%0.f", date.timeIntervalSince1970];
}

/// 通过秒获取 00:00
NSString *
cy_getTime(NSInteger second);

#pragma mark - 沙盒目录
/// 沙盒路径
CG_INLINE NSString *
cy_sandboxPath(void) {
    return NSHomeDirectory();
}

/// 沙盒中 Documents 路径
CG_INLINE NSString *
cy_documentsPath(void) {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

/// 沙盒中 Library 路径
CG_INLINE NSString *
cy_libraryPath(void) {
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
}

/// 沙盒中 Library/Preferences 路径
CG_INLINE NSString *
cy_preferencesPath(void) {
    return [cy_libraryPath() stringByAppendingPathComponent:@"Preferences"];
}

/// 沙盒中 Library/Caches 路径
CG_INLINE NSString *
cy_cachesPath(void) {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
}

/// 沙盒中 tmp 路径
CG_INLINE NSString *
cy_tmpPath(void) {
    return NSTemporaryDirectory();
}

#pragma mark - 文件属性
/// 获取文件属性
CG_INLINE NSDictionary *
cy_fileAttributes(NSString * path) {
    return [NSFileManager.defaultManager attributesOfItemAtPath:path error:nil];
}

/// 获取文件大小
CG_INLINE NSString *
cy_fileSize(NSString * path) {
    return cy_fileAttributes(path)[NSFileSize];
}

/// 获取文件创建时间
CG_INLINE NSDate *
cy_fileCreateTime(NSString * path) {
    return cy_fileAttributes(path)[NSFileCreationDate];
}


/// 获取文件名
CG_INLINE NSString *
cy_fileName(NSString * path, BOOL suffix) {
    return suffix ? path.lastPathComponent : path.lastPathComponent.stringByDeletingPathExtension;
}

/// 获取文件后缀
CG_INLINE NSString *
cy_fileSuffix(NSString * path) {
    return path.pathExtension;
}

/// 文件重命名
BOOL
cy_reFileName(NSString * path, NSString * name);

/// 移动文件, 如果有同名文件则增加编号
BOOL
cy_moveFile(NSString * path, NSString * toPath);

/// 删除文件
CG_INLINE BOOL
cy_removeFile(NSString * path) {
    return [NSFileManager.defaultManager removeItemAtPath:path error:nil];
}

/// 创建文件夹
CG_INLINE BOOL
cy_createDirectory(NSString * path) {
    return [NSFileManager.defaultManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

/// 获取文件夹大小
NSNumber *
cy_sizeOfDirectory(NSString * path);


/// 遍历路径下所有文件
NSArray *
cy_filesInDirectory(NSString * path, BOOL deep);

/// 判断路径是否为文件夹
CG_INLINE BOOL
cy_isDirectory(NSString * path) {
    return cy_fileAttributes(path)[NSFileType] == NSFileTypeDirectory;
}


