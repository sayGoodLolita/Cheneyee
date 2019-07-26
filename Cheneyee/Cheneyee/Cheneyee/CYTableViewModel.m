//
//  CYTableViewModel.m
//  CYKit
//
//  Created by Cheney Mars on 2019/7/10.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYTableViewModel.h"

@implementation CYTableViewModel

- (void)initialize {
    [super initialize];
    self.page = 1;
    self.perPage = 20;
}

- (NSUInteger)offsetForPage:(NSUInteger)page {
    return (page - 1) * self.perPage;
}

@end
