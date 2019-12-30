//
//  CYWebViewModel.h
//  Player
//
//  Created by Cheney Mars on 2019/11/18.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CYWebViewModel : CYViewModel

/// web url request
@property (nonatomic, copy) NSURLRequest * request;

/// 是否支持下拉刷新, 默认 NO
@property (nonatomic, assign) BOOL shouldPullDownToRefresh;

/// 是否取消导航栏的 title 等于 webView 的 title, 默认 NO
@property (nonatomic, assign) BOOL shouldDisableWebViewTitle;

/// 是否取消关闭按钮, 默认 NO
@property (nonatomic, assign) BOOL shouldDisableWebViewClose;

@end

NS_ASSUME_NONNULL_END
