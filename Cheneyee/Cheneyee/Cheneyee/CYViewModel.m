//
//  CYViewModel.m
//  Cheneyee
//
//  Created by Cheney Mars on 2019/7/1.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYViewModel.h"

NSString * const CYViewModelTitleKey = @"CYViewModelTitleKey";

NSString * const CYViewModelRequestKey = @"CYViewModelRequestKey";

@interface CYViewModel ()

/// 服务总线, initWithServices:params: 获得
@property (nonatomic, strong, readwrite) id<CYViewModelServices> services;

/// params, initWithServices:params: 获得
@property (nonatomic, strong) NSDictionary * params;

/// viewModel 中发生所有错误的 signal 对象
@property (nonatomic, strong) RACSubject * errors;

/// view 即将消失的 signal
@property (nonatomic, strong) RACSubject * willDisappearSignal;

/// 请求服务器数据的命令
@property (nonatomic, strong) RACCommand * requestRemoteDataCommand;

@end

@implementation CYViewModel

/// 当 viewModel 创建并调用 initWithServices:params: 时调用 initialize
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    CYViewModel * viewModel = [super allocWithZone:zone];
    @weakify(viewModel)
    [[viewModel rac_signalForSelector:@selector(initWithServices:params:)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(viewModel);
        [viewModel initialize];
    }];
    /// 请求数据
    viewModel.requestRemoteDataCommand = [RACCommand.alloc initWithSignalBlock:^RACSignal * _Nonnull(NSNumber * page) {
        @strongify(viewModel);
        return [[viewModel requestRemoteDataSignalWithPage:page.unsignedIntegerValue] takeUntil:self.rac_willDeallocSignal];
    }];
    /// 过滤错误信息
    [[viewModel.requestRemoteDataCommand.errors filter:viewModel.requestRemoteDataErrorsFilter] subscribe:viewModel.errors];
    return viewModel;
}

/// 创建 viewModel 的方法, services: 服务总线, params: 传递给 viewModel 的参数
- (instancetype)initWithServices:(id<CYViewModelServices>)services params:(NSDictionary * _Nullable)params {
    self = [super init];
    if (self) {
        /// 默认在 viewDidLoad 里面加载服务器的数据
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
        /// 允许 IQKeyboardMananger 接管键盘弹出事件
        self.keyboardEnable = YES;
        self.shouldResignOnTouchOutside = YES;
        self.keyboardDistanceFromTextField = 10.0f;
        /// 赋值
        self.services = services;
        self.params = params;
        self.title = params[CYViewModelTitleKey];
        @weakify(self);
        self.popCommand = [RACCommand.alloc initWithSignalBlock:^RACSignal * _Nonnull(NSNumber *  _Nullable animation) {
            @strongify(self);
            [self.services popViewModelAnimated:animation.boolValue];
            return RACSignal.empty;
        }];
    }
    return self;
}

- (RACSubject *)errors {
    if (!_errors) _errors = RACSubject.subject;
    return _errors;
}

- (RACSubject *)willDisappearSignal {
    if (!_willDisappearSignal) _willDisappearSignal = RACSubject.subject;
    return _willDisappearSignal;
}

- (void)initialize {

}

- (BOOL (^)(NSError * error))requestRemoteDataErrorsFilter {
    return ^(NSError * error) {
        return YES;
    };
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    return RACSignal.empty;
}


@end
