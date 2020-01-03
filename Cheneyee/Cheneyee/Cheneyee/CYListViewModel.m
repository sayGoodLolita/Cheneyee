//
//  CYListViewModel.m
//  test
//
//  Created by Cheney Mars on 2019/8/29.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYListViewModel.h"

@implementation CYListViewModel

- (void)initialize {
    [super initialize];
    self.dataSource = @[].mutableCopy;
    self.workingRangeSize = 0;
    self.page = 1;
    self.perPage = 20;
}


@end
