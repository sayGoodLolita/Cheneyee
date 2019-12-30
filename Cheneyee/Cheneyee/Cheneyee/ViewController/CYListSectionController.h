//
//  CYListSectionController.h
//  Player
//
//  Created by Cheney Mars on 2019/11/14.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import <IGListKit/IGListKit.h>
#import "CYViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CYListSectionController : IGListSectionController

@property (nonatomic, strong, readonly) CYDataModel * model;

@property (nonatomic, strong, readonly) CYViewModel * viewModel;

@end

NS_ASSUME_NONNULL_END
