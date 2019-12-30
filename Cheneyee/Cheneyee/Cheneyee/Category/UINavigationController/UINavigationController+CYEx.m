//
//  UINavigationController+CYEx.m
//  Cheneyee
//
//  Created by Cheney Mars on 2019/8/29.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "UINavigationController+CYEx.h"
#import <objc/runtime.h>

typedef void (^CYViewControllerWillAppearBlock)(UIViewController * viewController, BOOL animated);

@interface CYExDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController * navigationController;

@end

@implementation CYExDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if (self.navigationController.viewControllers.count <= 1) return NO;

    UIViewController * topViewController = self.navigationController.viewControllers.lastObject;
    if (topViewController.cy_popDisabled) return NO;

    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) return NO;
    
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) return NO;
    
    return YES;
}

@end

@interface UIViewController (CYExPrivate)

@property (nonatomic, copy) CYViewControllerWillAppearBlock cy_willAppearBlock;

@end

@implementation UIViewController (CYExPrivate)

+ (void)load {
    Method originalMethod = class_getInstanceMethod(self, @selector(viewWillAppear:));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(cy_viewWillAppear:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)cy_viewWillAppear:(BOOL)animated {
    [self cy_viewWillAppear:animated];
    if (self.cy_willAppearBlock) self.cy_willAppearBlock(self, animated);
}

- (CYViewControllerWillAppearBlock)cy_willAppearBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCy_willAppearBlock:(CYViewControllerWillAppearBlock)block {
    objc_setAssociatedObject(self, @selector(cy_willAppearBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@implementation UINavigationController (CYEx)

+ (void)load {
    Method originalMethod = class_getInstanceMethod(self, @selector(pushViewController:animated:));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(cy_pushViewController:animated:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)cy_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.cy_popGestureRecognizer]) {
        
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.cy_popGestureRecognizer];

        NSArray * internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        self.cy_popGestureRecognizer.delegate = self.cy_popGestureRecognizerDelegate;
        [self.cy_popGestureRecognizer addTarget:internalTarget action:internalAction];

        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [self cy_setupViewControllerBasedNavigationBarAppearanceIfNeeded:viewController];
    
    [self cy_pushViewController:viewController animated:animated];
}

- (void)cy_setupViewControllerBasedNavigationBarAppearanceIfNeeded:(UIViewController *)appearingViewController {
    if (!self.cy_navigationBarAppearanceEnabled) return;
    
    __weak typeof(self) weakSelf = self;
    CYViewControllerWillAppearBlock block = ^(UIViewController * viewController, BOOL animated) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) [strongSelf setNavigationBarHidden:viewController.cy_navigationBarHidden animated:animated];
    };
    
    appearingViewController.cy_willAppearBlock = block;
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    if (disappearingViewController && !disappearingViewController.cy_willAppearBlock) {
        disappearingViewController.cy_willAppearBlock = block;
    }
}

- (CYExDelegate *)cy_popGestureRecognizerDelegate {
    CYExDelegate *delegate = objc_getAssociatedObject(self, _cmd);

    if (!delegate) {
        delegate = CYExDelegate.new;
        delegate.navigationController = self;
        
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

- (UIPanGestureRecognizer *)cy_popGestureRecognizer {
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);

    if (!panGestureRecognizer) {
        panGestureRecognizer = UIPanGestureRecognizer.new;
        panGestureRecognizer.maximumNumberOfTouches = 1;
        
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureRecognizer;
}

- (BOOL)cy_navigationBarAppearanceEnabled {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number) return number.boolValue;
    self.cy_navigationBarAppearanceEnabled = YES;
    return YES;
}

- (void)setCy_navigationBarAppearanceEnabled:(BOOL)enabled {
    SEL key = @selector(cy_navigationBarAppearanceEnabled);
    objc_setAssociatedObject(self, key, @(enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIViewController (CYEx)

- (BOOL)cy_popDisabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setCy_popDisabled:(BOOL)disabled {
    objc_setAssociatedObject(self, @selector(cy_popDisabled), @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)cy_navigationBarHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setCy_navigationBarHidden:(BOOL)hidden {
    objc_setAssociatedObject(self, @selector(cy_navigationBarHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

