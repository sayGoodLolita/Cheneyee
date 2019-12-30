//
//  CYNavigationControllerStack.h
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/1.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//  view 层维护一个 CYNavigationController 的堆栈: CYNavigationControllerStack, 不管是 push/pop, 还是 present/dismiss, 都用栈顶的 CYNavigationController 来执行导航操作, 且保证 present 的是一个 CYNavigationController.

#import <Foundation/Foundation.h>
#import "CYViewModelServices.h"

NS_ASSUME_NONNULL_BEGIN

@interface CYNavigationControllerStack : NSObject

/// 创建 stack 的方法, services: 服务总线
- (instancetype)initWithServices:(id<CYViewModelServices>)services;

/// tabBar 需要自己配置栈低
- (void)pushNavigationController:(UINavigationController *)navigationController;

- (UINavigationController *)popNavigationController;

- (UINavigationController *)topNavigationController;

@end

NS_ASSUME_NONNULL_END
