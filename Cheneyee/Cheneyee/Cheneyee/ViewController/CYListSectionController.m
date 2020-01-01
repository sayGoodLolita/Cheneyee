//
//  CYListSectionController.m
//  Player
//
//  Created by Cheney Mars on 2019/11/14.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYListSectionController.h"

@interface CYListSectionController ()

@property (nonatomic, strong) CYDataModel * model;

@end

@implementation CYListSectionController

- (void)didUpdateToObject:(id)object {
    self.model = object;
}

- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(self.collectionContext.containerSize.width, 44);
}

- (CYViewModel *)viewModel {
    return [(CYViewController *)self.viewController viewModel];
}

@end
