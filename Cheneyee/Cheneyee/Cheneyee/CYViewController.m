//
//  CYViewController.m
//  CYKit
//
//  Created by Cheney Mars on 2019/7/10.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//  缺少移除 pop 方法

#import "CYViewController.h"
#import "CYNavigationController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface CYViewController () <QMUINavigationControllerDelegate>

@property (nonatomic, readwrite, strong) CYViewModel * viewModel;

@end

@implementation CYViewController

// 当 viewModel 创建并调用 viewDidLoad: 时调用 bindViewModel
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    CYViewController * viewController = [super allocWithZone:zone];
    @weakify(viewController)
    [[viewController rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(viewController)
        [viewController bindViewModel];
    }];

    return viewController;
}

- (instancetype)initWithViewModel:(CYViewModel *)viewModel {
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
}

- (void)dealloc {
    NSLog(@"对象被销毁");
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
