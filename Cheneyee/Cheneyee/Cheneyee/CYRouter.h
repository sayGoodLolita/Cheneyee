//
//  CYRouter.h
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/1.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//  viewModel 转化 viewController 的路由

#import <Foundation/Foundation.h>
#import "CYViewController.h"
#import "CYTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CYRouter : NSObject

+ (instancetype)sharedInstance;

/// 根据 viewModel 创建一个 controller
- (CYViewController *)viewControllerForViewModel:(CYViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
