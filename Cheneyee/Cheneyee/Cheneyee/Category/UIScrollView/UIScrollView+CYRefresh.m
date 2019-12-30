//
//  UIScrollView+CYRefresh.m
//  Cheneyee
//
//  Created by Cheney Mars on 2019/6/30.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "UIScrollView+CYRefresh.h"

@implementation UIScrollView (CYRefresh)

/// 添加下拉刷新控件
- (MJRefreshNormalHeader *)cy_addHeaderRefresh:(void(^)(MJRefreshNormalHeader * header))refreshingBlock {
    __weak __typeof(&*self) weakSelf = self;
    MJRefreshNormalHeader * mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __weak __typeof(&*weakSelf) strongSelf = weakSelf;
        !refreshingBlock?:refreshingBlock((MJRefreshNormalHeader *)strongSelf.mj_header);
    }];
    mj_header.lastUpdatedTimeLabel.hidden = YES;
    // Configure normal mj_header
    self.mj_header = mj_header;
    return mj_header;
}

/// 添加上拉加载控件
- (MJRefreshAutoNormalFooter *)cy_addFooterRefresh:(void(^)(MJRefreshAutoNormalFooter * footer))refreshingBlock {
    __weak __typeof(&*self) weakSelf = self;
    MJRefreshAutoNormalFooter * mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        __weak __typeof(&*weakSelf) strongSelf = weakSelf;
        !refreshingBlock?:refreshingBlock((MJRefreshAutoNormalFooter *)strongSelf.mj_footer);
    }];
    // Configure normal mj_footer
    [mj_footer setTitle:@"别拉了，已经到底了..." forState:MJRefreshStateNoMoreData];
    self.mj_footer = mj_footer;
    return mj_footer;
}


@end
