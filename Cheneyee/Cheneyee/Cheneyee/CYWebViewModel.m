//
//  CYWebViewModel.m
//  Player
//
//  Created by Cheney Mars on 2019/11/18.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYWebViewModel.h"

@implementation CYWebViewModel

- (instancetype)initWithServices:(id<CYViewModelServices>)services params:(NSDictionary *)params {
    self = [super initWithServices:services params:params];
    if (self) {
        self.request = params[CYViewModelRequestKey];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.navigationBarHidden = YES;
}

@end
