//
//  CYViewController.m
//  CYKit
//
//  Created by Cheney Mars on 2019/7/10.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "UINavigationController+CYEx.h"
#import "CYNavigationController.h"

@interface CYViewController ()

@property (nonatomic, strong) CYViewModel * viewModel;

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
    // 隐藏导航栏底线
    self.viewModel.navigationBarBottomLineHidden ? [(CYNavigationController *)self.navigationController hideNavigationBottomLine] : [(CYNavigationController *)self.navigationController showNavigationBottomLine];
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
    [self setupNavigationItems];
    [self initSubviews];
    // backgroundColor
    self.view.backgroundColor = UIColor.whiteColor;
    self.cy_navigationBarHidden = self.viewModel.navigationBarHidden;
    self.cy_popDisabled = self.viewModel.popDisabled;
}

- (void)bindViewModel {
    // 设置 navigationItemTitle
    RAC(self.navigationItem , title) = RACObserve(self, viewModel.title);
    // 绑定错误信息
    [self.viewModel.errors subscribeNext:^(NSError * error) {
        // 这里可以统一处理某个错误, 例如用户授权失效的的操作
        NSLog(@"错误");
    }];
}

- (void)setupNavigationItems {
    
}

- (void)initSubviews {
    
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)dealloc {
    NSLog(@"控制器被销毁");
}

@end
