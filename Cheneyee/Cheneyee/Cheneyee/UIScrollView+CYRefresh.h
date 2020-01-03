//
//  UIScrollView+CYRefresh.h
//  Cheneyee
//
//  Created by Cheney Mars on 2019/6/30.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (CYRefresh)

/// 添加下拉刷新控件
- (MJRefreshNormalHeader *)cy_addHeaderRefresh:(void(^)(MJRefreshNormalHeader * header))refreshingBlock;

/// 添加上拉加载控件
- (MJRefreshAutoNormalFooter *)cy_addFooterRefresh:(void(^)(MJRefreshAutoNormalFooter * footer))refreshingBlock;

@end

NS_ASSUME_NONNULL_END
