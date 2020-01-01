//
//  CYListViewController.h
//  test
//
//  Created by Cheney Mars on 2019/8/29.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//  所有 listViewController 的基类

#import "CYViewController.h"
#import <IGListKit/IGListKit.h>
#import "CYListSectionController.h"
#import "CYListViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CYListViewController : CYViewController <IGListAdapterDataSource>

@property (nonatomic, strong, readonly) IGListCollectionView * collectionView;

@property (nonatomic, strong, readonly) IGListAdapter * adapter;

@end

NS_ASSUME_NONNULL_END
