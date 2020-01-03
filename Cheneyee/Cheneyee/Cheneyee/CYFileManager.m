//
//  CYFileManager.m
//  RingtoneMaker
//
//  Created by Cheney Mars on 2019/9/2.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYFileManager.h"

/// 通过秒获取 00:00
NSString * cy_getTime(NSInteger seconds) {
    NSString * minute = [NSString stringWithFormat:@"%ld", seconds/60];
    minute =  minute.length == 1 ? [NSString stringWithFormat:@"0%@", minute] : minute;
    NSString * second = [NSString stringWithFormat:@"%ld", seconds%60];
    second =  second.length == 1 ? [NSString stringWithFormat:@"0%@", second] : second;
    return [NSString stringWithFormat:@"%@:%@", minute, second];
}

/// 文件重命名
BOOL cy_reFileName(NSString * path, NSString * name) {
    NSString * fileName = cy_fileName(path, NO);
    NSString * toPath = [path stringByReplacingOccurrencesOfString:fileName withString:name];
    return [NSFileManager.defaultManager moveItemAtPath:path toPath:toPath error:nil];
}

/// 移动文件, 如果有同名文件则增加编号
BOOL cy_moveFile(NSString * path, NSString * toPath) {
    return [NSFileManager.defaultManager moveItemAtPath:path toPath:toPath error:nil];
}

/// 获取文件夹大小
NSNumber * cy_sizeOfDirectory(NSString * path) {
    NSArray * subPaths = cy_filesInDirectory(path, YES);
    NSEnumerator * contentsEnumurator = subPaths.objectEnumerator;
    NSString * file;
    unsigned long long int folderSize = 0;
    while ((file = contentsEnumurator.nextObject)) {
        NSDictionary * fileAttrs = [NSFileManager.defaultManager attributesOfItemAtPath:[path stringByAppendingPathComponent:file] error:nil];
        folderSize += [fileAttrs[NSFileSize] intValue];
    }
    return [NSNumber numberWithUnsignedLongLong:folderSize];
}

/// 遍历路径下所有文件
NSArray *
cy_filesInDirectory(NSString * path, BOOL deep) {
    NSArray * files;
    NSError * error;
    if (deep) {
        NSArray * deepArr = [NSFileManager.defaultManager subpathsOfDirectoryAtPath:path error:&error];
        if (!error) files = deepArr;
        else files = nil;
    } else {
//        NSArray * shallowArr = [NSFileManager.defaultManager contentsOfDirectoryAtPath:path error:&error];
        NSArray * shallowArr = [NSFileManager.defaultManager contentsOfDirectoryAtURL:[NSURL fileURLWithPath:path] includingPropertiesForKeys:@[NSURLNameKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
        if (!error) files = shallowArr;
        else files = nil;
    }
    return files;
}
