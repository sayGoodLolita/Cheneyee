//
//  CYViewModel.h
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/1.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//  所有 viewModel 的基类

#import <Foundation/Foundation.h>
#import "CYViewModelServices.h"

NS_ASSUME_NONNULL_BEGIN

/// 传递 navigationTitle
FOUNDATION_EXTERN NSString * const CYViewModelTitleKey;

/// 传递 webView 的 request
FOUNDATION_EXTERN NSString * const CYViewModelRequestKey;

@interface CYViewModel : NSObject

/// 创建 viewModel 的方法, services: 服务总线, params: 传递给 viewModel 的参数
- (instancetype)initWithServices:(id<CYViewModelServices>)services params:(NSDictionary * _Nullable)params;

/// initWithServices:params: 时获得
@property (nonatomic, strong, readonly) id<CYViewModelServices> services;

/// initWithServices:params: 时获得
@property (nonatomic, strong, readonly) NSDictionary * params;

/// 导航栏 title
@property (nonatomic, copy) NSString * title;

/// 是否开启 largeTitles
@property (nonatomic, assign) BOOL largeTitles;

/// viewModel 中发生所有错误的 signal 对象
@property (nonatomic, strong, readonly) RACSubject * errors;

/// 是否在 viewDidLoad 时获取服务器数据, 默认 YES
@property (nonatomic, assign) BOOL shouldRequestRemoteDataOnViewDidLoad;

/// view 即将消失的 signal
@property (nonatomic, strong, readonly) RACSubject * willDisappearSignal;

/// pop 事件
@property (nonatomic, strong) RACCommand * popCommand;

/// 是否取消左滑 pop 的功能, 默认 NO
@property (nonatomic, assign) BOOL popDisabled;

/// 是否隐藏该控制器的导航栏, 默认 NO
@property (nonatomic, assign) BOOL navigationBarHidden;

/// 是否隐藏该控制器的导航栏底部的分割线, 默认 NO
@property (nonatomic, assign) BOOL navigationBarBottomLineHidden;

/// IQKeyboardManager
/// 是否让 IQKeyboardManager 的管理键盘的事件, 默认 YES
@property (nonatomic, assign) BOOL keyboardEnable;

/// 是否点击空白区域回收键盘, 默认 YES
@property (nonatomic, assign) BOOL shouldResignOnTouchOutside;

/// 键盘与 textField 的距离, 默认 10.0
@property (nonatomic, assign) CGFloat keyboardDistanceFromTextField;

/// 请求数据的命令, 传一个 NSNumber: page
@property (nonatomic, strong, readonly) RACCommand * requestRemoteDataCommand;

/// 此方法将在 initWithServices:params: 后执行, 可初始化数据
- (void)initialize NS_REQUIRES_SUPER;

/// 请求错误信息过滤
- (BOOL (^)(NSError * error))requestRemoteDataErrorsFilter;

/// 请求远程或本地数据 (可被子类覆盖)
- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page;

@end

NS_ASSUME_NONNULL_END
