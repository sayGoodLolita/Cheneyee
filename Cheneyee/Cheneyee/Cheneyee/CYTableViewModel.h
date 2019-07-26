//
//  CYTableViewModel.h
//  CYKit
//
//  Created by Cheney Mars on 2019/7/10.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CYTableViewModel : CYViewModel

/// tableView 的数据源, 因 NSMutableArray 不支持 KVO, 使用 NSArray
@property (nonatomic, readwrite, copy) NSArray * dataSource;

/// tableView 初始化时的 style, 默认 UITableViewStylePlain
@property (nonatomic, readwrite, assign) UITableViewStyle style;

/// 是否支持下拉刷新, 默认 NO
@property (nonatomic, readwrite, assign) BOOL shouldPullDownToRefresh;

/// 是否支持上拉加载, 默认 NO
@property (nonatomic, readwrite, assign) BOOL shouldPullUpToLoadMore;

/// 是否有多个 section, 默认 NO
@property (nonatomic, readwrite, assign) BOOL shouldMultiSections;

/// 是否在没有更多数据时提示, 默认 NO
@property (nonatomic, readwrite, assign) BOOL shouldEndRefreshingWithNoMoreData;

/// 当前页, 默认 1
@property (nonatomic, readwrite, assign) NSUInteger page;

/// 每一页的数据, 默认 20
@property (nonatomic, readwrite, assign) NSUInteger perPage;

/// 选中 cell 的命令 (tableView:didSelectRowAtIndexPath:)
@property (nonatomic, readwrite, strong) RACCommand * didSelectCommand;

/// 当前页之前的所有数据
- (NSUInteger)offsetForPage:(NSUInteger)page;


@end

NS_ASSUME_NONNULL_END
