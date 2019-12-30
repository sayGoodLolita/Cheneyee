//
//  CYRouter.m
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/1.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYRouter.h"

@interface CYRouter ()

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

- (instancetype)init {
    self = [super init];
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            self.viewModelViewMappings = @{}.mutableCopy;
        });
    }
    return self;
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
    NSString * mapKey = NSStringFromClass(viewModel.class);
    NSString * viewController = self.viewModelViewMappings[mapKey];
    if (!viewController) {
        viewController = [mapKey stringByReplacingOccurrencesOfString:@"Model" withString:@"Controller"];
        [self.viewModelViewMappings setValue:viewController forKey:mapKey];
    }
    NSParameterAssert([NSClassFromString(viewController) isSubclassOfClass:CYViewController.class]);
    NSParameterAssert([NSClassFromString(viewController) instancesRespondToSelector:@selector(initWithViewModel:)]);
    return [[NSClassFromString(viewController) alloc] initWithViewModel:viewModel];
}

@end
