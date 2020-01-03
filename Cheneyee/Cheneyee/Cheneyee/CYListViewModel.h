//
//  CYListViewModel.h
//  test
//
//  Created by Cheney Mars on 2019/8/29.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//  列表视图模型的基类 (使用 IGListKit, tableView 暂时废弃)

#import "CYViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CYListViewModel : CYViewModel

/// listView 的数据源
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, assign) NSInteger workingRangeSize;

/// 刷新数据
@property (nonatomic, strong) RACCommand * reloadCommand;

/// 是否支持下拉刷新, 默认 NO
@property (nonatomic, assign) BOOL shouldPullDownToRefresh;

/// 是否支持上拉加载, 默认 NO
@property (nonatomic, assign) BOOL shouldPullUpToLoadMore;

/// 是否在没有更多数据时提示, 默认 NO
@property (nonatomic, readwrite, assign) BOOL shouldEndRefreshingWithNoMoreData;

/// 当前页, 默认 1
@property (nonatomic, readwrite, assign) NSUInteger page;

/// 每一页的数据, 默认 20
@property (nonatomic, readwrite, assign) NSUInteger perPage;
  
@end

NS_ASSUME_NONNULL_END
