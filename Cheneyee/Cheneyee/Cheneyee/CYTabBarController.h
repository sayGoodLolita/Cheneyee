//
//  CYTabBarController.h
//  CYKit
//
//  Created by Cheney Mars on 2019/7/11.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//  所有 tabBarController 的基类

#import <QMUIKit/QMUIKit.h>
#import "CYViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CYTabBarController : CYViewController

@property (nonatomic, strong, readonly) QMUITabBarViewController * tabBarController;

@end

NS_ASSUME_NONNULL_END
