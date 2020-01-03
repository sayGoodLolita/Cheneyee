//
//  CYNavigationController.h
//  CYKit
//
//  Created by Cheney Mars on 2019/7/10.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//  所有 navigationController 的基类

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYNavigationController : UINavigationController

/// 显示导航栏的细线
- (void)showNavigationBottomLine;

/// 隐藏导航栏的细线
- (void)hideNavigationBottomLine;

@end

NS_ASSUME_NONNULL_END
