//
//  CYViewController.h
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/1.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//  所有 viewController 的基类

#import <UIKit/UIKit.h>
#import "CYViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CYViewController : UIViewController

/// 创建 viewController 的方法, 子类中对 viewModel 属性直接声明并加上 @dynamic
- (instancetype)initWithViewModel:(CYViewModel *)viewModel;

// initWithViewModel: 时给的 viewModel
@property (nonatomic, strong, readonly) CYViewModel * viewModel;

/// 此方法将在 initWithViewModel: 后执行
- (void)bindViewModel NS_REQUIRES_SUPER;

/// 设置导航栏(用于分离)
- (void)setupNavigationItems NS_REQUIRES_SUPER;

// 设置子视图(用于分离)
- (void)initSubviews NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
