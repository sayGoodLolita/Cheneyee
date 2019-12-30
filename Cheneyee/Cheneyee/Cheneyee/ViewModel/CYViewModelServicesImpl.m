//
//  CYViewModelServicesImpl.m
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/1.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYViewModelServicesImpl.h"

@implementation CYViewModelServicesImpl
@synthesize client = _client;

- (instancetype)init {
    self = [super init];
    if (self) {
        _client = CYHTTPService.sharedInstance;
    }
    return self;
}

- (void)dismissViewModelAnimated:(BOOL)animated completion:(nonnull VoidBlock)completion {
    
}

- (void)popToRootViewModelAnimated:(BOOL)animated {
    
}

- (void)popViewModelAnimated:(BOOL)animated {
    
}

- (void)presentViewModel:(nonnull CYViewModel *)viewModel animated:(BOOL)animated completion:(nonnull VoidBlock)completion {
    
}

- (void)pushViewModel:(nonnull CYViewModel *)viewModel animated:(BOOL)animated {
    
}

- (void)resetRootViewModel:(CYViewModel *)viewModel {
    
}



@end
