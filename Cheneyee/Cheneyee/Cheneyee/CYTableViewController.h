//
//  CYTableViewController.h
//  CYKit
//
//  Created by Cheney Mars on 2019/7/11.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//  所有自定义 tableViewController 的基类

#import <QMUIKit/QMUIKit.h>
#import "CYTableViewModel.h"
#import "CYTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface CYTableViewController : QMUICommonTableViewController

/// 创建 viewController 的方法, 子类中对 viewModel 属性直接声明并加上 @dynamic
- (instancetype)initWithViewModel:(CYTableViewModel *)viewModel;

/// initWithViewModel: 时给的 viewModel;
@property (nonatomic, readonly, strong) CYTableViewModel * viewModel;

/// 此方法将在 initWithViewModel: 后执行
- (void)bindViewModel NS_REQUIRES_SUPER;

/// 刷新数据, 可以覆盖
- (void)reloadData;

/// dequeueReusableCellWithIdentifier:forIndexPath:
- (CYTableViewCell *)tableView:(QMUITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

/// 配置 cell 的数据
- (void)configureCell:(CYTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

@end

NS_ASSUME_NONNULL_END
