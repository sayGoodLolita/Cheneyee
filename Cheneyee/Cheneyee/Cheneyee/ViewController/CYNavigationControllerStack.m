//
//  CYNavigationControllerStack.m
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/1.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYNavigationControllerStack.h"
#import "CYNavigationController.h"
#import "CYTabBarController.h"
#import "CYRouter.h"

@interface CYNavigationControllerStack ()

@property (nonatomic, strong) id<CYViewModelServices> services;

/// 所有的导航视图控制器
@property (nonatomic, strong) NSMutableArray * navigationControllers;

@end

@implementation CYNavigationControllerStack

- (instancetype)initWithServices:(id<CYViewModelServices>)services {
    self = [super init];
    if (self) {
        self.services = services;
        self.navigationControllers = @[].mutableCopy;
        [self registerNavigationHooks];
    }
    return self;
}

- (void)pushNavigationController:(UINavigationController *)navigationController {
    if ([self.navigationControllers containsObject:navigationController]) return;
    [self.navigationControllers addObject:navigationController];
}

- (UINavigationController *)popNavigationController {
    UINavigationController * navigationController = self.navigationControllers.lastObject;
    [self.navigationControllers removeLastObject];
    return navigationController;
}

- (UINavigationController *)topNavigationController {
    return self.navigationControllers.lastObject;
}

- (void)registerNavigationHooks {
    @weakify(self)
    // 监听 services 执行的方法来用栈顶的 navigationController 进行界面跳转, 订阅的内容为参数打包的元组
    [[(NSObject *)self.services rac_signalForSelector:@selector(pushViewModel:animated:)] subscribeNext:^(RACTuple * _Nullable tuple) {
        @strongify(self)
        UIViewController * viewController = [CYRouter.sharedInstance viewControllerForViewModel:tuple.first];
        [self.navigationControllers.lastObject pushViewController:viewController animated:[tuple.second boolValue]];
    }];
    [[(NSObject *)self.services rac_signalForSelector:@selector(popViewModelAnimated:)] subscribeNext:^(RACTuple * _Nullable tuple) {
        @strongify(self)
        [self.navigationControllers.lastObject popViewControllerAnimated:[tuple.first boolValue]];
    }];
    [[(NSObject *)self.services rac_signalForSelector:@selector(popToRootViewModelAnimated:)] subscribeNext:^(RACTuple * _Nullable tuple) {
        @strongify(self)
        [self.navigationControllers.lastObject popToRootViewControllerAnimated:[tuple.first boolValue]];
    }];
    [[(NSObject *)self.services rac_signalForSelector:@selector(presentViewModel:animated:completion:)] subscribeNext:^(RACTuple * _Nullable tuple) {
        @strongify(self)
        UIViewController * viewController = (UIViewController *)[CYRouter.sharedInstance viewControllerForViewModel:tuple.first];
        CYNavigationController * presentingViewController = self.navigationControllers.lastObject;
        if (![viewController isKindOfClass:CYNavigationController.class]) {
            viewController = [CYNavigationController.alloc initWithRootViewController:viewController];
        }
        viewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self pushNavigationController:(UINavigationController *)viewController];
        [presentingViewController presentViewController:viewController animated:[tuple.second boolValue] completion:tuple.third];
    }];
    [[(NSObject *)self.services rac_signalForSelector:@selector(dismissViewModelAnimated:completion:)] subscribeNext:^(RACTuple * _Nullable tuple) {
        @strongify(self)
        [self popNavigationController];
        // 谁 present 了一个控制器, 谁就负责将此控制器 dismiss
        [self.navigationControllers.lastObject dismissViewControllerAnimated:[tuple.first boolValue] completion:tuple.second];
    }];
    [[(NSObject *)self.services rac_signalForSelector:@selector(resetRootViewModel:)] subscribeNext:^(RACTuple * _Nullable tuple) {
        @strongify(self)
        [self.navigationControllers removeAllObjects];
        UIViewController * viewController = [CYRouter.sharedInstance viewControllerForViewModel:tuple.first];
        if (![viewController isKindOfClass:UINavigationController.class] && ![viewController isKindOfClass:CYTabBarController.class]) {
            viewController = [CYNavigationController.alloc initWithRootViewController:viewController];
            [self pushNavigationController:(UINavigationController *)viewController];
        }
        // 外界 navigationController 或 tabBarController 来负责配置栈底
        UIApplication.sharedApplication.delegate.window.rootViewController = viewController;
    }];
}

@end
