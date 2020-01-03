//
//  UINavigationController+CYEx.h
//  Cheneyee
//
//  Created by Cheney Mars on 2019/8/29.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//  控制侧滑手势以及导航栏显隐


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (CYEx)

@property (nonatomic, strong, readonly) UIPanGestureRecognizer * cy_popGestureRecognizer;

@property (nonatomic, assign) BOOL cy_navigationBarAppearanceEnabled;

@end

@interface UIViewController (CYEx)

/// 是否关闭侧滑返回(默认打开)
@property (nonatomic, assign) BOOL cy_popDisabled;

/// 是否隐藏导航栏(默认显示)
@property (nonatomic, assign) BOOL cy_navigationBarHidden;

@end

NS_ASSUME_NONNULL_END
