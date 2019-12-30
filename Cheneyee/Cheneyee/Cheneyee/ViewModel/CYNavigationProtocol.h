//
//  CYNavigationProtocol.h
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/1.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//  关于导航栏跳转 (push/pop,  present/dismiss) 的协议

#import <Foundation/Foundation.h>
#import "CYDataModel.h"

@class CYViewModel;

NS_ASSUME_NONNULL_BEGIN

@protocol CYNavigationProtocol <NSObject>

/// 根据 viewModel push 到 viewController
- (void)pushViewModel:(CYViewModel *)viewModel animated:(BOOL)animated;

/// pop 当前 viewController
- (void)popViewModelAnimated:(BOOL)animated;

/// pop 到 rootViewController
- (void)popToRootViewModelAnimated:(BOOL)animated;

/// 根据 viewModel present 到 viewController
- (void)presentViewModel:(CYViewModel *)viewModel animated:(BOOL)animated completion:(VoidBlock)completion;

/// dismiss 当前 viewController
- (void)dismissViewModelAnimated:(BOOL)animated completion:(VoidBlock)completion;

/// 设置 rootViewController
- (void)resetRootViewModel:(CYViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
