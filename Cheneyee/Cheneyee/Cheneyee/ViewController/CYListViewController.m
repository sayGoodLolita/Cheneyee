//
//  CYListViewController.m
//  test
//
//  Created by Cheney Mars on 2019/8/29.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYListViewController.h"
#import "UIScrollView+CYRefresh.h"

@interface CYListViewController ()

@property (nonatomic, strong) CYListViewModel * viewModel;

@property (nonatomic, strong) IGListCollectionView * collectionView;

@property (nonatomic, strong) IGListAdapter * adapter;

@end

@implementation CYListViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)initSubviews {
    [super initSubviews];
    self.collectionView = [IGListCollectionView.alloc initWithFrame:self.view.bounds];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.collectionView];
    self.adapter = [IGListAdapter.alloc initWithUpdater:IGListAdapterUpdater.new viewController:self workingRangeSize:self.viewModel.workingRangeSize];
    self.adapter.dataSource = self;
    self.adapter.collectionView = self.collectionView;
    
    // 添加加载和刷新控件
    @weakify(self);
    if (self.viewModel.shouldPullDownToRefresh) {
        // 下拉刷新
        [self.collectionView cy_addHeaderRefresh:^(MJRefreshNormalHeader * header) {
            // 加载下拉刷新的数据
            @strongify(self);
            [self collectionViewDidTriggerHeaderRefresh];
        }];
        // 这里不再默认下拉刷新, 改为由 shouldRequestRemoteDataOnViewDidLoad 值确认
    }
    if (self.viewModel.shouldPullUpToLoadMore) {
        // 上拉加载
        [self.collectionView cy_addFooterRefresh:^(MJRefreshAutoNormalFooter * footer) {
            // 加载上拉刷新的数据
            @strongify(self);
            [self collectionViewDidTriggerFooterRefresh];
        }];
    }
}

#pragma mark - 上下拉刷新事件
// 下拉事件
- (void)collectionViewDidTriggerHeaderRefresh {
    @weakify(self)
      [[self.viewModel.requestRemoteDataCommand execute:@1].deliverOnMainThread subscribeNext:^(id  _Nullable x) {
          @strongify(self)
          self.viewModel.page = 1;
          // 重置没有更多的状态
          if (self.viewModel.shouldEndRefreshingWithNoMoreData) [self.collectionView.mj_footer resetNoMoreData];
      } error:^(NSError * _Nullable error) {
          @strongify(self)
          [self.collectionView.mj_header endRefreshing];
      } completed:^{
          @strongify(self)
          [self.collectionView.mj_header endRefreshing];
          // 请求完成
          [self requestDataCompleted];
      }];
}

// 上拉事件
- (void)collectionViewDidTriggerFooterRefresh {
    @weakify(self);
    [[self.viewModel.requestRemoteDataCommand execute:@(self.viewModel.page + 1)].deliverOnMainThread subscribeNext:^(id x) {
        @strongify(self)
        self.viewModel.page += 1;
    } error:^(NSError * error) {
        @strongify(self);
        [self.collectionView.mj_footer endRefreshing];
    } completed:^{
        @strongify(self)
        [self.collectionView.mj_footer endRefreshing];
        // 请求完成
        [self requestDataCompleted];
    }];
}

- (void)requestDataCompleted {
    NSUInteger count = self.viewModel.dataSource.count;
    // 这里必须要等到, 底部控件结束刷新后, 再来设置无更多数据, 否则被叠加无效
    if (self.viewModel.shouldEndRefreshingWithNoMoreData && count % self.viewModel.perPage) [self.collectionView.mj_footer endRefreshingWithNoMoreData];
}

- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self);
    self.viewModel.reloadCommand = [RACCommand.alloc initWithSignalBlock:^RACSignal * _Nonnull(NSNumber *  _Nullable animation) {
        @strongify(self);
        [self.adapter performUpdatesAnimated:animation.boolValue completion:nil];
        return RACSignal.empty;
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.viewModel.dataSource;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    IGListSectionController * sectionController = IGListSectionController.new;
    sectionController.inset = UIEdgeInsetsMake(0, 0, 0, 0);
    return sectionController;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
