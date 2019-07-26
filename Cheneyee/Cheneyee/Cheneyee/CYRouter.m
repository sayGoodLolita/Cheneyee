//
//  CYRouter.m
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/1.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYRouter.h"

@interface CYRouter ()

/// viewModel 到 viewController 的映射
@property (nonatomic, copy) NSDictionary * viewModelViewMappings;

@end

@implementation CYRouter

static CYRouter * sharedInstance = nil;

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    return sharedInstance;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = self.new;
    });
    return sharedInstance;
}

- (CYViewController *)viewControllerForViewModel:(CYViewModel *)viewModel {
    NSString * viewController = self.viewModelViewMappings[NSStringFromClass(viewModel.class)];
    NSParameterAssert([NSClassFromString(viewController) isSubclassOfClass:CYViewController.class] || [NSClassFromString(viewController) isSubclassOfClass:CYTableViewController.class]);
    NSParameterAssert([NSClassFromString(viewController) instancesRespondToSelector:@selector(initWithViewModel:)]);
    return [[NSClassFromString(viewController) alloc] initWithViewModel:viewModel];
}

// 这里是 viewModel -> viewController 的映射
// If you use push, present, resetRootViewController, you must config this dict
- (NSDictionary *)viewModelViewMappings {
    return @{};
}


@end
