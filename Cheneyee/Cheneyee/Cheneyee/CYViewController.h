//
//  CYViewController.h
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/1.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//  所有自定义 viewController 的基类

#import <QMUIKit/QMUIKit.h>
#import "CYViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CYViewController : QMUICommonViewController

/// 创建 viewController 的方法, 子类中对 viewModel 属性直接声明并加上 @dynamic
- (instancetype)initWithViewModel:(CYViewModel *)viewModel;

// initWithViewModel: 时给的 viewModel;
@property (nonatomic, readonly, strong) CYViewModel * viewModel;

/// 此方法将在 initWithViewModel: 后执行
- (void)bindViewModel NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
