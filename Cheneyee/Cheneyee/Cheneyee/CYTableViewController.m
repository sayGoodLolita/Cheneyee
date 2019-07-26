//
//  CYTableViewController.m
//  CYKit
//
//  Created by Cheney Mars on 2019/7/11.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYTableViewController.h"
#import "CYNavigationController.h"
#import "UIScrollView+CYRefresh.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface CYTableViewController () <QMUINavigationControllerDelegate>

@property (nonatomic, readwrite, strong) CYTableViewModel * viewModel;

@end

@implementation CYTableViewController

// 当 viewModel 创建并调用 viewDidLoad: 时调用 bindViewModel
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    CYTableViewController * viewController = [super allocWithZone:zone];
    @weakify(viewController)
    [[viewController rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(viewController)
        [viewController bindViewModel];
    }];
    return viewController;
}

- (instancetype)initWithViewModel:(CYTableViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
        // 请求数据
        if (viewModel.shouldRequestRemoteDataOnViewDidLoad) {
            @weakify(self)
            [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
                @strongify(self)
                // 请求网络数据
                [self.viewModel.requestRemoteDataCommand execute:@1];
            }];
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 配置键盘
    IQKeyboardManager.sharedManager.enable = self.viewModel.keyboardEnable;
    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = self.viewModel.shouldResignOnTouchOutside;
    IQKeyboardManager.sharedManager.keyboardDistanceFromTextField = self.viewModel.keyboardDistanceFromTextField;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 发送 viewWillDisappear 的信号
    [self.viewModel.willDisappearSignal sendNext:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // backgroundColor
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)bindViewModel {
    // 这里只设置 navigationItemTitle, 不设置 tabBarItemTitle
    RAC(self.titleView , title) = RACObserve(self, viewModel.title);
    // 绑定错误信息
    [self.viewModel.errors subscribeNext:^(NSError * error) {
        // 这里可以统一处理某个错误, 例如用户授权失效的的操作
        NSLog(@"错误");
    }];
    // 观察 viewModel 的 dataSource
    @weakify(self)
    [RACObserve(self.viewModel, dataSource).deliverOnMainThread subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self reloadData];
    }];
}

- (void)initTableView {
    [super initTableView];
    // 添加加载和刷新控件
    if (self.viewModel.shouldPullDownToRefresh) {
        // 下拉刷新
        @weakify(self);
        [self.tableView cy_addHeaderRefresh:^(MJRefreshNormalHeader * header) {
            // 加载下拉刷新的数据
            @strongify(self);
            [self tableViewDidTriggerHeaderRefresh];
        }];
        [self.tableView.mj_header beginRefreshing];
    }
    if (self.viewModel.shouldPullUpToLoadMore) {
        // 上拉加载
        @weakify(self);
        [self.tableView cy_addFooterRefresh:^(MJRefreshAutoNormalFooter * footer) {
            // 加载上拉刷新的数据
            @strongify(self);
            [self tableViewDidTriggerFooterRefresh];
        }];
        /// 隐藏 footer or 无更多数据
        RAC(self.tableView.mj_footer, hidden) = [RACObserve(self.viewModel, dataSource).deliverOnMainThread map:^id _Nullable(NSArray *  _Nullable dataSource) {
            @strongify(self)
            NSUInteger count = dataSource.count;
            if (count == 0) return @1;
            if (self.viewModel.shouldEndRefreshingWithNoMoreData) return @0;
            return (count % self.viewModel.perPage) ? @1 : @0;
        }];
    }
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"CYTableViewCell"];
}

#pragma mark - 上下拉刷新事件
// 下拉事件
- (void)tableViewDidTriggerHeaderRefresh{
    @weakify(self)
    [[self.viewModel.requestRemoteDataCommand execute:@1].deliverOnMainThread subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.viewModel.page = 1;
        // 重置没有更多的状态
        if (self.viewModel.shouldEndRefreshingWithNoMoreData) [self.tableView.mj_footer resetNoMoreData];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        // 已经在 bindViewModel 中添加了对 viewModel.dataSource 的变化来刷新数据, 所有 reload = NO 即可
        [self.tableView.mj_header endRefreshing];
    } completed:^{
        @strongify(self)
        // 已经在 bindViewModel 中添加了对 viewModel.dataSource 的变化来刷新数据, 所有 reload = NO 即可
        [self.tableView.mj_header endRefreshing];
        // 请求完成
        [self requestDataCompleted];
    }];
}

// 上拉事件
- (void)tableViewDidTriggerFooterRefresh{
    @weakify(self);
    [[self.viewModel.requestRemoteDataCommand execute:@(self.viewModel.page + 1)].deliverOnMainThread subscribeNext:^(id x) {
        @strongify(self)
        self.viewModel.page += 1;
    } error:^(NSError * error) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshing];
    } completed:^{
        @strongify(self)
        [self.tableView.mj_footer endRefreshing];
        // 请求完成
        [self requestDataCompleted];
    }];
}

- (void)requestDataCompleted{
    NSUInteger count = self.viewModel.dataSource.count;
    // CoderMikeHe Fixed: 这里必须要等到, 底部控件结束刷新后, 再来设置无更多数据, 否则被叠加无效
    if (self.viewModel.shouldEndRefreshingWithNoMoreData && count % self.viewModel.perPage) [self.tableView.mj_footer endRefreshingWithNoMoreData];
}


- (void)dealloc {
    NSLog(@"对象被销毁");
}

- (void)reloadData {
    [self.tableView reloadData];
}

// dequeueReusableCellWithIdentifier:forIndexPath:
- (CYTableViewCell *)tableView:(QMUITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [CYTableViewCell.alloc initForTableView:tableView withReuseIdentifier:identifier];
}

// 配置 cell 的数据
- (void)configureCell:(CYTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.viewModel.shouldMultiSections) return self.viewModel.dataSource ? self.viewModel.dataSource.count : 0;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.viewModel.shouldMultiSections) return [self.viewModel.dataSource[section] count];
    return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CYTableViewCell * cell = [self tableView:(QMUITableView *)tableView dequeueReusableCellWithIdentifier:@"CYTableViewCell" forIndexPath:indexPath];
    // fetch object
    id object = nil;
    if (self.viewModel.shouldMultiSections) object = self.viewModel.dataSource[indexPath.section][indexPath.row];
    if (!self.viewModel.shouldMultiSections) object = self.viewModel.dataSource[indexPath.row];
    // 绑定 model
    [self configureCell:cell atIndexPath:indexPath withObject:(id)object];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // execute commond
    [self.viewModel.didSelectCommand execute:indexPath];
}

#pragma mark - QMUINavigationControllerDelegate
// 隐藏导航栏细线
- (UIImage *)navigationBarShadowImage {
    return self.viewModel.prefersNavigationBarBottomLineHidden ? UIImage.new : NavBarShadowImage;
}

// 使 QMUIKit 接管导航栏的显隐
- (BOOL)shouldCustomizeNavigationBarTransitionIfHideable {
    return YES;
}

// 是否隐藏导航栏
- (BOOL)preferredNavigationBarHidden {
    return self.viewModel.prefersNavigationBarHidden;
}

@end
