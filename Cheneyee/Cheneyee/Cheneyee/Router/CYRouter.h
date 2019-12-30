//
//  CYRouter.h
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/1.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//  viewModel 转化 viewController 的路由

#import <Foundation/Foundation.h>
#import "CYViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CYRouter : NSObject

+ (instancetype)sharedInstance;

/// 根据 viewModel 创建一个 controller
- (CYViewController *)viewControllerForViewModel:(CYViewModel *)viewModel;

/// viewModel 到 viewController 的映射, 如果不设置会使用默认名字创建
@property (nonatomic, strong) NSMutableDictionary * viewModelViewMappings;

@end

NS_ASSUME_NONNULL_END
