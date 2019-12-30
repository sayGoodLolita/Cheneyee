//
//  UIBarButtonItem+CYEx.h
//  RingtoneMaker
//
//  Created by Cheney Mars on 2019/8/31.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//  快速创建 barButtonItem

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (CYEx)

+ (instancetype)itemWithImage:(NSString *)image command:(RACCommand *)command;

@end

NS_ASSUME_NONNULL_END
